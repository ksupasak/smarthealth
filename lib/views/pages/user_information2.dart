import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:openvidu_client/openvidu_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/views/pages/home.dart';
import 'package:smart_health/views/pages/videocall.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          backgrund(),
          Positioned(
              child: ListView(
            children: [
              BoxDecorate(
                  color: Color.fromARGB(255, 43, 179, 161),
                  child: InformationCard(
                      dataidcard: context.read<DataProvider>().dataidcard)),
            ],
          ))
        ],
      ),
    ));
  }
}

class UserInformation2 extends StatefulWidget {
  const UserInformation2({super.key});

  @override
  State<UserInformation2> createState() => _UserInformation2State();
}

class _UserInformation2State extends State<UserInformation2> {
  Timer? _timer;
  Timer? _timer2;
  var resTojson4;
  var resTojson3;
  var resTojson2;
  var resTojson;
  String status = '';
  bool status2 = false;
  late OpenViduClient _openvidu;

  PrePareVideo? _prePareVideo;

  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      if (resTojson != null) {
        if (resTojson['queue_number'] != '') {
          lop_queue();
        } else {
          setState(() {
            status2 = true;
          });
        }
      }
      check_status();
    });
  }

  void lop_queue() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        get_queue();
      });
    });
  }

  Future<void> get_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id, //1
    });
    setState(() {
      resTojson2 = json.decode(res.body);

      if (resTojson2 != null) {
        setState(() {});
        if (resTojson['queue_number'].toString() ==
                resTojson2['queue_number'].toString() &&
            resTojson['queue_number'] != '') {
          setState(() {
            print('ถึงคิว');
            _timer?.cancel();

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PrePareVideo()));
            status2 = true;
          });
        } else {
          print('ยังไม่ถึงคิว');
          print("คิวผู้ใช้        ${resTojson['queue_number'].toString()}");
          print("คิวที่กำลังเรียก  ${resTojson2['queue_number'].toString()}");
        }
      } else {
        setState(() {
          status2 = true;
        });
      }
    });
  }

  Future<void> check_status() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_video_status');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });

    setState(() {
      resTojson4 = json.decode(res.body);
      if (resTojson4 != null) {
        if (resTojson4['message'] == 'end') {
          setState(() {
            status = 'end';
            stop();
          });
        } else if (resTojson4['message'] == 'finished') {
          setState(() {
            status = 'finished';
            stop();
          });
          print('รายาการวันนี้เสร็จสิ้นเเล้ว');
        } else if (resTojson4['message'] == 'completed') {
          print('คุยเสร็จเเล้ว');
          setState(() {
            status = 'completed';
            stop();
          });
        } else if (resTojson4['message'] == 'processing') {
          setState(() {
            status = 'processing';
          });
          print('ถึงคิวเเล้ว');
        } else if (resTojson4['message'] == 'waiting') {
          print('ยังไม่ถึงคิว');
        } else if (resTojson4['message'] == 'no queue') {
          print('มีตรวจ/ยังไม่มีคิว');
        } else if (resTojson4['message'] == 'not found today appointment') {
          print('วันนี้ไม่มีรายการ');
        } else {
          print('resTojson4= ${resTojson4['message']}');
        }
      } else {
        print('resTojson = null');
      }
    });
  }

  void stop() {
    setState(() {
      _timer?.cancel();
    });
  }

  @override
  void initState() {
    checkt_queue();

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
          backgrund(),
          Positioned(
              child: ListView(
            children: resTojson != null
                ? [
                    BoxTime(),
                    WidgetNameHospital(),
                    SizedBox(
                      height: _height * 0.01,
                    ),
                    BoxDecorate(
                        color: Color.fromARGB(255, 43, 179, 161),
                        child: InformationCard(
                            dataidcard:
                                context.read<DataProvider>().dataidcard)),
                    SizedBox(height: _height * 0.02),
                    Column(
                      children: [
                        status != ''
                            ? BoxStatusinform(status: status)
                            : Column(
                                children: [
                                  Container(child: Center(child: BoxQueue())),
                                  BoxToDay(),
                                ],
                              ),
                        SizedBox(height: _height * 0.02),
                        choice(cancel: stop),
                      ],
                    ),
                    SizedBox(
                      height: _height * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        _timer?.cancel();
                        //  dispose();
                        context.read<Datafunction>().playsound();
                        setState(() {
                          context.read<DataProvider>().id = '';
                          Get.offNamed('home');
                        });

                        // Navigator.pushReplacement(context,
                        //    MaterialPageRoute(builder: (context) => Homeapp()));
                        //  Navigator.pop(context);
                      },
                      child: Container(
                          width: _width,
                          child: Center(
                              child: BoxWidetdew(
                            height: 0.06,
                            width: 0.35,
                            color: Colors.red,
                            radius: 5.0,
                            fontSize: 0.04,
                            text: 'ออก',
                            textcolor: Colors.white,
                          ))),
                    ),
                  ]
                : [
                    //  SizedBox(height: _height * 0.05),
                    //   GestureDetector(
                    //     onTap: () {
                    //       _timer?.cancel();
                    //       //  dispose();
                    //       context.read<Datafunction>().playsound();
                    //       if (_prePareVideo == null) {
                    //         PrePareVideo video = PrePareVideo();
                    //         print("init video pareare");
                    //         _prePareVideo = video;
                    //       }

                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => _prePareVideo!));
                    //     },
                    //     child: Container(
                    //         width: _width,
                    //         child: Center(
                    //             child: BoxWidetdew(
                    //           height: 0.06,
                    //           width: 0.35,
                    //           color: Colors.blue,
                    //           radius: 5.0,
                    //           fontSize: 0.04,
                    //           text: 'เข้าห้องตรวจ',
                    //           textcolor: Colors.white,
                    //         ))),
                    //   ),
                    //   SizedBox(height: _height * 0.02),
                  ],
          ))
        ],
      ),
    ));
  }
}

