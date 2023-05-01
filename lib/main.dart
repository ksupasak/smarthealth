import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_health/main_app/app.dart';

import 'flutter_openvidu_client/example/lib/app/utils/global_http_overrides.dart';

void main() {
  HttpOverrides.global = GlobalHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
