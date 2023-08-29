import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/caregiver/center/center.dart';
import 'package:smart_health/caregiver/format_list/format_list.dart';
import 'package:smart_health/caregiver/center/esm_cardread/esm_idcard.dart';
import 'package:smart_health/caregiver/home/fillout.dart';
import 'package:smart_health/caregiver/login/login.dart';
import 'package:smart_health/caregiver/register_patient/register_patient.dart';
import 'package:smart_health/caregiver/user_information/user_information.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/caregiver/widget/numpad.dart';
import 'package:smart_health/myapp/action/playsound.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/setting/setting.dart';
import 'package:smart_health/myapp/widgetdew.dart';

import 'package:http/http.dart' as http;

class HomeCareCevier extends StatefulWidget {
  HomeCareCevier({
    super.key,
    this.navigation,
  });
  final VoidCallback? navigation;
  @override
  State<HomeCareCevier> createState() => _HomeCareCevierState();
}

class _HomeCareCevierState extends State<HomeCareCevier> {
  bool status = false;
  ESMIDCard? reader;

  var devices;
  StreamSubscription? _functionScan;
  StreamSubscription? _functionReaddata;
  StreamSubscription? cardReader;
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  Timer? _timer;
  Timer? reading;
  int index_bottomNavigationBar = 0;
  var value_creadreader;
  final idcard = Numpad();

  Stream<String>? entry;
  Stream<String>? reader_status;

  void check() async {
    setState(() {
      status = true;
    });
    // context.read<Datafunction>().playsound();
    if (context.read<DataProvider>().id.length == 13) {
      if (context.read<DataProvider>().status_internet == true) {
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
          // navigator();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Popup();
              });
        } else {
          setState(() {
            status = false;
            context.read<DataProvider>().resTojson = resTojson;
            print(
                'context.read<DataProvider>().resTojson  = ${context.read<DataProvider>().resTojson}');
          });
          Timer(Duration(seconds: 1), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => User_Information(
                          listdata: [],
                        )));
            //  Get.toNamed('user_information');
          });
        }
      } else {
        setState(() {
          status = false;
          context.read<DataProvider>().resTojson = null;
        });

        if (context.read<DataProvider>().creadreader.length != 0 &&
            context.read<DataProvider>().creadreader[0] ==
                context.read<DataProvider>().id) {
          Timer(Duration(seconds: 1), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => User_Information(
                          listdata: [],
                        )));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'ตรวจเเบบ Offline',
                    )))));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'กรุณากรอกข้อมูล',
                  )))));
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Fill_Out(id: context.read<DataProvider>().id);
              });
        }
      }
    } else {
      if (context.read<DataProvider>().id.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'กรุณากรอกเลขบัตรประชาชนไห้ครบ13หลัก',
                )))));
      }

      setState(() {
        status = false;
      });
    }
  }

  void navigator() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (context.read<DataProvider>().creadreader != value_creadreader) {
        value_creadreader = context.read<DataProvider>().creadreader;
        check();
      }
    });
  }

  @override
  void initState() {
    print('เข้าหน้าHome');
    navigator();
    // TODO: implement initState
    super.initState();

    // startReader();
  }

  @override
  void dispose() {
    reading?.cancel();
    _functionScan?.cancel();
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(child: BackGrund()),
            Positioned(child: _width > _height ? style_width() : style_height())
          ],
        ),
      ),
    );
  }

  Widget style_height() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        height: _height,
        width: _width,
        child: ListView(children: [
          Container(
            //    color: Color.fromARGB(29, 167, 62, 62),
            height: _height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('SMART CARE GIVER',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: context.read<DataProvider>().family,
                              fontSize: _width * 0.05,
                              color: Color(0xffffffff))),
                    ),
                  ],
                ),
                context.read<DataProvider>().user_name != null &&
                        context.read<DataProvider>().user_name != ''
                    ? Container(
                        height: _height * 0.13,
                        width: _width * 0.85,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: Color(0xff48B5AA),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(
                          children: [
                            Positioned(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: _height * 0.1,
                                        width: _height * 0.1,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff48B5AA)),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Icon(
                                          Icons.person,
                                          color: Color(0xff48B5AA),
                                        )),
                                  ),
                                  Container(
                                    width: _width * 0.57,
                                    height: _height * 0.13,
                                    child: Row(
                                      children: [
                                        Text(
                                          'ผู้ตรวจ: ${context.read<DataProvider>().user_name}',
                                          style: TextStyle(
                                              fontFamily: context
                                                  .read<DataProvider>()
                                                  .family,
                                              fontSize: _width * 0.04,
                                              color: Color(0xff48B5AA)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                    onTap: widget.navigation,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: _width * 0.2,
                                        height: _height * 0.03,
                                        decoration: BoxDecoration(
                                            color: Color(0xff31d6aa),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'เปลี่ยนผู้ตรวจ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: context
                                                      .read<DataProvider>()
                                                      .family,
                                                  fontSize: _width * 0.02),
                                            )
                                          ],
                                        ),
                                      ),
                                    )))
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: widget.navigation,
                        child: Container(
                          height: _height * 0.13,
                          width: _width * 0.85,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                  color: Color(0xff48B5AA),
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            children: [
                              Positioned(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'ยังไม่ผู้ตรวจ',
                                              style: TextStyle(
                                                  fontSize: _width * 0.04,
                                                  color: Color(0xff48B5AA),
                                                  fontFamily: context
                                                      .read<DataProvider>()
                                                      .family),
                                            )),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: widget.navigation,
                                      child: Container(
                                        height: _height * 0.04,
                                        width: _height * 0.04,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Color(0xff48B5AA))),
                                        child: Icon(
                                          Icons.add,
                                          color: Color(0xff48B5AA),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                Container(
                  child: Column(
                    children: [
                      Text('กรุณาเสียบบัตรประชาชนหรือกรอกเลข',
                          style: TextStyle(
                              fontFamily: context.read<DataProvider>().family,
                              fontSize: _width * 0.04,
                              color: Color(0xff00A3FF))),
                      Text('บัตรประชาชน เพื่อตรวจ',
                          style: TextStyle(
                              fontFamily: context.read<DataProvider>().family,
                              fontSize: _width * 0.04,
                              color: Color(0xff00A3FF))),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(child: idcard),
          SizedBox(height: _height * 0.01),
          status == false
              ? Container(
                  child: Center(
                  child: GestureDetector(
                      onTap: () {
                        check();
                        keypad_sound();
                      },
                      child: BoxWidetdew(
                          color: Color(0xff31D6AA),
                          height: 0.05,
                          width: 0.3,
                          text: 'ตกลง',
                          radius: 10.0,
                          textcolor: Colors.white,
                          fontSize: 0.05)),
                ))
              : Container(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
          Container(
            height: _height * 0.2,
            width: _width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: []),
          )
        ]));
  }

  Widget style_width() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height,
      width: _width,
      child: ListView(children: [
        //  Container(child: Numpad())
      ]),
    );
  }
}

