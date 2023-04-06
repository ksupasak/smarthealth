import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Homeaapp.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/device/hj_narigmed.dart';
import 'package:smart_health/provider/Provider.dart';

void main() {
  runApp(const smart_health());
}

class smart_health extends StatefulWidget {
  const smart_health({super.key});

  @override
  State<smart_health> createState() => _smart_healthState();
}

class _smart_healthState extends State<smart_health> {
  int _counter = 0;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  @override
  void initState() {
    // TODO: implement initState
    scanTimer(4500);

    bleScan();
    super.initState();
  }

  void bleScan() {
    List<String> knownDevice = context.read<StringItem>().knownDevice;
    flutterBlue.scanResults.listen((results) {
      // results.forEach((r) {
      if (results.length > 0) {
        ScanResult r = results.last;
        if (knownDevice.contains(r.device.name)) {
          r.device.connect();
          print('Connect = ${r.device.name} ');
        }
      }
      // });
    });

    Stream.periodic(Duration(seconds: 1))
        .asyncMap((_) => flutterBlue.connectedDevices)
        .listen((connectedDevices) {
      connectedDevices.forEach((device) {
        print("Found " + device.name);
        context.read<StringItem>().status = 'Measuring';
        if (device.name == 'HC-08') {
          Hc08 hc08 = Hc08(device: device);
          hc08.parse().listen((temp) {
            if (temp != null && temp != '') {
              setState(() {
                context.read<StringItem>().temp = temp;
              });
            }
          });
        } else if (device.name == 'HJ-Narigmed') {
          HjNarigmed hjNarigmed = HjNarigmed(device: device);
          hjNarigmed.parse().listen((mVal) {
            if (!mVal.isEmpty()) {
              setState(() {
                context.read<StringItem>().spo2 = mVal['spo2'];
                context.read<StringItem>().pr = mVal['pr'];
              });
            }
          });
        } else {
          // Other devices
        }
      });
    });
  }

  Timer scanTimer([int milliseconds = 4000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), (Timer timer) {
        print("start scan");
        FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
        // flutterBlue.startScan(timeout: Duration(seconds: 4));
        print("stop scan");
      });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return StringItem();
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
