import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/device/ad_ua651ble.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/device/hj_narigmed.dart';
import 'package:smart_health/device/mibfs.dart';
import 'package:smart_health/local/local.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/pages/home.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  TextEditingController name_hospital = TextEditingController();
  TextEditingController platfromURL = TextEditingController();
  TextEditingController checkqueueURL = TextEditingController();
  TextEditingController care_unit_id = TextEditingController();
  TextEditingController passwordsetting = TextEditingController();
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  Timer scanTimer([int milliseconds = 6]) =>
      Timer.periodic(Duration(seconds: milliseconds), (Timer timer) {
        FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 5));
      });

  void bleScan() {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    var deviceId = DataProvider().deviceId;
    final Map<String, String> online_devices = HashMap();
    StreamController<Map<String, String>> datas =
        StreamController<Map<String, String>>();
    FlutterBluePlus.instance.scanResults.listen((results) {
      //2
      print(results);
      if (results.length > 0) {
        //3
        print(results.length);
        ScanResult r = results.last;
        if (deviceId.contains(r.device.id.toString())) {
          print('กำลังconnect');
          r.device.connect();
        }
      } else {
        print('object1212121');
      }
    });

    Stream.periodic(Duration(seconds: 5)).listen((_) {
      FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
      FlutterBluePlus.instance.scanResults.listen((results) {
        print(results);
        if (results.length > 0) {
          print(results.length);
          ScanResult r = results.last;
          if (deviceId.contains(r.device.id.toString())) {
            print('กำลังconnect');
            r.device.connect();
          }
        }
      });
    });
    Stream.periodic(Duration(seconds: 4))
        .asyncMap((_) => flutterBlue.connectedDevices)
        .listen((connectedDevices) {
      connectedDevices.forEach((device) {
        if (online_devices.containsKey(device.id.toString()) == false) {
          online_devices[device.id.toString()] = device.name;
          if (device.name == 'HC-08' &&
              context
                  .read<DataProvider>()
                  .deviceId
                  .contains(device.id.toString())) {
            Hc08 hc08 = Hc08(device: device);
            hc08.parse().listen((temp) {
              if (temp != null && temp != '') {
                Map<String, String> val = HashMap();
                val['temp'] = temp;
                datas.add(val);
                setState(() {
                  context.read<DataProvider>().temp = temp;
                });
              }
            });
          } else if (device.name == 'HJ-Narigmed' &&
              context
                  .read<DataProvider>()
                  .deviceId
                  .contains(device.id.toString())) {
            HjNarigmed hjNarigmed = HjNarigmed(device: device);
            hjNarigmed.parse().listen((mVal) {
              Map<String, String> val = HashMap();
              val['spo2'] = mVal['spo2'];
              val['pr'] = mVal['pr'];
              datas.add(val);
              setState(() {
                context.read<DataProvider>().spo2 = mVal['spo2'];
                context.read<DataProvider>().pr = mVal['pr'];
              });
            });
          } else if (device.name == 'A&D_UA-651BLE_D57B3F' &&
              context
                  .read<DataProvider>()
                  .deviceId
                  .contains(device.id.toString())) {
            AdUa651ble adUa651ble = AdUa651ble(device: device);
            adUa651ble.parse().listen((nVal) {
              Map<String, String> val = HashMap();
              val['sys'] = nVal['sys'];
              val['dia'] = nVal['dia'];
              val['pul'] = nVal['pul'];
              datas.add(val);
              setState(() {
                context.read<DataProvider>().sys = nVal['sys'];
                context.read<DataProvider>().dia = nVal['dia'];
                context.read<DataProvider>().pul = nVal['pul'];
              });
            });
          } else if (device.name == 'MIBFS' &&
              context
                  .read<DataProvider>()
                  .deviceId
                  .contains('0C:95:41:17:9C:ED')) {
            Mibfs mibfs = Mibfs(device: device);
            mibfs.parse().listen((weight) {
              Map<String, String> val = HashMap();
              val['weight'] = weight;
              setState(() {
                context.read<DataProvider>().weight = weight;
              });
            });
          }
        }
      });
    });
  }

  Future<void> printDatabase() async {
    var device;

    init = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      name_hospital.text = record['name_hospital'].toString();
      platfromURL.text = record['platfromURL'].toString();
      checkqueueURL.text = record['checkqueueURL'].toString();
      care_unit_id.text = record['care_unit_id'].toString();
      passwordsetting.text = record['passwordsetting'].toString();
      device = record['device'];
      print(name_hospital.text);
      print(platfromURL.text);
      print(checkqueueURL.text);
      print(care_unit_id.text);
      print(passwordsetting.text);
      for (var devices in device) {
        print(devices);
      }
    }
  }

  @override
  void initState() {
    // printDatabase();
   // scanTimer(4500);
   // bleScan();
    //  TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: ((context, snapshot) {
          if (snapshot.data == BluetoothState.on) {
            return Homeapp();
          } else if (snapshot.data == BluetoothState.off) {
            FlutterBluePlus.instance.turnOn();
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
