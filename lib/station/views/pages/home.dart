import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/station/background/background.dart';
import 'package:smart_health/station/background/color/style_color.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/provider/provider_function.dart';
import 'package:smart_health/station/views/pages/numpad.dart';
import 'package:smart_health/station/views/pages/user_information2.dart';
import 'package:smart_health/station/views/pages/videocall.dart';
import 'package:smart_health/station/views/ui/bottomnavigationbar/bottomnavigationbar.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

import 'package:smart_health/station/test/esm_idcard.dart';

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
  bool shownumpad = false;
  Timer? _timer;
  @override
  void _check() async {
    setState(() {
      status = true;
    });
    context.read<Datafunction>().playsound();
    if (context.read<DataProvider>().id.length == 13) {
      double p = context
          .read<Datafunction>()
          .checkDigit('${context.read<DataProvider>().id}');

      // if (p.toString() == '${context.read<DataProvider>().id[12]}.0') {
      //   var url = Uri.parse(
      //       '${context.read<DataProvider>().platfromURL}/get_patient?public_id=${context.read<DataProvider>().id}'); //${context.read<stringitem>().uri}
      //   var res = await http.get(url);
      if (p.toString() == '${context.read<DataProvider>().id[12]}.0') {
        var url = Uri.parse(
            '${context.read<DataProvider>().platfromURL}/check_q}'); //${context.read<stringitem>().uri}
        var res = await http.post(url, body: {
          'care_unit_id': context.read<DataProvider>().care_unit_id,
          'public_id': context.read<DataProvider>().id,
        });

        if (res.statusCode == 200) {
          var resTojson = json.decode(res.body);
          if (resTojson['message'] == 'success') {
            setState(() {
              status = false;
              context.read<DataProvider>().dataidcard = resTojson;
            });

            Timer(Duration(seconds: 1), () {
              // readingtime?.cancel();
              // reading?.cancel();
              Get.toNamed('user_information');
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
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                Get.toNamed('regter');
                              });
                            });
                          },
                          child: BoxWidetdew(
                              color: Colors.green,
                              height: 0.05,
                              width: 0.2,
                              text: 'สมัคร',
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

  void check2() async {
    setState(() {
      status = true;
    });
    context.read<Datafunction>().playsound();
    if (context.read<DataProvider>().id.length == 13) {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      var resTojson = json.decode(res.body);
      print(resTojson);
      setState(() {
        status = false;
      });
      if (resTojson['message'] == 'not found patient') {
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
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            Get.toNamed('regter');
                          });
                        });
                      },
                      child: BoxWidetdew(
                          color: Colors.green,
                          height: 0.05,
                          width: 0.2,
                          text: 'สมัคร',
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
      } else {
        setState(() {
          status = false;
          context.read<DataProvider>().dataidcard = resTojson;
        });
        Timer(Duration(seconds: 1), () {
          Get.toNamed('user_information');
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
      // Future.delayed(const Duration(seconds: 1), ()
      // readingtime = Timer.periodic(const Duration(seconds: 1), (_)
      Future.delayed(const Duration(seconds: 1), () {
        reader = ESMIDCard.instance;
        entry = reader?.getEntry();

        // idcard = Numpad();
        print('->initstate');
        if (entry != null) {
          entry?.listen((String data) async {
            List<String> splitted = data.split('#');
            print("IDCard " + data);
            setState(() {
              context.read<DataProvider>().regter_data = splitted;
              context.read<DataProvider>().id = splitted[0].toString();
            });
            print(
                "${context.read<DataProvider>().id} / ${splitted[0].toString()}");
            // idcard?.setValue(splitted[0]);
            idcard.setValue(splitted[0]);
            if (context.read<DataProvider>().id == splitted[0].toString()) {
              check2();
            } else {}
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
    readingtime?.cancel();
    reading?.cancel();
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void lop() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL == '') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'ยังไม่ได้ตั่งค่าplatfromURL',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )))));
        } else {
          readerID();
        }
      });
    });
  }

  @override
  void initState() {
    setState(() {
      context.read<DataProvider>().id = '';
    });
    // lop();
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
                    BoxTime(), //จุดtest1
                    BoxRunQueue2(), //จุดtest2
                    Container(
                      width: _width,
                      height: _height * 0.7,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: _height * 0.02),
                          Container(
                              width: _width * 0.6,
                              child: BoxText(
                                  text: 'กรุณาเสียบบัตรประชาชนหรือกรอกรหัส')),
                          Container(
                              width: _width * 0.6,
                              child: BoxText(
                                  text: 'บัตรประชาชน เพื่อทำการเข้าสู่ระบบ')),
                          SizedBox(height: _height * 0.02),
                          Container(
                            width: _width * 0.7,
                            height: _height * 0.07,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 235, 235),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        shownumpad = true;
                                      });
                                    },
                                    child: BoxID()), //จุดtest3
                                GestureDetector(
                                  onTap: () {
                                    if (shownumpad == false) {
                                      setState(() {
                                        shownumpad = true;
                                      });
                                    } else {
                                      setState(() {
                                        shownumpad = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: _width * 0.08,
                                    width: _width * 0.08,
                                    child: SvgPicture.asset(
                                      'assets/Frame 9128.svg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                shownumpad == true
                                    ? Column(
                                        children: [
                                          idcard,
                                          SizedBox(height: _height * 0.01),
                                          status == false
                                              ? GestureDetector(
                                                  onTap: () {
                                                    check2();
                                                  },
                                                  child: BoxWidetdew(
                                                      color: Color(0xff00A3FF),
                                                      height: 0.05,
                                                      width: 0.3,
                                                      text: 'ตกลง',
                                                      radius: 10.0,
                                                      textcolor: Colors.white,
                                                      fontSize: 0.05))
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                        ],
                                      )
                                    : Container(
                                        height: _height * 0.3,
                                        width: _width * 0.5,
                                        child: Image.asset('assets/ppasc.png'),
                                      )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ]),
                ))
              ],
            ),
      //  bottomNavigationBar: BottomNavigationBarApp(),
    );
  }
}
