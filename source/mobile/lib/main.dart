import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance().then(
    (prefs) {
      runApp(
        VeganVidezApp(prefs),
      );
    },
  );
}
