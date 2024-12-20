import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openvidu_client_example/app/pages/room_page.dart';
import 'package:openvidu_client_example/app/pages/video.dart';

import 'app/pages/connect_page.dart';
import 'app/utils/global_http_overrides.dart';
import 'theme/theme.dart';

void main() {
  HttpOverrides.global = GlobalHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'OpenViduClient Flutter Example',
      theme: OpenViduTheme().buildThemeData(context),
      home: TestVideo() // ConnectPage(),
      );
}
