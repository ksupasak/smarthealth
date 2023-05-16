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
import 'package:smart_health/views/pages/user_information2.dart';
import 'package:smart_health/views/pages/videocall.dart';
import 'package:smart_health/views/ui/bottomnavigationbar/bottomnavigationbar.dart';
import 'package:smart_health/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

import 'package:smart_health/test/esm_idcard.dart';

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});
  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  bool status = false;
  final idcard = Numpad();
  ESMIDCard? reader;
  Stream<String>? entry;
  Timer? readingtime;
  Timer? reading;
  @override
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

            Timer(Duration(milliseconds: 200), () {
              // readingtime?.cancel();
              // reading?.cancel();
              Get.toNamed('user_information');
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => UserInformation2(),
              //     ));
            });
          } else if (resTojson['message'] == 'not found') {
            print("${context.read<DataProvider>().regter_id}");
            print("${context.read<DataProvider>().regter_prefix_name}");
            print("${context.read<DataProvider>().regter_first_name}");
            print("${context.read<DataProvider>().regter_last_name}");
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
                            Timer(Duration(seconds: 1), () {
                              setState(() {
                                Get.toNamed('regter');
                              });
                            });
                          },
                          child: BoxWidetdew(
                              color: Colors.green,
                              height: 0.05,
                              width: 0.2,
                              text: 'สมัค',
                              radius: 0.0,
                              textcolor: Colors.white)),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: BoxWidetdew(
                              color: Colors.red,
                              height: 0.05,
                              width: 0.2,
                              radius: 0.0,
                              text: 'ออก',
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
                          text: 'ออก',
                          radius: 0.0,
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

  void readerID() {
    try {
      //   // Future.delayed(const Duration(seconds: 1), ()
      readingtime = Timer.periodic(const Duration(seconds: 1), (_) {
        reader = ESMIDCard.instance;
        entry = reader?.getEntry();

        // idcard = Numpad();
        print('->initstate');
        if (entry != null) {
          entry?.listen((String data) async {
            List<String> splitted = data.split('#');
            print("IDCard " + data);
            setState(() {
              context.read<DataProvider>().id = splitted[0].toString();
              context.read<DataProvider>().regter_id = splitted[0].toString();
              context.read<DataProvider>().regter_prefix_name =
                  splitted[1].toString();
              context.read<DataProvider>().regter_first_name =
                  splitted[2].toString();
              context.read<DataProvider>().regter_last_name =
                  splitted[4].toString();
            });
            print(
                "${context.read<DataProvider>().id} / ${splitted[0].toString()}");
            // idcard?.setValue(splitted[0]);
            idcard.setValue(splitted[0]);
            if (context.read<DataProvider>().id == splitted[0].toString()) {
              check();
            }
          }, onError: (error) {
            print(error);
          }, onDone: () {
            print('Stream closed!');
          });
        } else {}
        const oneSec = Duration(seconds: 1);
        reading = Timer.periodic(oneSec, (Timer t) => checkCard());
      });
    } on Exception catch (e) {
      print('error');
      print(e.toString());
    }
  }

  void checkCard() {
    reader?.readAuto();
  }

  @override
  void dispose() {
    // readingtime?.cancel();
    // reading?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    readerID();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _width > _height
          ? Container()
          : Stack(
              children: [
                backgrund(),
                Positioned(
                    child: SafeArea(
                  child: ListView(children: [
                    BoxTime(),
                    WidgetNameHospital(),
                    Container(
                      width: _width,
                      height: _height * 0.8,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: _height * 0.01),
                          BoxRunQueue(),
                          SizedBox(height: _height * 0.02),
                          BoxText(text: 'กรุณากรอกเลขบัตร XX'),
                          SizedBox(height: _height * 0.02),
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
                                  idcard,
                                  SizedBox(height: _height * 0.01),
                                  status == false
                                      ? GestureDetector(
                                          onTap: () {
                                            check();
                                          },
                                          child: BoxWidetdew(
                                              color: Color.fromARGB(
                                                  255, 12, 231, 205),
                                              height: 0.05,
                                              width: 0.3,
                                              text: 'ตกลง',
                                              textcolor: Colors.white,
                                              fontSize: 0.05))
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          child: CircularProgressIndicator(),
                                        ),
                                  SizedBox(height: _height * 0.01),
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
