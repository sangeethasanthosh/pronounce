import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/screens/newTabbar.dart';
import 'package:happy_hearts_pet_care_services/screens/splashscreen.dart';
import 'package:happy_hearts_pet_care_services/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant/global.dart';

class VeganVidezApp extends StatelessWidget {
  final SharedPreferences prefs;
  VeganVidezApp(this.prefs);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: appColorGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: _handleCurrentScreen(prefs),
    );
  }

  Widget _handleCurrentScreen(SharedPreferences prefs) {
    String data = prefs.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    preferences = prefs;
    if (data == null) {
      return SplashScreen();
    } else {
      return TabbarScreen();
    }
  }
}
