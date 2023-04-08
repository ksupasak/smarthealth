import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StringItem with ChangeNotifier {
  String NAMEOFHOSPITAL = 'NAME OF HOSPITAL';
  String first_name = 'null'; //
  String last_name = 'null'; //
  String image = '';
  String tel = '';
  String id = ''; //
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
  int appID = 733551517; //
  String appSign =
      '98418d25e39d83614bd7d3919fca8948d817cf7a2979c3c38a4fe47edebef86a'; //
  String callID = '1234'; //
  List<String> listDeviceName = [];
  List<String> knownDevice = [
    'HC-08',
    'MIBFS',
    'HJ-Narigmed',
    'A&D_UA-651BLE_D57B3F'
  ];
  String status = 'Ready';
  String temp = ''; //1
  String weight = '';
  String sys = '';
  String dia = '';
  String spo2 = ''; //2
  String pr = ''; //3

  void clear() {
    temp = '';
    weight = '';
    sys = '';
    dia = '';
    spo2 = '';
    pr = '';
  }
}
