import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foss_warn/class/class_unified_push_handler.dart';
import 'package:foss_warn/services/list_handler.dart';
import 'package:unifiedpush/unifiedpush.dart';

final unifiedPushInitializationProvider = FutureProvider((ref) async {
  UnifiedPush.initialize(
    onNewEndpoint: UnifiedPushHandler.onNewEndpoint,
    onRegistrationFailed: UnifiedPushHandler.onRegistrationFailed,
    onUnregistered: UnifiedPushHandler.onUnregistered,
    onMessage: (message, instance) => UnifiedPushHandler.onMessage(
      message: message,
      instance: instance,
      getPlaces: () => ref.read(myPlacesProvider),
      myPlacesService: ref.read(myPlacesProvider.notifier),
    ),
  );
});
