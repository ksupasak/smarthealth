import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart';
import 'package:just_audio/just_audio.dart';

class DataProvider with ChangeNotifier {
  String name_hospital = ''; //NAME OF HOSPITAL
  String care_unit = ''; //Care Unit
  String platfromURL = ''; //https://emr-life.com/clinic_master/clinic/Api/

  String myapp = '';
  String care_unit_id = ''; //63d79d61790f9bc857000006
  String passwordsetting = ''; //
  String fontFamily = 'Prompt'; //

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
    'Yuwell HT-YHW', //เครื่องวัดอุณหภูมิ D0:05:10:00:02:74
    'Yuwell BO-YX110-FDC7', //เครื่องspo
    'Yuwell BP-YE680A', //เครื่องวัดความดัน
    //
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
  Map dataUser = {};

  void updateuserinformation(Map data) {
    dataUser = data;
    id = data["pid"];
    notifyListeners();
  }

  String claimType = '';
  String claimTypeName = '';
  void updateclaimType(Map data) {
    claimType = data["claimType"];
    claimTypeName = data["claimTypeName"];
    notifyListeners();
    debugPrint(data.toString());
  }

  String id = '';
  String colortexts = '';
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

  List<String>? regter_data;
}

class StyleColorsApp with ChangeNotifier {
  Color green_app = Color(0xff31d6aa);
  Color yellow_app = Color(0xffffa800);
  Color blue_app = Color(0xff00a3ff);
}
