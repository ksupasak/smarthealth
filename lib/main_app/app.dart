import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Model/routes/routes_page.dart';
import 'package:smart_health/povider/provider.dart';
import 'package:smart_health/povider/providerfunction.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => DataProvider())),
        ChangeNotifierProvider(create: ((context) => Datafunction()))
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash',
        getPages: Routes.routes,
      ),
    );
  }
}
