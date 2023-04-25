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
import 'package:smart_health/provider/provider_function.dart';
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
      'public_id': context.read<DataProvider>().id,
    });

    setState(() {
      resTojson = json.decode(res.body);
      // print(resTojson['todays'].length.toString());
      // print("----------->${resTojson}");
      // print("health_records= ${resTojson['health_records'].length}");
    });
  }

  Future<void> getqueue() async {
    var url = Uri.parse('https://emr-life.com/clinic_master/clinic/Api/get_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    if (res.statusCode == 200) {
      setState(() {
        resTojson = json.decode(res.body);
      });
    }
    //  print(resTojson['queue_number']);
  }

  void checkhealth_records() async {
    if (resTojson['health_records'].length == 0) {
      Get.toNamed('healthrecord');
    } else {
      context.read<DataProvider>().resTojson = resTojson;

      print('ปริ้นคิว');
      Get.toNamed('printqueue');
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
                    child: ListView(
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
                                          Text(
                                            'คุณมีนัดวันนี้',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: _width * 0.04),
                                          ),
                                          Container(
                                            width: _width * 0.6,
                                            height: _height * 0.2,
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                    'assets/cloud-computing.png',
                                                    fit: BoxFit.fill,
                                                    width: _width * 0.6,
                                                    height: _height * 0.2,
                                                  ),
                                                  Positioned(
                                                      top: 70,
                                                      left: resTojson[
                                                                  'queue_number'] !=
                                                              ''
                                                          ? 30
                                                          : 60,
                                                      child: resTojson[
                                                                  'queue_number'] !=
                                                              ''
                                                          ? Column(
                                                              children: [
                                                                Text(
                                                                  "หมายเลขคิวของท่านคือ ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          _width *
                                                                              0.04),
                                                                ),
                                                                Text(
                                                                  "${resTojson['queue_number']} ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          _width *
                                                                              0.08),
                                                                ),
                                                              ],
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
                                              ? Container(
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
                                                          context
                                                              .read<
                                                                  Datafunction>()
                                                              .playsound();
                                                          checkhealth_records();
                                                        },
                                                        child: Container(
                                                          width: _width * 0.18,
                                                          height:
                                                              _height * 0.09,
                                                          child: BoxWidetdew(
                                                            text: 'ปริ้นคิว',
                                                            textcolor:
                                                                Colors.white,
                                                            color:
                                                                Color.fromARGB(
                                                                    100,
                                                                    42,
                                                                    208,
                                                                    20),
                                                            radius: 500.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
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
                                                          context
                                                              .read<
                                                                  Datafunction>()
                                                              .playsound();
                                                          getqueue();
                                                        },
                                                        child: Container(
                                                          width: _width * 0.18,
                                                          height:
                                                              _height * 0.09,
                                                          child: BoxWidetdew(
                                                            text: 'รับคิว',
                                                            textcolor:
                                                                Colors.white,
                                                            color:
                                                                Color.fromARGB(
                                                                    200,
                                                                    240,
                                                                    244,
                                                                    10),
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
                                                  Text('มีค่าวัด'),
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
                                            : Container(
                                                child: Text('ไม่มีค่าวัด'),
                                              )),
                                SizedBox(height: _height * 0.02),
                                Container(
                                    child: Container(
                                        child: resTojson['appointments']
                                                    .length !=
                                                0
                                            ? Stack(
                                                children: [
                                                  Positioned(
                                                    child: Container(
                                                      width: _width * 0.8,
                                                      height: _height * 0.2,
                                                      child: Image.asset(
                                                        'assets/note.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: Container(
                                                      width: _width * 0.8,
                                                      height: _height * 0.18,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'นัดหมายครั้งต่อไปวันที่',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05)),
                                                          Text(
                                                              " ${resTojson['appointments'][0]['date']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05)),
                                                          Text("เวลา",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05)),
                                                          Text(
                                                              '${resTojson['appointments'][0]['slot']}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(""))),
                                SizedBox(height: _height * 0.01),
                              ]
                            : [
                                Text(
                                  'คุณไม่มีนัดหมายในวันนี้',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: _width * 0.05),
                                ),
                                Container(
                                    child: Container(
                                        child: resTojson['appointments']
                                                    .length !=
                                                0
                                            ? Stack(
                                                children: [
                                                  Positioned(
                                                    child: Container(
                                                      width: _width * 0.8,
                                                      height: _height * 0.2,
                                                      child: Image.asset(
                                                        'assets/note.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: Container(
                                                      width: _width * 0.8,
                                                      height: _height * 0.18,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'นัดหมายครั้งต่อไปวันที่',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05)),
                                                          Text(
                                                              " ${resTojson['appointments'][0]['date']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05)),
                                                          Text("เวลา",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05)),
                                                          Text(
                                                              '${resTojson['appointments'][0]['slot']}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      _width *
                                                                          0.05))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(""))),
                              ],
                      ),
                      SizedBox(height: _height * 0.02),
                      GestureDetector(
                        onTap: () {
                          context.read<Datafunction>().playsound();
                          Get.offNamed('home');
                        },
                        child: Container(
                            width: _width,
                            child: Center(
                                child: BoxWidetdew(
                              height: 0.06,
                              width: 0.35,
                              color: Colors.red,
                              radius: 5.0,
                              text: 'ออก',
                              textcolor: Colors.white,
                            ))),
                      )
                    ],
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
