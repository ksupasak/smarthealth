import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/views/pages/numpad.dart';
import 'package:smart_health/views/ui/bottomnavigationbar/bottomnavigationbar.dart';
import 'package:smart_health/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});
  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  bool status = false;

  void check() async {
    setState(() {
      status = true;
    });
    context.read<Datafunction>().playsound();
    if (context.read<DataProvider>().id.length == 13) {
      double p = context
          .read<Datafunction>()
          .checkDigit('${context.read<DataProvider>().id}');

      if (p.toString() == '${context.read<DataProvider>().id[12]}.0') {
        var url = Uri.parse(
            '${context.read<DataProvider>().platfromURL}get_patient?public_id=${context.read<DataProvider>().id}'); //${context.read<stringitem>().uri}
        var res = await http.get(url);
        if (res.statusCode == 200) {
          var resTojson = json.decode(res.body);
          if (resTojson['message'] == 'success') {
            setState(() {
              status = false;
              context.read<DataProvider>().dataidcard = resTojson;
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Popup(
                      texthead: 'สำเร็จ', pathicon: 'assets/correct.png');
                });

            Timer(Duration(seconds: 2), () {
              Get.offNamed('user_information');
            });
          } else if (resTojson['message'] == 'not found') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Popup(
                    texthead: 'ไม่พบข้อมูลในระบบ',
                    pathicon: 'assets/warning.png',
                    buttonbar: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
            setState(() {
              status = false;
            });
          } else {
            print('ระบบขัดข้อง');
            setState(() {
              status = false;
            });
          }
        } else {
          print('error400');
          setState(() {
            status = false;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                texthead: 'เลขบัตรประชาชนไม่ถูกต้อง',
                textbody: 'กรุณากรอกใหม่',
                pathicon: 'assets/warning (1).png',
                buttonbar: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
        setState(() {
          status = false;
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'เลขบัตรประชาชนไม่ครบ',
              textbody: 'กรุณากรองเลขบัตรประชาชนไห้ครบ',
              pathicon: 'assets/warning (1).png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
      setState(() {
        status = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: BackGroundSmart_Health(
            BackGroundColor: [
              StyleColor.backgroundbegin,
              StyleColor.backgroundend
            ],
          )),
          Positioned(
              child: SafeArea(
            child: ListView(children: [
              Container(
                width: _width,
                height: _height,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetNameHospital(),
                    SizedBox(height: _height * 0.01),
                    BoxRunQueue(),
                    SizedBox(height: _height * 0.01),
                    Container(
                      width: _width * 0.8,
                      height: _height * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(blurRadius: 10, color: Colors.white),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            numpad(),
                            SizedBox(height: _height * 0.01),
                            status == false
                                ? GestureDetector(
                                    onTap: () {
                                      check();
                                    },
                                    child: BoxWidetdew(
                                        color:
                                            Color.fromARGB(255, 12, 231, 205),
                                        height: 0.05,
                                        width: 0.3,
                                        text: 'ตกลง',
                                        textcolor: Colors.white,
                                        fontSize: 0.05))
                                : Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.07,
                                    height: MediaQuery.of(context).size.width *
                                        0.07,
                                    child: CircularProgressIndicator(),
                                  ),
                            SizedBox(height: _height * 0.01),
                            GestureDetector(
                                onTap: () {
                                  setState(() async {
                                    context.read<DataProvider>().id =
                                        '1710501456572';
                                    var url = Uri.parse(
                                        '${context.read<DataProvider>().platfromURL}get_patient?public_id=${context.read<DataProvider>().id}'); //${context.read<stringitem>().uri}
                                    var res = await http.get(url);
                                    if (res.statusCode == 200) {
                                      var resTojson = json.decode(res.body);
                                      if (resTojson['message'] == 'success') {
                                        setState(() {
                                          status = false;
                                          context
                                              .read<DataProvider>()
                                              .dataidcard = resTojson;
                                        });
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Popup(
                                                  texthead: 'สำเร็จ',
                                                  fontSize: 0.05,
                                                  pathicon:
                                                      'assets/correct.png');
                                            });
                                        Timer(Duration(seconds: 2), () {
                                          Get.offNamed('menu');
                                        });
                                      }
                                    }
                                  });
                                },
                                child: BoxWidetdew(
                                    color: Colors.red,
                                    height: 0.05,
                                    width: 0.3,
                                    text: 'Test',
                                    textcolor: Colors.white,
                                    fontSize: 0.05))
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ]),
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBarApp(),
    );
  }
}
