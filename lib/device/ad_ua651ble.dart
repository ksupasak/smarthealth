import 'dart:developer';
import 'dart:async';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AdUa651ble {
  final BluetoothDevice device;
  StreamController<Map<String, String>> controller =
      StreamController<Map<String, String>>();
  AdUa651ble({required this.device});

  Stream parse() {
    device.discoverServices();
    device.services.listen((services) {
      services.forEach((service) {
        //   print('Service = ${service.uuid.toString()}');
        if (service.uuid.toString() ==
            '0000fe86-0000-1000-8000-00805f9b34fb') {}
        service.characteristics.forEach((c) {
          //  print('characteristics --->${c.uuid.toString()}');
          if (c.uuid.toString() == '0000fe02-0000-1000-8000-00805f9b34fb') {
            c.setNotifyValue(true);
            c.value.listen((values) {
              //  print("varlues-->${values.toString()}");
            });
          }
        });
      });
    });

    return controller.stream;
  }
}
