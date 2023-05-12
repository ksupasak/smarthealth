import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart';
import 'package:just_audio/just_audio.dart';

class DataProvider with ChangeNotifier {
  String name_hospital = 'NAME OF HOSPITAL';
  String platfromURL = 'https://emr-life.com/clinic_master/clinic/Api/';
  String checkqueueURL =
      'https://emr-life.com/clinic_master/clinic/Api/check_q';
  String care_unit_id = '63d79d61790f9bc857000006';
  String passwordsetting = '';
  String fontFamily = 'Prompt';
  var dataidcard;
  var checkqueue = '';
  Color color_name_hospital = Color.fromARGB(255, 255, 255, 255);
  double sized_name_hospital = 0.08;
  FontWeight fontWeight_name_hospital = FontWeight.w600;
  Color shadow_name_hospital = Color.fromARGB(199, 255, 0, 0);

  //List<String> knownDevice = [];
  var resTojson;
  List<String> devicename = [];
  List<String> namescan = [
    'HC-08',
    'MIBFS',
    'HJ-Narigmed',
    'A&D_UA-651BLE_D57B3F'
  ];

  // Map<String, BluetoothDevice> j = {}; //context.read<DataProvider>().
  // 'HC-08',
  // 'MIBFS',
  // 'HJ-Narigmed',
  // 'A&D_UA-651BLE_D57B3F'

  String id = '';
  String temp = '';
  String weight = '';
  String sys = '';
  String dia = '';
  String spo2 = '';
  String pr = '';
  String pul = '';
  String fbs = '';
  String si = '';
  String uric = '';
  List<String> deviceId = [];
  StreamController<List<String>> _deviceIdStreamController =
      StreamController<List<String>>();
  Stream<List<String>> get deviceIdStream => _deviceIdStreamController.stream;

  void addDeviceId(String deviceId) {
    this.deviceId.add(deviceId);
    _deviceIdStreamController.add(this.deviceId);
    notifyListeners();
  }

  void dispose() {
    _deviceIdStreamController.close();
    super.dispose();
  }

//  var idtest = '1710501456572';

  var status_getqueue; //false
}
