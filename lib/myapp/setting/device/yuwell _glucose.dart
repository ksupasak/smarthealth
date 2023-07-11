import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Yuwell_Glucose {
  final BluetoothDevice device;

  Yuwell_Glucose({required this.device});
  StreamController<String> controller = StreamController<String>();

  Stream parse() {
    device.discoverServices();
    device.services.listen((services) {
      services.forEach((scrvice) {
        //  print(scrvice.uuid);
        if (scrvice.uuid.toString() == '00001808-0000-1000-8000-00805f9b34fb') {
          scrvice.characteristics.forEach((c) {
            // print(c.uuid);
            if (c.uuid.toString() == '00002a18-0000-1000-8000-00805f9b34fb') {
              c.setNotifyValue(true);
              c.value.listen((values) {
                // var values = '0x060700E60701010C0D0233C011';
                String x;
                print("values= ${values}");
                String partToConvert = values.toString().substring(22, 24);
                print("partToConvert= ${partToConvert}");
                int intValue = int.parse(partToConvert, radix: 16);
                print("intValue= ${intValue}");
                double decimalValue = intValue.toDouble();
                print("decimalValue= ${decimalValue}");
                x = (decimalValue / 0.0555 / 10).round().toString();
                print("x= ${x}");
                controller.add(x);
              });
            }
          });
        }
      });
    });
    return controller.stream;
  }
}
