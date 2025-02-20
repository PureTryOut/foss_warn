import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foss_warn/class/class_unified_push_handler.dart';
import 'package:foss_warn/services/alert_api/fpas.dart';
import 'package:foss_warn/extensions/context.dart';
import 'package:foss_warn/views/dev_settings_view.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../services/url_launcher.dart';
import '../widgets/dialogs/choose_theme_dialog.dart';
import 'notification_settings_view.dart';
import 'introduction/introduction_view.dart';

import '../widgets/dialogs/font_size_dialog.dart';
import '../widgets/dialogs/sort_by_dialog.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController fpasServerURLController = TextEditingController();
  final _platform = const MethodChannel("flutter.native/helper");

  String? fpasUrlError;

  @override
  void initState() {
    frequencyController.text = userPreferences.frequencyOfAPICall.toString();
    fpasServerURLController.text = userPreferences.fossPublicAlertServerUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = context.localizations;
    var theme = Theme.of(context);

    const double indentOfCategoriesTitles = 15;

    final Map<int, String> startViewLabels = {
      0: localizations.settings_start_view_all_warnings,
      1: localizations.settings_start_view_only_my_places,
    };

    var alertApi = ref.read(alertApiProvider);
    var unifiedPushHandler = ref.read(unifiedPushHandlerProvider);

    void onUnifiedPushUrlChanged(String _) {
      fpasUrlError = null;

      setState(() {});
    }

    Future<void> onUnifiedPushUrlSubmitted(String newUrl) async {
      try {
        var serverSettings =
            await alertApi.fetchServerSettings(overrideUrl: newUrl);

        if (!context.mounted) return;
        unifiedPushHandler.setup(
          context: context,
          distributor: serverSettings.url,
        );

        userPreferences.fossPublicAlertServerUrl = serverSettings.url;
        userPreferences.fossPublicAlertServerOperator = serverSettings.operator;
        userPreferences.fossPublicAlertServerPrivacyNotice =
            serverSettings.privacyNotice;
        userPreferences.fossPublicAlertServerTermsOfService =
            serverSettings.termsOfService;

        fpasUrlError = null;
      } on NoDistributorSelected {
        // TODO(PureTryOut): be more specific with the errors to catch
        fpasUrlError =
            localizations.settings_foss_public_alert_server_enter_url_error;
      } on ClientException {
        print("WTF");
      }

      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: indentOfCategoriesTitles,
                top: indentOfCategoriesTitles,
              ),
              child: Text(
                localizations.settings_notification,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              title: Text(localizations.settings_android_notification_settings),
              onTap: () => _openNotificationSettings(),
            ),
            ListTile(
              title: Text(localizations.settings_app_notification_settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsView(),
                  ),
                );
              },
            ),
            const Divider(
              height: 50,
              indent: 15.0,
              endIndent: 15.0,
            ),
            _UnifiedPushSettings(
              urlFieldController: fpasServerURLController,
              urlError: fpasUrlError,
              onUrlChanged: onUnifiedPushUrlChanged,
              onUrlSubmitted: onUnifiedPushUrlSubmitted,
              leftIndent: indentOfCategoriesTitles,
            ),
            const Divider(
              height: 50,
              indent: 15.0,
              endIndent: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: indentOfCategoriesTitles),
              child: Text(
                localizations.settings_display,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              title: Text(localizations.settings_start_view),
              trailing: DropdownButton<int>(
                value: userPreferences.startScreen,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: theme.colorScheme.primary),
                underline: Container(
                  height: 2,
                  color: theme.colorScheme.primary,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    userPreferences.startScreen = newValue!;
                  });
                },
                items: [0, 1].map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(startViewLabels[value]!),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(localizations.settings_show_extended_metadata),
              trailing: Switch(
                value: userPreferences.showExtendedMetaData,
                onChanged: (value) {
                  setState(() {
                    userPreferences.showExtendedMetaData = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(localizations.settings_color_schema),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ChooseThemeDialog();
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.settings_font_size),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const FontSizeDialog();
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.settings_sorting),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const SortByDialog();
                  },
                );
              },
            ),
            const Divider(
              height: 50,
              indent: 15.0,
              endIndent: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: indentOfCategoriesTitles),
              child: Text(
                localizations.settings_extended_settings,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              title: Text((localizations.settings_show_welcome_dialog)),
              onTap: () {
                // TODO(PureTryOut): replace for go_router
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntroductionView(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(localizations.settings_dev_settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DevSettings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNotificationSettings() async {
    try {
      await _platform.invokeMethod("openNotificationSettings");
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}

class _UnifiedPushSettings extends StatelessWidget {
  const _UnifiedPushSettings({
    required this.urlFieldController,
    required this.urlError,
    required this.onUrlChanged,
    required this.onUrlSubmitted,
    this.leftIndent = 8.0,
  });

  final TextEditingController urlFieldController;
  final String? urlError;
  final void Function(String newUrl) onUrlChanged;
  final void Function(String newUrl) onUrlSubmitted;

  final double leftIndent;

  @override
  Widget build(BuildContext context) {
    var localizations = context.localizations;
    var theme = Theme.of(context);

    void onTermsOfServicesPressed() {
      launchUrlInBrowser(
        userPreferences.fossPublicAlertServerTermsOfService,
      );
    }

    void onPrivacyNotice() {
      launchUrlInBrowser(
        userPreferences.fossPublicAlertServerPrivacyNotice,
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftIndent),
          child: Text(
            localizations.settings_foss_public_alert_server_settings_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          title: TextField(
            controller: urlFieldController,
            decoration: InputDecoration(
              labelText: localizations
                  .settings_foss_public_alert_server_enter_url_label_text,
              errorText: urlError,
            ),
            onChanged: onUrlChanged,
            onSubmitted: onUrlSubmitted,
          ),
        ),
        if (userPreferences.fossPublicAlertServerOperator.isNotEmpty) ...[
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(
              localizations.settings_foss_public_alert_server_server_operator(
                userPreferences.fossPublicAlertServerOperator,
              ),
            ),
          ),
        ],
        if (userPreferences.fossPublicAlertServerTermsOfService.isNotEmpty) ...[
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: Text(
              localizations.settings_foss_public_alert_server_terms_of_service,
            ),
            onTap: onTermsOfServicesPressed,
          ),
        ],
        if (userPreferences.fossPublicAlertServerPrivacyNotice.isNotEmpty) ...[
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: Text(
              localizations.settings_foss_public_alert_server_privacy_notice,
            ),
            onTap: onPrivacyNotice,
          ),
        ],
      ],
    );
  }
}
