import 'package:smart_health/device/Defaultblue.dart';

class Hc80 extends Defaultblue {
  String? name;

  static String parse(List<int>? bytes) {
    String temp = '';
    if (bytes != null && bytes.length > 8) {
      for (int i = 5; i <= 8; i++) {
        temp += String.fromCharCode(bytes[i]);
      }
    }

    return temp;
  }
}
