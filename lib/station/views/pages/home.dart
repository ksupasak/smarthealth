// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/provider/provider_function.dart';

import 'package:smart_health/station/views/pages/numpad.dart';
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
  Timer? timerreadIDCard;
  void check2() async {
    setState(() {
      status = true;
    });
    context.read<Datafunction>().playsound();
    if (context.read<DataProvider>().id.length == 13) {
      var url = Uri.parse(
          'https://emr-life.com/clinic_master/clinic/Api/check_quick');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      var resTojson = json.decode(res.body);
      debugPrint("resTojson check_quick ${resTojson.toString()}");
      debugPrint(context.read<DataProvider>().dataUserCheckQuick.toString());
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
                        Timer(const Duration(seconds: 2), () {
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
          context.read<DataProvider>().updatedatausercheckquick(resTojson);
          context.read<DataProvider>().dataidcard = resTojson;
        });
        Timer(const Duration(seconds: 1), () {
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
                        color: const Color.fromARGB(255, 106, 143, 173),
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
      Future.delayed(const Duration(seconds: 1), () {
        reader = ESMIDCard.instance;
        entry = reader?.getEntry();

        debugPrint('->initstate');
        if (entry != null) {
          entry?.listen((String data) async {
            List<String> splitted = data.split('#');
            debugPrint("IDCard $data");
            context.read<DataProvider>().id = splitted[0].toString();
            context.read<DataProvider>().regter_data = splitted;
            setState(() {
              context.read<DataProvider>().regter_data = splitted;
              context.read<DataProvider>().id = splitted[0].toString();
            });
            debugPrint(
                "${context.read<DataProvider>().id} / ${splitted[0].toString()}");

            idcard.setValue(splitted[0]);
            if (context.read<DataProvider>().id == splitted[0].toString()) {
              check2();
            } else {}
          }, onError: (error) {
            debugPrint(error);
          }, onDone: () {
            debugPrint('Stream closed!');
          });
        } else {}
        const oneSec = Duration(seconds: 1);
        reading = Timer.periodic(oneSec, (Timer t) => checkCard());
      });
    } on Exception catch (e) {
      debugPrint('error');
      debugPrint(e.toString());
    }
  }

  void getIdCard() async {
    timerreadIDCard = Timer.periodic(const Duration(seconds: 4), (timer) async {
      var url = Uri.parse('http://localhost:8189/api/smartcard/read');
      var res = await http.get(url);
      var resTojson = json.decode(res.body);
      debugPrint("Crde Reader--------------------------------=");
      debugPrint(resTojson.toString());
      if (res.statusCode == 200) {
        context.read<DataProvider>().updateuserinformation(resTojson);
        context.read<DataProvider>().upcorrelationId(resTojson);
        debugPrint(resTojson["claimTypes"][0].toString());
        context
            .read<DataProvider>()
            .updateclaimType(resTojson["claimTypes"][0]);
        check2();
        timerreadIDCard?.cancel();
      }
    });
  }

  void checkCard() {
    reader?.readAuto();
  }

  @override
  void dispose() {
    readingtime?.cancel();
    reading?.cancel();
    _timer?.cancel();
    timerreadIDCard?.cancel();
    super.dispose();
  }

  void lop() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL == '') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    "can't connect URL",
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )))));
        } else {}
      });
    });
  }

  @override
  void initState() {
    setState(() {
      context.read<DataProvider>().id = '';
      context
          .read<DataProvider>()
          .updateuserinformation({"pid": "", "claimTypes": "[]"});
      context.read<DataProvider>().claimType = '';
      context.read<DataProvider>().claimTypeName = '';
      context.read<DataProvider>().claimCode = '';
    });
    getIdCard();
    // readerID();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const backgrund(),
          Positioned(
              child: SafeArea(
            child: ListView(children: [
              BoxTime(),
              //    const BoxRunQueue2(),
              SizedBox(height: height * 0.1),
              SizedBox(
                width: width,
                height: height * 0.7,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    SizedBox(
                        width: width * 0.6,
                        child:
                            BoxText(text: 'กรุณาเสียบบัตรประชาชนหรือกรอกรหัส')),
                    SizedBox(
                        width: width * 0.6,
                        child:
                            BoxText(text: 'บัตรประชาชน เพื่อทำการเข้าสู่ระบบ')),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.7,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 235, 235, 235),
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
                              child: const BoxID()),
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
                            child: SizedBox(
                              height: width * 0.08,
                              width: width * 0.08,
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
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          shownumpad == true
                              ? Column(
                                  children: [
                                    idcard,
                                    SizedBox(height: height * 0.01),
                                    status == false
                                        ? GestureDetector(
                                            onTap: () {
                                              check2();
                                            },
                                            child: BoxWidetdew(
                                                color: const Color(0xff00A3FF),
                                                height: 0.05,
                                                width: 0.3,
                                                text: 'ตกลง',
                                                radius: 10.0,
                                                textcolor: Colors.white,
                                                fontSize: 0.05))
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                  ],
                                )
                              : SizedBox(
                                  height: height * 0.3,
                                  width: width * 0.5,
                                  child: Image.asset('assets/ppasc.png'),
                                )
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.toNamed('regter');
                        },
                        child: const Text("regter"))
                  ],
                )),
              ),
            ]),
          ))
        ],
      ),
    );
  }
}
