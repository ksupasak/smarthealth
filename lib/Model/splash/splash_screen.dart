import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Model/view/home.dart';
import 'package:smart_health/device/ad_ua651ble.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/device/hj_narigmed.dart';
import 'package:smart_health/device/mibfs.dart';
import 'package:smart_health/povider/provider.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  Timer scanTimer([int milliseconds = 4000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), (Timer timer) {
        FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
      });

  void bleScan() {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    List<String> knownDevice = DataProvider().knownDevice;
    final Map<String, String> online_devices = HashMap();
    StreamController<Map<String, String>> datas =
        StreamController<Map<String, String>>();

    flutterBlue.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;

        if (knownDevice.contains(r.device.name)) {
          r.device.connect();
        }
      }
    });

    Stream.periodic(Duration(seconds: 1))
        .asyncMap((_) => flutterBlue.connectedDevices)
        .listen((connectedDevices) {
      connectedDevices.forEach((device) {
        if (online_devices.containsKey(device.id.toString()) == false) {
          online_devices[device.id.toString()] = device.name;
          if (device.name == 'HC-08') {
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
          } else if (device.name == 'HJ-Narigmed') {
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
          } else if (device.name == 'A&D_UA-651BLE_D57B3F') {
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
          } else if (device.name == 'MIBFS') {
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

  @override
  void initState() {
    // scanTimer(4500);
    // bleScan();
    // TODO: implement initState
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
