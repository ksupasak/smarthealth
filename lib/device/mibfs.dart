import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Mibfs {
  final BluetoothDevice device;

  Mibfs({required this.device});
  StreamController<String> controller = StreamController<String>();

  Stream parse() {
    device.discoverServices();
    device.services.listen((services) {
      services.forEach((scrvice) {
        // print("---->${scrvice.uuid.toString()}");
        if (scrvice.uuid.toString() == '0000181b-0000-1000-8000-00805f9b34fb') {
          scrvice.characteristics.forEach((c) {
            //  print(c.uuid.toString());
            if (c.uuid.toString() == '00002a9c-0000-1000-8000-00805f9b34fb') {
              c.setNotifyValue(true);
              c.value.listen((values) {
                //    print(values.toString());

                // if (values[10] == 255) {
                //   print("-------?>${values}");
                //   int sum = 0;
                //   int s;
                //   for (int i = 0; i < 10; i++) {
                //     sum += values[i];
                //   }
                //   s = ((sum - 5) / 10.0) as int;
                //   controller.add(s.toString());
                // }
              });
            }
          });
        }
      });
    });
    return controller.stream;
  }
}
