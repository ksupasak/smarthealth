import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart';

class DataProvider with ChangeNotifier {
  String app = '';
  String platfromURL = 'https://emr-life.com/clinic_master/clinic/Api/';
  String name_hospital = '';
  String care_unit = '';
  String care_unit_id = '';
  String password = '';
  bool permission_id = false;
  bool permission_ble = false;
  bool permission_printter = false;
  String? family = 'prompt';
  var resTojson;
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
  List<String> namescan = [
    'Yuwell HT-YHW', //เครื่องวัดอุณหภูมิ D0:05:10:00:02:74
    'Yuwell BO-YX110-FDC7', //เครื่องspo
    'Yuwell BP-YE680A', //เครื่องวัดความดัน
    //
    // 'HC-08',
    'MIBFS',
    'FT_F5F30C4C52DE', //เครื่องอ่านบัตร
    // 'HJ-Narigmed',
    // 'A&D_UA-651BLE_D57B3F'
  ];

  List<String> iddevice = [];
  var mapdevices;
}