class choice extends StatefulWidget {
  choice({super.key, this.cancel});
  final VoidCallback? cancel;
  @override
  State<choice> createState() => _choiceState();
}

class _choiceState extends State<choice> {
  var resTojson;
  var resTojson2;
  String status = '';

  Future<void> getqueue() async {
    if (resTojson['health_records'].length == 0) {
      context.read<DataProvider>().status_getqueue = 'false';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ตรวจสุขภาพก่อนรับคิว',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
      Get.toNamed('healthrecord');
    } else {
      context.read<DataProvider>().status_getqueue = 'true';
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
      var res = await http.post(url, body: {
        'public_id': context.read<DataProvider>().id,
      });
      if (res.statusCode == 200) {
        print('รับคิว รีเซ็ท');
        setState(() {
          resTojson = json.decode(res.body);
          context.read<DataProvider>().status_getqueue == 'true';
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserInformation2()));
        });
      }
    }
  }

  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      if (resTojson != null) {
        init();
      }
    });
  }

  void init() {
    if (resTojson['queue_number'] == '' &&
        resTojson['health_records'].length != 0 &&
        context.read<DataProvider>().status_getqueue == 'false') {
      getqueue();
    } else {
      print('ไม่ผ่าน');
      print(resTojson['queue_number']);
      print(resTojson['health_records']);
      print(context.read<DataProvider>().status_getqueue);
    }
  }

  Future<void> check_status() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_video_status');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson2 = json.decode(res.body);
      if (resTojson2 != null) {
        if (resTojson2['message'] == 'finished') {
          setState(() {
            status = 'finished';
          });
          print('รายาการวันนี้เสร็จสิ้นเเล้ว');
        } else if (resTojson2['message'] == 'completed') {
          print('คุยเสร็จเเล้ว');
          setState(() {
            status = 'completed';
          });
        } else if (resTojson2['message'] == 'processing') {
          print('ถึงคิวเเล้ว');
        } else if (resTojson2['message'] == 'waiting') {
          print('ยังไม่ถึงคิว');
        } else if (resTojson2['message'] == 'no queue') {
          print('มีตรวจ/ยังไม่มีคิว');
        } else if (resTojson2['message'] == 'not found today appointment') {
          print('วันนี้ไม่มีรายการ');
        } else {
          print('resTojson2= ${resTojson2['message']}');
        }
      }
    });
  }

  @override
  void initState() {
    checkt_queue();
    check_status();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return resTojson2 != null && resTojson != null
        ? Container(
            width: _width,
            child: Center(
                child: Container(
              width: _width * 0.8,
              height: _height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: resTojson['queue_number'] == ''
                            ? () {
                                context.read<Datafunction>().playsound();
                                getqueue();
                              }
                            : () {
                                Get.offNamed('printqueue');
                                widget.cancel;
                              },
                        child: Container(
                            child: Center(
                                child: Container(
                          height: _height * 0.06,
                          width: _width * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 249, 249, 249),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1,
                                    color: Color.fromARGB(255, 76, 175, 150),
                                    spreadRadius: 0.8,
                                    offset: Offset(0, 3)),
                              ]),
                          child: Row(
                            children: [
                              Container(
                                height: _height * 0.06,
                                width: _width * 0.1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 76, 175, 150),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                              ),
                              SizedBox(width: _width * 0.01),
                              Text('ปริ้นคิว')
                            ],
                          ),
                        ))),
                      ),
                      GestureDetector(
                        onTap: () {
                          //  dispose();
                          widget.cancel;
                          context.read<Datafunction>().playsound();
                          Get.offNamed('healthrecord');
                        },
                        child: Container(
                            child: Center(
                                child: BoxWidetdew(
                          height: 0.06,
                          width: 0.35,
                          color: Colors.green,
                          // colorborder: resTojson['health_records'].length != 0
                          //     ? null
                          //     : Colors.yellow,
                          radius: 5.0,
                          fontSize: 0.04,
                          text: resTojson['health_records'].length != 0
                              ? 'ตรวจสุขภาพซ้ำ'
                              : 'ตรวจสุขภาพ',
                          textcolor: Colors.white,
                        ))),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Color.fromARGB(0, 255, 255, 255),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            context: context,
                            builder: (context) => Container(
                              height: _height * 0.6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: _height * 0.01,
                                      width: _width * 0.4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.grey)),
                                ),
                                HeadBoxAppointments(),
                                BoxAppointments(),
                              ]),
                            ),
                          );
                        },
                        child: Container(
                            child: Center(
                                child: BoxWidetdew(
                                    height: 0.06,
                                    width: 0.35,
                                    color: Colors.green,
                                    radius: 5.0,
                                    text: 'การนัดหมาย',
                                    fontSize: 0.04,
                                    textcolor: Colors.white))),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Color.fromARGB(0, 255, 255, 255),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            context: context,
                            builder: (context) => Container(
                              height: _height * 0.6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: _height * 0.01,
                                      width: _width * 0.4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.grey)),
                                ),
                                BoxShoHealth_Records(),
                              ]),
                            ),
                          );
                        },
                        child: Container(
                            child: Center(
                                child: BoxWidetdew(
                          height: 0.06,
                          width: 0.35,
                          color: Colors.green,
                          radius: 5.0,
                          fontSize: 0.04,
                          text: 'ประวัติสุขภาพ',
                          textcolor: Colors.white,
                        ))),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          )
        : Container();
  }
}
