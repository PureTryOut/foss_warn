import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// format the given date and time
/// except dataAndTime in format: 2022-12-14T12:32:16+01:00
/// or in format: Fri, 03.02.2023, 14:58
/// return as 14.12.2022 - 12:32:16 Uhr
String formatSentDate(String dateAndTime) {
  String day,
      month,
      year = "";
  String seconds,
      minutes,
      hours = "";

  try {
    // check if alert swiss or NINA
    if (dateAndTime.contains(",")) {
      // format Alert Swiss
      int comma = dateAndTime.indexOf(",");
      int commaEnd = dateAndTime.indexOf(",", comma + 3);
      String date = dateAndTime.substring(comma + 2, commaEnd);
      day = date.substring(0, 2);
      month = date.substring(3, 5);
      year = date.substring(6, 10);

      String time = dateAndTime.substring(commaEnd + 2);
      hours = time.substring(0, 2);
      minutes = time.substring(3, 5);
      seconds = "00";
    } else {
      // format NINA
      int space = dateAndTime.indexOf("T");
      String date = dateAndTime.substring(0, space);

      year = date.substring(0, 4);
      month = date.substring(5, 7);
      day = date.substring(8, 10);

      String time = dateAndTime.substring(space + 1, space + 9);

      seconds = time.substring(time.length - 2, time.length);
      minutes = time.substring(time.length - 5, time.length - 3);
      hours = time.substring(0, 2);
    }
    // return formatted date and time
    String correctDate =
        day.toString() + "." + month.toString() + "." + year.toString();
    String correctFormatTime =
        hours+ ":" + minutes + ":" + seconds + " Uhr";

    return correctDate + " - " + correctFormatTime;
  }
  catch (e) {
    print("Error while formatting date: $e");
    // can not format date and time - return unformatted string
    return dateAndTime;
  }
}

String translateCategory(String text, BuildContext context) {
  if (text == "Health" || text == "Contaminated drinking water"|| text == "Pollution de l’eau potable" ) {
    return AppLocalizations.of(context).explanation_health;
  } else if (text == "Infra") {
    return  AppLocalizations.of(context).explanation_infrastructure;
  } else if (text == "Fire" || text == "Forest fire" ||
      text == "Safety precautions Forest fires") {
    return  AppLocalizations.of(context).explanation_fire;
  } else if (text == "CBRNE") {
    return  AppLocalizations.of(context).explanation_CBRNE;
  } else if (text == "Other" || text == "Other incident") {
    return  AppLocalizations.of(context).explanation_other;
  } else if (text == "Safety") {
    return  AppLocalizations.of(context).explanation_safety;
  } else if (text == "Met") {
    return  AppLocalizations.of(context).explanation_weather;
  } else if (text == "Env" || text == "Drought" || text == "Geo") {
    return  AppLocalizations.of(context).explanation_environment;
  } else {
    return text;
  }
}

String translateMessageType(String text, BuildContext context) {
  if (text == "Update") {
    return AppLocalizations.of(context).explanation_warning_level_update;
  } else if (text == "Cancel") {
    return AppLocalizations.of(context).explanation_warning_level_all_clear;
  } else if (text == "Alert") {
    return AppLocalizations.of(context).explanation_warning_level_attention;
  } else {
    return text;
  }
}

Color chooseMessageTypeColor(String text) {
  if (text == "Update") {
    return Colors.blueAccent;
  } else if (text == "Cancel") {
    return Colors.green;
  } else if (text == "Alert") {
    return Colors.red;
  } else {
    return Colors.orangeAccent;
  }
}
Color chooseSeverityColor(String text) {
  if (text == "Minor") {
    return Colors.blueAccent;
  } else if (text == "Moderate") {
    return Colors.orange;
  } else if (text == "Extrem") {
    return Colors.deepOrange;
  } else if (text == "Severe") {
    return Colors.red;
  } else {
    return Colors.grey;
  }
}
/// translate the message Severity and return the german name
/// @todo: Add translation
String translateMessageSeverity(String text) {
  // remove potential whitespace
  text = text.trim().toLowerCase();
  if (text == "minor") {
    return "Gering";
  } else if (text == "moderate") {
    return "Mittel";
  } else if (text == "extreme") {
    return "Extrem";
  } else if (text == "severe") {
    return "Schwer";
  } else {
    return text;
  }
}

String translateMessageStatus(String text) {
  if (text == "Actual") {
    return "real";
  } else {
    return text;
  }
}

String translateMessageUrgency(String text) {
  if (text == "Immediate") {
    return "unmittelbar";
  } else {
    return text;
  }
}

String translateMessageCertainty(String text) {
  if (text == "Observed") {
    return "beobachtet";
  } else {
    return text;
  }
}