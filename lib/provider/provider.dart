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
  var dataidcard;
  var checkqueue = '';
  Color color_name_hospital = Color.fromARGB(255, 255, 255, 255);
  double sized_name_hospital = 0.08;
  FontWeight fontWeight_name_hospital = FontWeight.w600;
  Color shadow_name_hospital = Color.fromARGB(199, 255, 0, 0);
  // var listdevices = [];
  Map<String, String> knownDevice2 = {};
  List<String> knownDevice = [];
  Map<String, BluetoothDevice> j = {};
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
}
