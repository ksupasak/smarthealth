import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_health/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  var resTojson;

  void Information() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
    var res = await http.post(url, body: {
      // 'care_unit_id': '63d7a282790f9bc85700000e',
      'public_id': context.read<DataProvider>().idtest,
    });

    setState(() {
      resTojson = json.decode(res.body);
      print(resTojson['todays'].length.toString());
    });
  }

  Future<void> getqueue() async {
    var url = Uri.parse('https://emr-life.com/clinic_master/clinic/Api/get_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().idtest,
    });
    if (res.statusCode == 200) {
      setState(() {
        resTojson = json.decode(res.body);
      });
    }
    print(resTojson['queue_number']);
  }

  void checkhealth_records() async {
    if (resTojson['health_records'].length == 0) {
      print('ไปหน้าวัดค่า');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'คุณยังไม่ได้ตรวจวัดค่า',
              textbody: 'กรุณาวัดค่าก่อน',
              pathicon: 'assets/warning.png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      Get.toNamed('healthrecord');
                    },
                    child: BoxWidetdew(
                        color: Color.fromARGB(255, 106, 143, 173),
                        height: 0.05,
                        width: 0.2,
                        text: 'ตกลง',
                        textcolor: Colors.white))
              ],
            );
          });
    } else {
      print('ไม่ไปหน้าวัดค่า');
      print(resTojson['health_records'].length.toString());
      print(resTojson['health_records']);
    }
  }

  void restart() async {
    while (resTojson == null) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        // print(resTojson);
        // print(resTojson['health_records'].length.toString());
      });
    }
  }

  @override
  void initState() {
    Information();
    restart();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                child: BackGroundSmart_Health(
              BackGroundColor: [
                StyleColor.backgroundbegin,
                StyleColor.backgroundend
              ],
            )),
            resTojson != null
                ? Positioned(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: _height * 0.02),
                      BoxDecorate(
                          color: Color.fromARGB(255, 43, 179, 161),
                          child: InformationCard(
                              dataidcard:
                                  context.read<DataProvider>().dataidcard)),
                      SizedBox(height: _height * 0.02),
                      Column(
                        children: resTojson['todays'].length != 0
                            ? [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: _width * 0.6,
                                            height: _height * 0.25,
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                    'assets/cloud-computing.png',
                                                    fit: BoxFit.fill,
                                                    width: _width * 0.6,
                                                    height: _height * 0.25,
                                                  ),
                                                  Positioned(
                                                      top: 70,
                                                      left: 70,
                                                      child: resTojson[
                                                                  'queue_number'] !=
                                                              ''
                                                          ? Text(
                                                              "หมายเลขคิวของท่านคือ ${resTojson['queue_number']} ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      _width *
                                                                          0.04),
                                                            )
                                                          : Text(
                                                              'ยังไม่มีคิว',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      _width *
                                                                          0.05,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          16,
                                                                          138,
                                                                          128)),
                                                            )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          resTojson['queue_number'] != ''
                                              ? Container()
                                              : Container(
                                                  width: _width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SizedBox(
                                                        width: _width * 0.15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          getqueue();
                                                        },
                                                        child: Container(
                                                          width: _width * 0.2,
                                                          height: _height * 0.1,
                                                          child: BoxWidetdew(
                                                            text: 'รับคิว',
                                                            textcolor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    16,
                                                                    138,
                                                                    128),
                                                            color:
                                                                Color.fromARGB(
                                                                    100,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            radius: 500.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      )
                                    ]),
                                SizedBox(height: _height * 0.02),
                                Container(
                                    child:
                                        resTojson['health_records'].length != 0
                                            ? Container(
                                                child: Column(children: [
                                                  Text(
                                                      'bp ${resTojson['health_records'][0]['bp']}    bp_dia  ${resTojson['health_records'][0]['bp_dia']} '),
                                                  Text(
                                                      'bp_sys ${resTojson['health_records'][0]['bp_sys']}    height  ${resTojson['health_records'][0]['height']} weight ${resTojson['health_records'][0]['weight']}'),
                                                  Text(
                                                      'pulse_rate ${resTojson['health_records'][0]['pulse_rate']}    rr  ${resTojson['health_records'][0]['rr']} '),
                                                  Text(
                                                      'spo2 ${resTojson['health_records'][0]['spo2']}    temp  ${resTojson['health_records'][0]['temp']} '),
                                                ]),
                                              )
                                            : Container()),
                                SizedBox(height: _height * 0.02),
                                Container(
                                  child: resTojson['appointments'].length != 0
                                      ? BoxWidetdew(
                                          color:
                                              Color.fromARGB(36, 255, 255, 255),
                                          textcolor: Colors.black,
                                          height: 0.1,
                                          width: 0.8,
                                          radius: 0.0,
                                          text:
                                              'มีนัดล่วงหน้า-${resTojson['appointments'][0]['date']}    เวลา-${resTojson['appointments'][0]['slot']}',
                                        )
                                      : null,
                                ),
                                SizedBox(height: _height * 0.1),
                                Container(
                                  child: resTojson['queue_number'] != ''
                                      ? GestureDetector(
                                          onTap: () {
                                            checkhealth_records();
                                          },
                                          child: BoxWidetdew(
                                            height: 0.07,
                                            width: 0.4,
                                            radius: 0.0,
                                            color: Colors.green,
                                            textcolor: Colors.white,
                                            text: 'ปริ้นคิว',
                                          ),
                                        )
                                      : null,
                                ),
                              ]
                            : [
                                Text(
                                  'คุณไม่มีนัดหมาย ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: _width * 0.05),
                                ),
                                Container(
                                    child: resTojson['appointments'].length != 0
                                        ? Column(
                                            children: [
                                              Text('นัดหมายครั้งต่อไปวันที่',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: _width * 0.05)),
                                              Text(
                                                  " ${resTojson['appointments'][0]['date']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: _width * 0.05)),
                                              Text(
                                                  "เวลา${resTojson['appointments'][0]['slot']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: _width * 0.05)),
                                            ],
                                          )
                                        : Text(""))
                              ],
                      ),
                    ],
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
