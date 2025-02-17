import 'dart:convert';
import 'dart:math';

import 'package:foss_warn/class/class_area.dart';
import 'package:foss_warn/class/class_bounding_box.dart';
import 'package:foss_warn/class/class_info.dart';
import 'package:foss_warn/class/class_warn_message.dart';
import 'package:foss_warn/enums/category.dart';
import 'package:foss_warn/enums/certainty.dart';
import 'package:foss_warn/enums/message_type.dart';
import 'package:foss_warn/enums/scope.dart';
import 'package:foss_warn/enums/severity.dart';
import 'package:foss_warn/enums/status.dart';
import 'package:foss_warn/enums/urgency.dart';
import 'package:foss_warn/services/api_handler.dart';

class LocalApi implements AlertAPI {
  final List<WarnMessage> _alerts = [
    WarnMessage(
      identifier: '1',
      publisher: 'FOSSWarn',
      sender: 'LocalApi',
      sent: '',
      status: Status.actual,
      messageType: MessageType.alert,
      scope: Scope.public,
      info: [
        Info(
          category: [Category.fire],
          event: 'Fire',
          urgency: Urgency.immediate,
          severity: Severity.extreme,
          certainty: Certainty.observed,
          headline: 'A fire has started',
          description: 'A local forest has caught fire',
          instruction: 'Close doors and windows',
          area: [
            Area(
              areaDesc: 'Your local area',
              geoJson: jsonEncode({
                "features": [
                  {
                    "geometry": {
                      // Circle, Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon
                      "type": "Polygon",
                      "coordinates": [
                        [
                          [0.0, 1.0]
                        ],
                        [
                          [10.0, 11.0]
                        ],
                      ],
                    },
                    "properties": {},
                  },
                ],
              }),
            ),
          ],
        ),
      ],
      notified: true,
      read: false,
    ),
  ];

  final List<String> _registeredAreas = [];

  @override
  Future<ServerSettings> fetchServerSettings({String? overrideUrl}) async {
    return ServerSettings(
      url: "http://localhost",
      version: "1.0.0",
      operator: "FOSSWarn",
      privacyNotice:
          "All alerts are fake and generated on device, no external server is contacted.",
      termsOfService: "Not applicable",
      congestionState: 0,
    );
  }

  @override
  Future<List<String>> getAlerts({required String subscriptionId}) async {
    return [
      for (var alert in _alerts) ...[
        alert.identifier,
      ]
    ];
  }

  @override
  Future<WarnMessage> getAlertDetail({required String alertId}) async {
    return _alerts.firstWhere((element) => element.identifier == alertId);
  }

  @override
  Future<void> sendHeartbeat({required String subscriptionId}) async {
    // noop
  }

  @override
  Future<String> registerArea({
    required BoundingBox boundingBox,
    required String unifiedPushEndpoint,
  }) async {
    var random = Random();

    while (true) {
      var areaId = random.nextInt(999999).toString();
      if (!_registeredAreas.contains(areaId)) {
        _registeredAreas.add(areaId);
        return areaId;
      }
    }
  }

  @override
  Future<void> unregisterArea({required String subscriptionId}) async {
    var index = _registeredAreas.indexOf(subscriptionId);
    if (index == -1) return;

    _registeredAreas.removeAt(index);
  }
}
