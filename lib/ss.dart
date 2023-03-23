import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice device = BluetoothDevice as BluetoothDevice;
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  Future<void> startScan() async {
    flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
      if (scanResult.device.id.toString() == '00:1C:C2:52:ED:A4') {
        print('Found device');
        device = scanResult.device;
        connectToDevice();
      }
    });
  }

  Future<void> connectToDevice() async {
    await device.connect();
    discoverServices();
  }

  Future<void> discoverServices() async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) {
        if (characteristic.uuid.toString() == 'your_service_uuid') {
          this.characteristic = characteristic;
          print('Found characteristic');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth App'),
      ),
      body: Center(
        child: Text('Bluetooth App'),
      ),
    );
  }
}
