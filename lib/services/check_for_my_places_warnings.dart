import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foss_warn/class/class_fpas_place.dart';
import 'package:foss_warn/class/class_notification_service.dart';
import 'package:foss_warn/class/class_warn_message.dart';
import 'package:foss_warn/main.dart';
import 'package:foss_warn/services/api_handler.dart';
import 'package:foss_warn/services/list_handler.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class AlertRetrievalError implements Exception {}

/// Retrieve possible warnings for the given place
///
/// returns the place updated with any possible warnings
Future<Place> getWarningForPlace(Place place) async {
  Uri urlOverview =
      Uri.parse("${userPreferences.fossPublicAlertServerUrl}/alert/all");

  var response = await http.post(
    urlOverview,
    headers: {
      "Content-Type": "application/json",
      'user-agent': userPreferences.httpUserAgent
    },
    body: jsonEncode(
      {
        'subscription_id': place.subscriptionId,
      },
    ),
  );

  if (response.statusCode != 200) {
    throw AlertRetrievalError();
  }

  List<String> data = jsonDecode(utf8.decode(response.bodyBytes));

  final myTransformer = Xml2Json();
  // fetch every alert
  var warnings = <WarnMessage>[];
  for (String alertID in data) {
    Uri urlAlert = Uri.parse(
      "${userPreferences.fossPublicAlertServerUrl}/alert/$alertID",
    );
    var response = await http.get(
      urlAlert,
      headers: {"Content-Type": "application/json"},
    );

    myTransformer.parse(utf8.decode(response.bodyBytes));

    String json = myTransformer.toParker();
    Map<String, dynamic> alert = jsonDecode(json);

    var warning = WarnMessage.fromJsonFPAS(alert["alert"]);
    if (!place.warnings.contains(warning)) {
      warnings.add(warning);
    }
  }

  return place;
}

Future<void> getWarningsForPlaces({
  required MyPlacesService myPlacesService,
  required List<Place> places,
}) async {
  var updatedPlaces = await Future.wait([
    for (var place in places) ...[
      getWarningForPlace(place),
    ],
  ]);

  myPlacesService.set(updatedPlaces);
}

/// check all warnings if one of them is of a myPlace and if yes send a notification <br>
/// [true] if there are/is a warning - false if not <br>
Future<bool> checkForMyPlacesWarnings({
  required List<Place> places,
  required bool loadManually,
  required MyPlacesService myPlacesService,
}) async {
  bool returnValue = true;
  debugPrint("check for warnings");

  // get data first
  await callAPI(places);

  // inform user if he hasn't add any places yet
  // @todo move to own timed function or find solution to not show a notification if the app is started the first time
  // @todo add translation

  if (places.isEmpty && !userPreferences.isFirstStart) {
    await NotificationService.showNotification(
        id: 3,
        title:
            "Sie haben noch keine Orte hinterlegt", //@todo translate, add context first, notification_no_places_selected_title
        body:
            "Bitte kontrolieren Sie Ihre Orte.", //notification_no_places_selected_body
        payload: "no places selected",
        channel: "other");
  }

  for (Place myPlace in places) {
    // wait until every notification is send before saving the
    // myPlacesList with the new notified status
    await myPlace.sendNotificationForWarnings();
  }
  // save new notified status
  await myPlacesService.set(places);
  return returnValue; //@todo remove return value?
}
