import 'package:flutter/material.dart';
import 'package:foss_warn/MyPlaceDetailView.dart';
import 'package:foss_warn/MyPlacesView.dart';
import '../class/class_Place.dart';
import '../class/class_WarnMessage.dart';
import '../class/class_Geocode.dart';
import '../class/class_Area.dart';
import '../main.dart';
import 'package:provider/provider.dart';
import '../services/updateProvider.dart';
import 'DeletePlaceDialog.dart';
import '../services/saveAndLoadSharedPreferences.dart';
import '../services/listHandler.dart';

class MyPlaceCard extends StatelessWidget {
  final Place myPlace;
  const MyPlaceCard({Key? key, required this.myPlace}) : super(key: key);

  String checkForWarnings() {
    print("check for warnings");
    int countMessages = 0;
    print(warnMessageList.length);
    myPlace.warnings.clear();
    for (WarnMessage warnMessage in warnMessageList) {
      for (Area myArea in warnMessage.areaList) {
        for (Geocode myGeocode in myArea.geocodeList) {
          //print(name);
          if (myGeocode.geocodeName == myPlace.name) {
            countMessages++;
            myPlace.warnings.add(warnMessage);
          }
        }
        if(myArea.areaDesc.contains(myPlace.name)) {
          print("Area Decs contrains myPlace name:" + myPlace.name);
          if(myPlace.warnings.contains(warnMessage)) {
            print("Warn Messsage already in List");
            //warn messeage already in list from geocodename
          } else {
            print("add warning für: " + myPlace.name);
            countMessages++;
            myPlace.warnings.add(warnMessage);
          }
        }
      }
    }

    if (countMessages > 0) {
      myPlace.countWarnings = countMessages;

      if (countMessages > 1) {
        return "Es gibt ${countMessages.toString()} Warnungen";
      } else {
        return "Es gibt ${countMessages.toString()} Warnung";
      }
    } else {
      return "Keine Warnungen gefunden";
    }
  }

  Widget build(BuildContext context) {
    bool checkIfAllWarningsRead() {
      bool temp = true;
      for (WarnMessage myWarning in myPlace.warnings) {
        if (readWarnings.contains(myWarning.identifier)) {
          //warnung gelesen
        } else {
          // warnung nicht gelesen
          temp = false;
        }
      }
      print("Alle Meldungen gelesen?: " + temp.toString());
      return temp;
    }

    print("Es liegen für " + myPlace.name + " " + myPlace.countWarnings.toString() + " vor");
    for(WarnMessage myWarning in myPlace.warnings) {
      print("Warnung:" + myWarning.headline);
    }

    return Card(
      child: InkWell(
        onLongPress: () {
          print("Lösche");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeletePlaceDialog(myPlace: myPlace);
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_city),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myPlace.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text(checkForWarnings()),
                    ],
                  ),
                ],
              ),
              myPlace.countWarnings ==
                      0 //check the number of warnings and display check or warning
                  ? TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15)),
                      onPressed: () {},
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ))
                  : checkIfAllWarningsRead()
                      ? TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyPlaceDetailScreen(myPlace: myPlace)),
                            );
                          },
                          child: Icon(
                            Icons.mark_chat_read,
                            color: Colors.white,
                          ),
                        )
                      : TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(15)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyPlaceDetailScreen(myPlace: myPlace)),
                            );
                          },
                          child: Icon(
                            Icons.warning,
                            color: Colors.white,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
