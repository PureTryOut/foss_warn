import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foss_warn/class/class_error_logger.dart';
import 'package:foss_warn/services/api_handler.dart';

import 'package:unifiedpush/constants.dart';
import 'package:unifiedpush/unifiedpush.dart';
import '../services/check_for_my_places_warnings.dart';
import 'package:foss_warn/main.dart';

final unifiedPushDistributorsFutureProvider = FutureProvider<List<String>>(
  (ref) async => UnifiedPush.getDistributors([featureAndroidBytesMessage]),
);

// Required during the introduction
final unifiedPushDistributorsProvider = Provider<List<String>>(
  (ref) => ref.watch(unifiedPushDistributorsFutureProvider).when(
        data: (data) => data,
        error: (error, stackTrace) => [],
        loading: () => [],
      ),
);

final unifiedPushHandlerProvider = Provider((ref) => UnifiedPushHandler());

final unifiedPushEndpointProvider = StateProvider<String?>((ref) => null);

class NoDistributorInstalled implements Exception {}

class NoDistributorSelected implements Exception {}

class FailedToRegisterToDistributor implements Exception {}

class UnifiedPushHandler {
  bool registered = false;
  String? endpoint;

  void onNewEndpoint(
    String endpoint,
    String instance, {
    required WidgetRef ref,
  }) {
    if (instance != userPreferences.unifiedPushInstance) {
      return;
    }

    registered = true;
    this.endpoint = endpoint;
    ref.read(unifiedPushEndpointProvider.notifier).state = endpoint;
  }

  void onRegistrationFailed(String instance) {
    // @todo error handling
    ErrorLogger.writeErrorLog(
      "class_unifiedPushHandler",
      "UnifiedPush registration failed",
      "",
    );
    debugPrint("Registration failed");
  }

  void onUnregistered(
    String instance, {
    required WidgetRef ref,
  }) {
    registered = false;
    endpoint = null;
    ref.read(unifiedPushEndpointProvider.notifier).state = null;
    // send unregister to server
    // @todo send unregister for each subscription
  }

  /// callback function to handle notification from unifiedPush
  Future<void> onMessage(
    AlertAPI alertApi,
    Uint8List message,
    String instance,
  ) async {
    if (instance != userPreferences.unifiedPushInstance) {
      return;
    }

    var payload = utf8.decode(message);
    if (!payload.contains("[DEBUG]") && !payload.contains("[HEARTBEAT]")) {
      await checkForMyPlacesWarnings(
        alertApi: alertApi,
        loadManually: true,
      );
    }
  }

  /// Register for push notifications
  Future<void> _register({required String distributor}) async {
    await UnifiedPush.saveDistributor(distributor);
    await UnifiedPush.registerApp(
      userPreferences.unifiedPushInstance,
      [featureAndroidBytesMessage],
    );

    // Wait for the registration to finish
    if (!registered) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(microseconds: 1));
        return !registered;
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw FailedToRegisterToDistributor(),
      );
    }
  }

  Future<void> setup({
    required BuildContext context,
    String? distributor,
  }) async {
    var registeredDistributor = await UnifiedPush.getDistributor();
    if (registeredDistributor != null && registeredDistributor.isNotEmpty) {
      return;
    }

    var distributors = await UnifiedPush.getDistributors();
    String? pickedDistributor;
    if (distributors.isNotEmpty) {
      pickedDistributor = distributors.first;

      if (distributor != null) {
        pickedDistributor =
            distributors.firstWhere((element) => element == distributor);
      }
    }

    if (pickedDistributor == null) {
      throw NoDistributorSelected();
    }

    if (!context.mounted) return;
    await _register(distributor: pickedDistributor);
  }
}
