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
  var resTojson3;
  var resTojson2;
  var resTojson;
  bool video = false;
  late OpenViduClient _openvidu;
  Future<void> checkt_queue() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      if (resTojson != null) {
        if (resTojson['queue_number'] != '') {
          lop_queue();
        }
      }
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
    var url = Uri.parse('https://emr-life.com/clinic_master/clinic/Api/list_q');
    var res = await http.post(url, body: {
      'care_unit_id': '63d7a282790f9bc85700000e',
    });
    setState(() {
      resTojson2 = json.decode(res.body);

      if (resTojson2 != null) {
        setState(() {});
        if (resTojson['queue_number'].toString() ==
            resTojson2['queue_number'].toString()) {
          setState(() {
            print('ถึงคิว');
            _timer?.cancel();

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PrePareVideo()));
            video = true;
          });
        } else {
          print('ยังไม่ถึงคิว');
          print("คิวผู้ใช้        ${resTojson['queue_number'].toString()}");
          print("คิวที่กำลังเรียก  ${resTojson2['queue_number'].toString()}");
        }
      }
    });
  }

  void stop() {
    setState(() {
      _timer?.cancel();
    });
  }

  // Future<void> statusvideo() async {
  //   var url = Uri.parse(
  //       'https://emr-life.com/clinic_master/clinic/Api/get_video_status');
  //   var res = await http.post(url, body: {
  //     'public_id': context.read<DataProvider>().id,
  //   });
  //   setState(() async {
  //     resTojson3 = json.decode(res.body);
  //     if (resTojson3 != null) {
  //       if (resTojson3['message'] == 'end') {
  //         _timer2?.cancel();
  //         final nav = Navigator.of(context);
  //         await _openvidu.disconnect();
  //         nav.pop();
  //       }
  //     }
  //   });
  // }

  // void lop() {
  //   _timer2 = Timer.periodic(Duration(seconds: 2), (timer) {
  //     setState(() {
  //       statusvideo();
  //     });
  //   });
  // }

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
            children: [
              BoxTime(),
              BoxDecorate(
                  color: Color.fromARGB(255, 43, 179, 161),
                  child: InformationCard(
                      dataidcard: context.read<DataProvider>().dataidcard)),
              SizedBox(height: _height * 0.01),
              Column(
                children: video != false
                    ? [
                        SizedBox(height: _height * 0.05),
                        GestureDetector(
                          onTap: () {
                            _timer?.cancel();
                            //  dispose();
                            context.read<Datafunction>().playsound();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrePareVideo()));
                          },
                          child: Container(
                              width: _width,
                              child: Center(
                                  child: BoxWidetdew(
                                height: 0.06,
                                width: 0.35,
                                color: Colors.blue,
                                radius: 5.0,
                                fontSize: 0.04,
                                text: 'เข้าห้องตรวจ',
                                textcolor: Colors.white,
                              ))),
                        ),
                        SizedBox(height: _height * 0.02),
                      ]
                    : [
                        Container(child: Center(child: BoxQueue())),
                        BoxToDay(),
                        choice(cancel: stop),
                      ],
              ),
              GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  //  dispose();
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
                      fontSize: 0.04,
                      text: 'ออก',
                      textcolor: Colors.white,
                    ))),
              ),
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
  Future<void> getqueue() async {
    if (resTojson['health_records'].length == 0) {
      context.read<DataProvider>().status_getqueue = 'false';
      Get.toNamed('healthrecord');
    } else {
      context.read<DataProvider>().status_getqueue = 'true';
      var url =
          Uri.parse('https://emr-life.com/clinic_master/clinic/Api/get_q');
      var res = await http.post(url, body: {
        'public_id': context.read<DataProvider>().id,
      });
      if (res.statusCode == 200) {
        setState(() {
          resTojson = json.decode(res.body);
          context.read<DataProvider>().status_getqueue == 'true';
          Get.offAllNamed('user_information');
        });
      }
    }
  }

  Future<void> checkt_queue() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
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
    }
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
    return resTojson != null
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
                                Get.toNamed('printqueue');
                              },
                        child: Container(
                            child: Center(
                                child: BoxWidetdew(
                          height: 0.06,
                          width: 0.35,
                          color: resTojson['todays'].length != 0
                              ? Colors.green
                              : Color.fromARGB(150, 175, 76, 76),
                          radius: 5.0,
                          text: resTojson['queue_number'] == ''
                              ? 'รับคิว'
                              : 'ปริ้นคิว',
                          fontSize: 0.04,
                          textcolor: resTojson['todays'].length != 0
                              ? Colors.white
                              : Color.fromARGB(150, 255, 255, 255),
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
                              height: _height * 0.5,
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
                              height: _height * 0.5,
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
