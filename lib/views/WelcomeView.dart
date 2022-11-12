import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/welcomeScreenItems.dart';
import '../main.dart';
import 'SettingsView.dart';
import '../services/saveAndLoadSharedPreferences.dart';
import '../widgets/dialogs/DisclaimerDialog.dart';
import '../widgets/dialogs/privacyDialog.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  double currentPage = 0.0;
  final _pageViewController = new PageController();
  final platform = const MethodChannel('flutter.native/helper');

  @override
  Widget build(BuildContext context) {
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
    final isLastSlide = currentPage == welcomeScreenItems.length - 1;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageViewController,
              itemCount: welcomeScreenItems.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildSlide(index),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 70.0),
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: isLastSlide
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              showWelcomeScreen = false;
                            });
                            saveSettings();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ScaffoldView(),
                              ),
                            );
                          },
                          child: Text(
                            "Einrichtung beenden",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue))
                      : buildStepsIndicator(),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildSlide(int index) {
    WelcomeScreenItem item = welcomeScreenItems[index];

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.fitWidth,
                width: 220.0,
                height: 200.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(item.title,
                          style: TextStyle(
                              fontSize: 34.0,
                              fontWeight: FontWeight.w300,
                              height: 2.0)),
                      Text(
                        item.description,
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                            fontSize: 16.0,
                            height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildActionButtons(item.action)
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildActionButtons(String? action) {
    switch (action) {
      case "batteryOptimization":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => showIgnoreBatteryOptimizationDialog(),
              child: Text(
                "Akkuoptimerung ausschalten",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
            )
          ],
        );
      case "disclaimer":
        return Column(
          children: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: navigatorKey.currentContext!,
                  builder: (BuildContext context) => DisclaimerDialog(),
                );
              },
              child: Text(
                "Haftungsausschluss",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: navigatorKey.currentContext!,
                  builder: (BuildContext context) => PrivacyDialog(),
                );
              },
              child: Text(
                "Datenschutz",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        );
      default:
        return SizedBox(height: 50);
    }
  }

  Future<void> showIgnoreBatteryOptimizationDialog() async {
    try {
      await platform.invokeMethod("showIgnoreBatteryOptimizationDialog");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Widget buildStepsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          welcomeScreenItems.length,
          (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                    color: currentPage.round() == index
                        ? Color(0XFF256075)
                        : Color(0XFF256075).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.0)),
              )),
    );
  }
}
