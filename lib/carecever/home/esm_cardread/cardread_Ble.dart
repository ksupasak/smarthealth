import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CardRead {
  final BluetoothDevice device;
  StreamController<String> controller = StreamController<String>();
  CardRead({required this.device});

  Stream parse() {
    device.discoverServices();

    device.services.listen((services) {
      for (BluetoothService s in services) {
        print('Service =${s.uuid.toString()}');
      }
    });

    return controller.stream;
  }
}
