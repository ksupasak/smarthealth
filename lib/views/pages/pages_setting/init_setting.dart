import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/local/classlocal.dart';
import 'package:smart_health/local/local.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;

class Initsetting extends StatefulWidget {
  const Initsetting({super.key});

  @override
  State<Initsetting> createState() => _InitsettingState();
}

class _InitsettingState extends State<Initsetting> {
  TextEditingController name_hospital = TextEditingController();
  TextEditingController platfromURL = TextEditingController();

  TextEditingController care_unit_id = TextEditingController();
  TextEditingController care_unit = TextEditingController();
  TextEditingController passwordsetting = TextEditingController();
  late List<RecordSnapshot<int, Map<String, Object?>>> nameHospital;
  var resTojson;
  void test() async {
    name_hospital.text = 'โรงพยาบาลจุฬาลงกรณ์';
    care_unit.text = 'ห้องตรวจ 01';
    platfromURL.text = 'https://emr-life.com/clinic_master/clinic/Api';

    care_unit_id.text = '63d7a282790f9bc85700000e'; //63d79d61790f9bc857000006
    passwordsetting.text = '';
  }

  void safe() async {
    context.read<DataProvider>().name_hospital = name_hospital.text;
    context.read<DataProvider>().platfromURL = platfromURL.text;
    context.read<DataProvider>().care_unit_id = care_unit_id.text;
    context.read<DataProvider>().passwordsetting = passwordsetting.text;
    context.read<DataProvider>().care_unit = care_unit.text;
    setState(() {
      addDataInfoToDatabase(context.read<DataProvider>());
      Navigator.pop(context);
    });
  }

  Future<void> printDatabase() async {
    var knownDevice;

    nameHospital = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in nameHospital) {
      name_hospital.text = record['name_hospital'].toString();
      platfromURL.text = record['platfromURL'].toString();
      care_unit_id.text = record['care_unit_id'].toString();
      care_unit.text = record['care_unit'].toString();
      passwordsetting.text = record['passwordsetting'].toString();
      knownDevice = record['device'];
      print(name_hospital.text);
      print(platfromURL.text);
      print(care_unit_id.text);
      print(passwordsetting.text);
      // for (var knownDevices in knownDevice) {
      //   print(knownDevices);
      // }
    }
    print('เช็คapi');
    check_api();
  }

  void check_api() async {
    var url = Uri.parse('${platfromURL.text}/check_connect');
    var res = await http.post(url, body: {
      'care_unit_id': care_unit_id.text,
    });
    resTojson = json.decode(res.body);
    print(resTojson);
    if (resTojson['message'] == 'success') {
      print('เชื่อมต่อapiได้');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เชื่อมต่อURLสำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    } else {
      print('เชื่อมต่อapiไม่ได้');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เชื่อมต่อURLไม่สำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  @override
  void initState() {
    printDatabase();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(FocusNode());
        }),
        child: Scaffold(
            body: Stack(children: [
          backgrund(),
          Positioned(
              child: ListView(children: [
            Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  BoxTextFieldSetting(
                      keyvavlue: name_hospital, texthead: 'name_hospital'),
                  BoxTextFieldSetting(
                    keyvavlue: care_unit,
                    texthead: 'Care_Unit',
                  ),
                  BoxTextFieldSetting(
                      keyvavlue: platfromURL, texthead: 'platfromURL'),
                  BoxTextFieldSetting(
                      keyvavlue: care_unit_id, texthead: 'care_unit_id'),
                  BoxTextFieldSetting(
                      lengthlimitingtextinputformatter: 4,
                      keyvavlue: passwordsetting,
                      texthead: 'passwordsetting',
                      textinputtype: TextInputType.number),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Container(
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                safe();
                              },
                              child: BoxWidetdew(
                                  text: 'บันทึก',
                                  height: 0.07,
                                  width: 0.6,
                                  radius: 2.0,
                                  textcolor: Colors.white,
                                  fontSize: 0.05,
                                  color: Color.fromARGB(255, 54, 200, 244))))),
                  Container(
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                test();
                              },
                              child: BoxWidetdew(
                                  text: 'Test',
                                  height: 0.07,
                                  width: 0.6,
                                  radius: 2.0,
                                  textcolor: Colors.black,
                                  fontSize: 0.05,
                                  color: Color.fromARGB(255, 255, 255, 255)))))
                ]))
          ]))
        ])));
  }
}
