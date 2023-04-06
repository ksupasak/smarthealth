import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StringItem with ChangeNotifier {
  String NAMEOFHOSPITAL = 'NAME OF HOSPITAL';
  String first_name = '';
  String last_name = '';
  String image = '';
  String tel = '';
  String id = '';
  String TextNumpad = '';
  String height = '';
  String pul = '';
  String pressure = '';
  String Setting1 = '';
  String Setting2 = '';
  String Setting3 = '';
  String Hospitalname = 'test/Hospitalname';
  String LicenseKey = 'test/LicenseKey';
  String PlatfromURL = 'https://emr-life.com/clinic_master/clinic/Api/';
  String care_unit_id = '63d79d61790f9bc857000006';
  BluetoothDevice? deviceidprovider;

  List<String> listDeviceName = [];
  List<String> knownDevice = ['HC-08', 'MIBFS', 'HJ-Narigmed'];
  String status = 'Ready';
  String temp = 'ค่าที่1'; //1
  String weight = '';
  String sys = '';
  String dia = '';
  String spo2 = 'ค่าที่3'; //2
  String pr = 'ค่าที่2'; //3

  void clear() {
    temp = '';
    weight = '';
    sys = '';
    dia = '';
    spo2 = '';
    pr = '';
  }
}