class Popup extends StatefulWidget {
  Popup({
    super.key,
    this.texthead,
    this.textbody,
    this.pathicon,
    this.buttonbar,
    this.fontSize,
  });
  var texthead;
  var textbody;
  var pathicon;
  var buttonbar;
  var fontSize;
  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return AlertDialog(
      icon: Container(
        width: _width * 0.8,
        child: Center(
          child: Image.asset(
            "assets/warning.png",
            width: _width * 0.4,
            height: _height * 0.18,
          ),
        ),
      ),
      title: Text(
        "ไม่พบข้อมูลในระบบ",
        style: TextStyle(
            fontFamily: context.read<DataProvider>().family, fontSize: 16),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                keypad_sound();
              },
              child: Container(
                child: Center(
                  child: Text('ยกเลิก',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().family,
                          fontSize: 16,
                          color: Colors.red)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                keypad_sound();
                Navigator.pop(context);
                if (context.read<DataProvider>().creadreader.length != 0) {
                  if (context.read<DataProvider>().id.toString() ==
                      context.read<DataProvider>().creadreader[0].toString()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register_Patient()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Text(
                              'กรุณาเสียบบัตรประชาชน',
                            )))));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text(
                            'กรุณาเสียบบัตรประชาชน...',
                          )))));
                }
              },
              child: Container(
                child: Center(
                  child: Text('ลงทะเบียน',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().family,
                          fontSize: 16,
                          color: Colors.green)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
