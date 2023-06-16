import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:get/get.dart';
import 'package:openvidu_client/openvidu_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/test/esm_printer.dart';
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
  String height = '-';
  String weight = '-';
  String temp = '-';
  String sys = '-';
  String dia = '-';
  String spo2 = '-';
  String status = '';
  ESMPrinter? printer;
  bool status2 = false;
  late OpenViduClient _openvidu;
  bool ontap = false;
  PrePareVideo? _prePareVideo;
  String doctor_note = '--';
  String dx = '--';

  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
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
    if (resTojson['health_records'].length != 0) {
      height = resTojson['health_records'][0]['height'].toString();
      weight = resTojson['health_records'][0]['weight'].toString();
      temp = resTojson['health_records'][0]['temp'].toString();
      sys = resTojson['health_records'][0]['bp_sys'].toString();
      dia = resTojson['health_records'][0]['bp_dia'].toString();
      spo2 = resTojson['health_records'][0]['spo2'].toString();
    }
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

  Future<void> q() async {
    if (resTojson['health_records'].length != 0) {
      print('รับคิวได้');
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
      var res = await http.post(url, body: {
        'public_id': context.read<DataProvider>().id,
        'care_unit_id': context.read<DataProvider>().care_unit_id
      });
      if (res.statusCode == 200) {
        ontap = false;
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            Navigator.pop(context);
          });
        });
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed('user_information');
        });
      }
    } else {
      print('รับคิวไม่ได้');
      Get.offNamed('healthrecord');
    }
  }

  Future<void> exam() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson2 = json.decode(res.body);
      doctor_note = resTojson2['data']['doctor_note'];
      dx = resTojson2['data']['dx'];
      if (resTojson2 != null) {
        setState(() {
          ontap = false;
          printexam();
        });
      }
    });
  }

  void printexam() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text(context.read<DataProvider>().name_hospital,
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text('Examination',
        styles: const PosStyles(
            width: PosTextSize.size1, height: PosTextSize.size1));
    bytes += generator.text('\n');
    bytes += generator.text('Doctor  :  pairot tanyajasesn');
    bytes += generator.text('Results :  ${dx}');
    bytes += generator.text('        :  ${doctor_note}');
    printer?.printTest(bytes);
  }

  Future<void> printq() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.text(context.read<DataProvider>().name_hospital,
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("Q ${resTojson['queue_number']}",
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size3,
            height: PosTextSize.size3,
            fontType: PosFontType.fontA));
    bytes += generator.text('\n');
    bytes +=
        generator.text('Doctor :   ${resTojson['todays'][0]['doctor_name']}');
    bytes += generator.text(
        'Care   :  ${resTojson['todays'][0]['care_name']} / ( ${resTojson['todays'][0]['slot']} )');
    bytes += generator.text('\n');
    bytes += generator.text('Health Information',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'height',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: 'weight',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: 'temp',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: height,
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: weight,
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: temp,
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'sys',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: 'dia',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: 'spo2',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: sys,
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: dia,
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: spo2,
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
    ]);
    ontap = false;
    printer?.printTest(bytes);
  }

  @override
  void initState() {
    checkt_queue();
    printer = ESMPrinter([
      {'vendor_id': '19267', 'product_id': '14384'},
      //   {'vendor_id': '1137', 'product_id': '85'}
    ]);
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
                    Container(
                      height: _height * 0.25,
                      //   color: Color.fromARGB(100, 76, 175, 79),
                      child: Column(
                        children: [
                          BoxTime(),
                          BoxDecorate(
                              child: InformationCard(
                                  dataidcard:
                                      context.read<DataProvider>().dataidcard)),
                        ],
                      ),
                    ),
                    Container(
                      height: _height * 0.5,
                      //    color: Color.fromARGB(100, 255, 235, 59),
                      child: Column(
                        children: [
                          status != ''
                              ? Column(
                                  children: [
                                    BoxStatusinform(status: status),
                                    SizedBox(
                                      height: _height * 0.01,
                                    ),
                                    ontap == true
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: CircularProgressIndicator(
                                              color: Color(0xff76FFD5),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ontap = true;
                                              });
                                              exam();
                                            },
                                            child: Container(
                                                height: _height * 0.05,
                                                width: _width * 0.3,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff31D6AA),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(0, 4),
                                                        blurRadius: 5,
                                                      )
                                                    ]),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                          'assets/jhb.png'),
                                                      Text('  ปริ้นผลตรวจ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily: context
                                                                  .read<
                                                                      DataProvider>()
                                                                  .fontFamily,
                                                              fontSize:
                                                                  _width * 0.03,
                                                              color:
                                                                  Colors.white))
                                                    ])),
                                          )
                                  ],
                                )
                              : Column(
                                  children: [
                                    //  Container(child: Center(child: BoxQueue())),
                                    BoxToDay(),
                                    SizedBox(height: _height * 0.01),

                                    ontap == false
                                        ? resTojson['todays'].length != 0
                                            ? resTojson['queue_number'] != ''
                                                ? GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        ontap = true;
                                                      });
                                                      printq();
                                                    },
                                                    child: Container(
                                                        height: _height * 0.05,
                                                        width: _width * 0.3,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xff31D6AA),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                offset: Offset(
                                                                    0, 4),
                                                                blurRadius: 5,
                                                              )
                                                            ]),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                  'assets/jhb.png'),
                                                              Text('  ปริ้น',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily: context
                                                                          .read<
                                                                              DataProvider>()
                                                                          .fontFamily,
                                                                      fontSize:
                                                                          _width *
                                                                              0.03,
                                                                      color: Colors
                                                                          .white))
                                                            ])),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        ontap = true;
                                                      });
                                                      q();
                                                    },
                                                    child: Container(
                                                        height: _height * 0.05,
                                                        width: _width * 0.3,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xff31D6AA),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                offset: Offset(
                                                                    0, 4),
                                                                blurRadius: 5,
                                                              )
                                                            ]),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                  'assets/jhb.png'),
                                                              Text('  รับคิว',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily: context
                                                                          .read<
                                                                              DataProvider>()
                                                                          .fontFamily,
                                                                      fontSize:
                                                                          _width *
                                                                              0.03,
                                                                      color: Colors
                                                                          .white))
                                                            ])),
                                                  )
                                            : Container()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            child: CircularProgressIndicator(
                                                color: Color(0xff76FFD5)),
                                          )
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Container(
                      //  color: Color.fromARGB(100, 244, 67, 54),
                      height: _height * 0.15,
                      child: Column(
                        children: [
                          choice(cancel: stop),
                        ],
                      ),
                    ),
                  ]
                : [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: MediaQuery.of(context).size.width * 0.07,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xff000000))),
                    ),
                  ],
          ))
        ],
      ),
      bottomNavigationBar: Container(
        height: _height * 0.03,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  context.read<Datafunction>().playsound();
                  setState(() {
                    context.read<DataProvider>().id = '';
                    Get.offNamed('home');
                  });
                },
                child: Container(
                  height: _height * 0.025,
                  width: _width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color.fromARGB(255, 201, 201, 201),
                          width: _width * 0.002)),
                  child: Center(
                      child: Text(
                    '< ย้อนกลับ',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: _width * 0.03,
                        color: Color.fromARGB(255, 201, 201, 201)),
                  )),
                ),
              ),
            ),
          ],
        ),
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
        'care_unit_id': context.read<DataProvider>().care_unit_id,
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
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      if (resTojson != null) {
        // init();
      }
    });
  }

  // void init() {
  //   if (resTojson['queue_number'] == '' &&
  //       resTojson['health_records'].length != 0 &&
  //       context.read<DataProvider>().status_getqueue == 'false') {
  //     getqueue();
  //   } else {
  //     print('ไม่ผ่าน');
  //     print(resTojson['queue_number']);
  //     print(resTojson['health_records']);
  //     print(context.read<DataProvider>().status_getqueue);
  //   }
  // }

  // Future<void> check_status() async {
  //   var url = Uri.parse(
  //       '${context.read<DataProvider>().platfromURL}/get_video_status');
  //   var res = await http.post(url, body: {
  //     'public_id': context.read<DataProvider>().id,
  //   });
  //   setState(() {
  //     resTojson2 = json.decode(res.body);
  //     if (resTojson2 != null) {
  //       if (resTojson2['message'] == 'finished') {
  //         setState(() {
  //           status = 'finished';
  //         });
  //         print('รายาการวันนี้เสร็จสิ้นเเล้ว');
  //       } else if (resTojson2['message'] == 'completed') {
  //         print('คุยเสร็จเเล้ว');
  //         setState(() {
  //           status = 'completed';
  //         });
  //       } else if (resTojson2['message'] == 'processing') {
  //         print('ถึงคิวเเล้ว');
  //       } else if (resTojson2['message'] == 'waiting') {
  //         print('ยังไม่ถึงคิว');
  //       } else if (resTojson2['message'] == 'no queue') {
  //         print('มีตรวจ/ยังไม่มีคิว');
  //       } else if (resTojson2['message'] == 'not found today appointment') {
  //         print('วันนี้ไม่มีรายการ');
  //       } else {
  //         print('resTojson2= ${resTojson2['message']}');
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    checkt_queue();
    // check_status();
    // TODO: implement initState
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
      border: Border.all(color: Color.fromARGB(255, 245, 245, 245)),
      boxShadow: [
        BoxShadow(
            color: Color(0xff0076B1),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 2)
      ],
    );
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.035,
        color: Color(0xff1B6286));
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // GestureDetector(
          //     onTap: () {
          //       getqueue();
          //     },
          //     child: Container(
          //       width: 100,
          //       height: 100,
          //       color: Colors.black,
          //     )),
          //  ButtonQueue(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
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
                        HeadBoxAppointments(),
                        BoxAppointments(),
                      ]),
                    ),
                  );
                },
                child: Container(
                    height: _height * 0.05,
                    width: _width * 0.35,
                    decoration: boxDecoration1,
                    child: Row(
                      children: [
                        Image.asset('assets/pasd.png'),
                        Center(
                            child: Text(
                          'การนัดหมาย',
                          style: style,
                        )),
                      ],
                    )),
              ),
              SizedBox(
                width: _width * 0.05,
              ),
              GestureDetector(
                onTap: () {
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
                    height: _height * 0.05,
                    width: _width * 0.35,
                    decoration: boxDecoration2,
                    child: Row(
                      children: [
                        Image.asset('assets/ksjope.png'),
                        Center(
                            child: Text(
                          'ประวัติสุขภาพ',
                          style: style,
                        )),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
