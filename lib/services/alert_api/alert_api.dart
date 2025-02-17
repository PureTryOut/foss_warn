import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foss_warn/main.dart';
import 'package:foss_warn/services/alert_api/fpas.dart';
import 'package:foss_warn/services/alert_api/local.dart';

final alertApiProvider = Provider(
  (ref) {
    var useLocalApi = bool.tryParse(
          dotenv.get('USE_LOCAL_API', fallback: 'false'),
          caseSensitive: false,
        ) ??
        false;
    if (useLocalApi) {
      return LocalApi();
    }

    return FPASApi(serverUrl: userPreferences.fossPublicAlertServerUrl);
  },
);
