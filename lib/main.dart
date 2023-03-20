import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Homeaapp.dart';
import 'package:smart_health/provider/Provider.dart';
import 'package:smart_health/ss.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const smart_health());
}

class smart_health extends StatefulWidget {
  const smart_health({super.key});

  @override
  State<smart_health> createState() => _smart_healthState();
}

class _smart_healthState extends State<smart_health> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return stringitem();
          })
        ],
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if (orientation == Orientation.landscape) {
              // ล็อกการหมุนหน้าจอแนวนอน
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            } else {
              // ล็อกการหมุนหน้าจอแนวตั้ง
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            }
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SMART_HEALTH',
                theme:
                    ThemeData(primaryColor: Color.fromARGB(255, 70, 180, 170)),
                home: Homeapp());
          },
        )

        //

        //
        );
  }
}
