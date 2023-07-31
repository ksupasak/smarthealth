import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/health_record/health_record2.dart';
import 'package:smart_health/caregiver/videocall/video.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/caregiver/widget/boxtime.dart';
import 'package:smart_health/caregiver/widget/informationCard.dart';
import 'package:smart_health/myapp/action/playsound.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:http/http.dart' as http;

class User_Information extends StatefulWidget {
  const User_Information({super.key});

  @override
  State<User_Information> createState() => _User_InformationState();
}

class _User_InformationState extends State<User_Information> {
  var resTojson;
  var doctor_note;
  Timer? timer;
  bool? status_internet;
  void lop() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (status_internet != context.read<DataProvider>().status_internet) {
        setState(() {
          status_internet = context.read<DataProvider>().status_internet;
        });
      }
    });
  }

  @override
  void initState() {
    lop();
    print('เข้าหน้าuser_information');
    checkt_queue();
    get_doctor_note();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> checkt_queue() async {
    if (context.read<DataProvider>().status_internet == true) {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      setState(() {
        resTojson = json.decode(res.body);
        if (resTojson != null) {
          print("health_records = ${resTojson['health_records'].length}");
        }
      });
    }
  }

  Future<void> get_doctor_note() async {
    if (context.read<DataProvider>().status_internet == true) {
      var url = Uri.parse(
          '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      setState(() {
        doctor_note = json.decode(res.body);
        if (resTojson != null) {
          print("doctor_note = ${resTojson['data']}");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    TextStyle style = TextStyle(
        fontSize: 16,
        color: const Color.fromARGB(255, 36, 36, 36),
        fontFamily: context.read<DataProvider>().family,
        shadows: [Shadow(color: Colors.grey, offset: Offset(0, 0))]);
    return RefreshIndicator(
      onRefresh: () async {
        checkt_queue();
        get_doctor_note();
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey),
          title: Text(
            'ผู้ตรวจ: ${context.read<DataProvider>().user_name}',
            style: TextStyle(
                color: Color(0xff48B5AA),
                fontFamily: context.read<DataProvider>().family,
                fontSize: 14),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person, color: Color(0xff1B6286)),
                  )),
            )
          ],
        ),
        body: Stack(
          children: [
            BackGrund(),
            Positioned(
              child: ListView(children: [
                BoxTimer(),
                Center(
                  child: Container(
                      width: _width * 0.9,
                      height: _height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 1,
                              color: Color(0xff48B5AA),
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Center(
                          child: InformationCard(
                        dataidcard: context.read<DataProvider>().resTojson,
                      ))),
                ),
                Container(height: _height * 0.02),
                Container(
                  //  height: _height * 0.5,
                  width: _width,
                  child: Column(
                    children: [
                      resTojson != null
                          ? resTojson['health_records'].length != 0
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                      'ตรวจเสร็จเเล้ว',
                                      style: TextStyle(
                                          fontFamily: context
                                              .read<DataProvider>()
                                              .family,
                                          fontSize: 22,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : SizedBox()
                          : SizedBox(),
                      doctor_note != null
                          ? doctor_note["data"] != null
                              ? doctor_note["data"]["doctor_note"] != null ||
                                      doctor_note["data"]["dx"] != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: _width * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('ผลการตรวจจากคุณหมอ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.green,
                                                      fontFamily: context
                                                          .read<DataProvider>()
                                                          .family,
                                                      shadows: [
                                                        Shadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1))
                                                      ])),
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                            'Doctor Dote :',
                                                            style: style)),
                                                    Container(
                                                        width: _width * 0.5,
                                                        child: doctor_note[
                                                                        "data"][
                                                                    "doctor_note"] !=
                                                                null
                                                            ? Text(
                                                                '${doctor_note["data"]["doctor_note"]}',
                                                                style: style)
                                                            : SizedBox())
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                            '                 :',
                                                            style: style)),
                                                    Container(
                                                        width: _width * 0.5,
                                                        child: doctor_note[
                                                                        "data"]
                                                                    ["dx"] !=
                                                                null
                                                            ? Text(
                                                                '${doctor_note["data"]["dx"]}',
                                                                style: style)
                                                            : SizedBox())
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                              : SizedBox()
                          : SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                keypad_sound();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HealthRecord2()));
                              },
                              child: Container(
                                height: _height * 0.23,
                                width: _width * 0.45,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 129, 129, 129),
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: Offset(0, 2)),
                                    ],
                                    color: Color(0xff48B5AA),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(children: [
                                    Container(
                                      height: _height * 0.15,
                                      width: _width * 0.4,
                                      child: Image.asset(
                                        "assets/jpfs.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'ตรวจสุขภาพ',
                                        style: TextStyle(
                                            shadows: [
                                              Shadow(
                                                  blurRadius: 1,
                                                  color: Colors.black,
                                                  offset: Offset(0, 1))
                                            ],
                                            color: Colors.white,
                                            fontFamily: context
                                                .read<DataProvider>()
                                                .family,
                                            fontSize: _width * 0.06),
                                      ),
                                    )
                                  ]),
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                keypad_sound();
                                if (context
                                        .read<DataProvider>()
                                        .status_internet ==
                                    true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrePareVideo()));
                                }
                              },
                              child: Container(
                                height: _height * 0.23,
                                width: _width * 0.45,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 129, 129, 129),
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: Offset(0, 2)),
                                    ],
                                    color: Color(0xff31D6AA),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(children: [
                                          Container(
                                            height: _height * 0.15,
                                            width: _width * 0.4,
                                            child: Image.asset(
                                              "assets/pfrt9190.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'ปรึกษาเเพทย์',
                                              style: TextStyle(
                                                  shadows: [
                                                    Shadow(
                                                        blurRadius: 1,
                                                        color: Colors.black,
                                                        offset: Offset(0, 1))
                                                  ],
                                                  color: Colors.white,
                                                  fontFamily: context
                                                      .read<DataProvider>()
                                                      .family,
                                                  fontSize: _width * 0.06),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                    context
                                                .read<DataProvider>()
                                                .status_internet !=
                                            true
                                        ? Positioned(
                                            child: Container(
                                            height: _height * 0.23,
                                            width: _width * 0.45,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    150, 0, 0, 0),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/Group 92251.png'),
                                              ),
                                            ),
                                          ))
                                        : Container(),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.amber,
                  height: _height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      choice(),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
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
      // context.read<DataProvider>().status_getqueue = 'false';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ตรวจสุขภาพก่อนรับคิว',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
      // Get.toNamed('healthrecord');
    } else {
      //  context.read<DataProvider>().status_getqueue = 'true';
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      if (res.statusCode == 200) {
        print('รับคิว รีเซ็ท');
        setState(() {
          resTojson = json.decode(res.body);
          // context.read<DataProvider>().status_getqueue == 'true';
          Navigator.pop(context);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => UserInformation2()));
        });
      }
    }
  }

  Future<void> checkt_queue() async {
    if (context.read<DataProvider>().status_internet == true) {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      List c = [];
      setState(() {
        resTojson = json.decode(res.body);
        if (resTojson != null) {
          // print("health_records = ${resTojson['health_records'].length}");
        }
      });
    }
  }

  @override
  void initState() {
    checkt_queue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    BoxDecoration boxDecoration1 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color.fromARGB(255, 245, 245, 245)),
      boxShadow: [
        BoxShadow(
            color: Color(0xffFFA800),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 2)
      ],
    );
    BoxDecoration boxDecoration2 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color(0xff31D6AA), width: 2),
      boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 172, 172, 172),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 2)
      ],
    );
    BoxDecoration boxDecoration3 = BoxDecoration(
      //jrotkj
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color.fromARGB(255, 255, 84, 84), width: 2),
      boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 255, 84, 84),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 2)
      ],
    );
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.035,
        color: Color(0xff48B5AA));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.035,
        color: Color.fromARGB(255, 255, 84, 84));
    return Container(
      height: _height * 0.15,
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: _width * 0.05),
          GestureDetector(
            onTap: () {
              keypad_sound();
              showModalBottomSheet(
                backgroundColor: Color.fromARGB(0, 255, 255, 255),
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
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
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey)),
                    ),
                    BoxShoHealth_Records(),
                  ]),
                ),
              );
            },
            child: Container(
                height: _height * 0.06,
                width: _width * 0.45,
                decoration: boxDecoration2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset('assets/Group 92084.png'),
                      SizedBox(width: _width * 0.01),
                      Center(
                          child: Text(
                        'ประวัติการตรวจ',
                        style: style,
                      )),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class HeadBoxAppointments extends StatefulWidget {
  const HeadBoxAppointments({super.key});

  @override
  State<HeadBoxAppointments> createState() => _HeadBoxAppointmentsState();
}

class _HeadBoxAppointmentsState extends State<HeadBoxAppointments> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w800);
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 0, 73, 129),
        fontSize: _width * 0.045,
        fontWeight: FontWeight.w600);
    return Container(
      child: Column(
        children: [
          Text("การนัดหมายครั้งถัดไป", style: style),
          Container(
            color: Color.fromARGB(255, 115, 250, 221),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('วันที่', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('เวลา', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('สถานที่', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('เเพทย์', style: style2))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoxAppointments extends StatefulWidget {
  BoxAppointments({
    super.key,
  });

  @override
  State<BoxAppointments> createState() => _BoxAppointmentsState();
}

class _BoxAppointmentsState extends State<BoxAppointments> {
  var resTojson;
  void information() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  @override
  void initState() {
    information();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    return Container(
        width: _width,
        child: Column(
          children: [
            Container(
              height: _height * 0.38,
              child: resTojson != null
                  ? resTojson['appointments'].length != 0
                      ? ListView.builder(
                          itemCount: resTojson['appointments'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // context.read<Datafunction>().playsound();
                                print(index);
                              },
                              child: Container(
                                color: Color.fromARGB(255, 219, 246, 240),
                                height: _height * 0.04,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['date'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['slot'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['care_name'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['doctor_name'],
                                                style: style))),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Column(children: [
                          Container(
                              width: _height,
                              height: _height * 0.04,
                              color: Color.fromARGB(100, 255, 255, 255),
                              child: Center(
                                  child: Text('ไม่มีรายการ', style: style)))
                        ]))
                  : Container(),
            ),
            SizedBox(
              height: _height * 0.01,
            ),
            //  ButtonAddAppointToday()
          ],
        ));
  }
}

class BoxShoHealth_Records extends StatefulWidget {
  BoxShoHealth_Records({super.key});

  @override
  State<BoxShoHealth_Records> createState() => _BoxShoHealth_RecordsState();
}

class _BoxShoHealth_RecordsState extends State<BoxShoHealth_Records> {
  var resTojson;
  void information() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      print(resTojson);
    });
  }

  @override
  void initState() {
    information();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle styletext = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Colors.white,
        fontSize: _width * 0.04);
    TextStyle styletext2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 12, 172, 153),
        fontSize: _width * 0.03);
    TextStyle styletext3 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    TextStyle styletext4 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 28, 1, 91),
        fontSize: _width * 0.03);
    TextStyle styletext5 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 12, 172, 153),
        fontSize: _width * 0.025);
    return Container(
      width: _width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('ข้อมูลสุขภาพ', style: styletext3),
          Container(
            color: Color.fromARGB(255, 95, 182, 167),
            height: _height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BoxDataHealth(child: Text('วันที่', style: styletext)),
                BoxDataHealth(child: Text('height', style: styletext)),
                BoxDataHealth(child: Text('weight', style: styletext)),
                BoxDataHealth(child: Text('temp', style: styletext)),
                BoxDataHealth(child: Text('sys.', style: styletext)),
                BoxDataHealth(child: Text('dia', style: styletext)),
                BoxDataHealth(child: Text('spo2', style: styletext)),
                // Text('fbs', style: styletext),
                // Text('si', style: styletext),
                // Text('uric', style: styletext),
                // Text('pulse_rate.', style: styletext),
              ],
            ),
          ),
          resTojson != null
              ? resTojson['health_records'].length != 0
                  ? Container(
                      height: _height * 0.35,
                      child: ListView.builder(
                        itemCount: resTojson['health_records'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              //    context.read<Datafunction>().playsound();
                              print(index);
                            },
                            child: Column(
                              children: [
                                Container(height: 1, color: Colors.white),
                                Container(
                                  color: Color.fromARGB(255, 219, 246, 240),
                                  height: _height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      resTojson['health_records'][index]
                                                  ['updated_at'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['updated_at']}',
                                                  style: styletext5)),
                                      resTojson['health_records'][index]
                                                  ['height'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['height']}',
                                                  style: styletext2)),
                                      resTojson['health_records'][index]
                                                  ['weight'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['weight']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['temp'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['temp']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['bp_dia'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['bp_dia']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['bp_sys'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['bp_sys']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['spo2'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['spo2']}',
                                                  style: styletext2),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ))
                  : Container(
                      height: _height * 0.04,
                      color: Color.fromARGB(100, 255, 255, 255),
                      child: Center(
                          child: Text('ไม่มีข้อมูลสุขภาพ', style: styletext4)),
                    )
              : Container()
        ],
      ),
    );
  }
}

class BoxDataHealth extends StatefulWidget {
  BoxDataHealth({super.key, required this.child});
  Widget child;
  @override
  State<BoxDataHealth> createState() => _BoxDataHealthState();
}

class _BoxDataHealthState extends State<BoxDataHealth> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width * 0.14,
      child: Center(child: widget.child),
    );
  }
}
