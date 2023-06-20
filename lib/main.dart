import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_health/station/app/utils/global_http_overrides.dart';
//import 'package:smart_health/station/main_app/app.dart';
import 'package:smart_health/myapp/myapp.dart';
// void main() {
//   HttpOverrides.global = GlobalHttpOverrides();
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     runApp(App());
//   });
// }

void main() {
  HttpOverrides.global = GlobalHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
