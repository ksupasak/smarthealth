import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/caregiver/format_list/format_list.dart';
import 'package:smart_health/caregiver/home/esm_cardread/esm_idcard.dart';
import 'package:smart_health/caregiver/login/login.dart';
import 'package:smart_health/caregiver/user_information/user_information.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/caregiver/widget/numpad.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/setting/setting.dart';
import 'package:smart_health/myapp/widgetdew.dart';

import 'package:http/http.dart' as http;

class HomeCareCevier extends StatefulWidget {
  const HomeCareCevier({super.key});

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

  final idcard = Numpad();

  Stream<String>? entry;
  Stream<String>? reader_status;

  void startReader() {
    try {
      Future.delayed(const Duration(seconds: 2), () {
        reader = ESMIDCard.instance;

        // reader?.findReader();

        entry = reader?.getEntry();

        print('->initstate ');
        if (entry != null) {
          print('entry!=null');
          // if (cardReader == null) {
          if (true) {
            cardReader = entry?.listen((String data) async {
              print("IDCard " + data);
              List<String> splitted = data.split('#');
              setState(() {});
              print(
                  "${context.read<DataProvider>().id} / ${splitted[0].toString()}");
              context.read<DataProvider>().id = splitted[0].toString();
              context.read<DataProvider>().user_id = splitted[0].toString();
              // idcard.setValue(splitted[0]);

              if (context.read<DataProvider>().id == splitted[0].toString()) {
              } else {}
            }, onError: (error) {
              print(error);
            }, onDone: () {
              print('Stream closed!');
            });
          }
        } else {
          print('entry ==null');
        }

        reader_status = reader?.getStatus();
        reader_status?.listen((String data) async {
          print("Reader Status :  " + data);

          if (data == "ADAPTER_READY") {
            reader?.findReader();
          } else if (data == "DEVICE_READY") {
            const oneSec = Duration(seconds: 2);
            reading = Timer.periodic(oneSec, (Timer t) => checkCard());
          }
        });
      });
    } on Exception catch (e) {
      print('error');
      print(e.toString());
    }
  }

  void checkCard() async {
    print('เช็คการ์ด');
    reader?.readAuto();
  }

  void check() async {
    setState(() {
      status = true;
    });
    // context.read<Datafunction>().playsound();
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
                            // Get.toNamed('regter');
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

          context.read<DataProvider>().resTojson = resTojson;
          print(
              '  context.read<DataProvider>().resTojson  = ${context.read<DataProvider>().resTojson}');
        });
        Timer(Duration(seconds: 1), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => User_Information()));
          //  Get.toNamed('user_information');
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

  Future<void> load_list_patients() async {
    var resTojson;
    if (context.read<DataProvider>().user_id != null &&
        context.read<DataProvider>().user_id != '') {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/get_recep');
      var res = await http
          .post(url, body: {'public_id': context.read<DataProvider>().user_id});
      resTojson = json.decode(res.body);

      setState(() {
        context.read<DataProvider>().list_patients = resTojson['list'];
        print("List Patients${context.read<DataProvider>().list_patients}");
      });
    }
  }

  @override
  void initState() {
    print('เข้าหน้าHome');
    load_list_patients();

    // TODO: implement initState
    super.initState();

    // startReader();
  }

  @override
  void dispose() {
    reading!.cancel();
    _functionScan!.cancel();
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    List<Widget> body = [
      Stack(
        children: [
          Positioned(child: BackGrund()),
          Positioned(child: _width > _height ? style_width() : style_height())
        ],
      ),
      // FormatList(),
      // Login_User(),
      // Setting(),
    ];
    return SafeArea(
      child: Scaffold(
        body: body[0],
        // bottomNavigationBar: BottomNavigationBar(
        //   selectedItemColor: Color(0xff48B5AA),
        //   unselectedItemColor: Color(0x50000000),
        //   currentIndex: index_bottomNavigationBar,
        //   items: [
        //     BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        //     BottomNavigationBarItem(
        //         label: "รายการตรวจ", icon: Icon(Icons.format_list_numbered)),
        //     BottomNavigationBarItem(label: "User", icon: Icon(Icons.person)),
        //     BottomNavigationBarItem(
        //         label: "Settings", icon: Icon(Icons.settings)),
        //   ],
        //   onTap: (index) {
        //     setState(() {
        //       context.read<DataProvider>().id = '';
        //       index_bottomNavigationBar = index;
        //     });
        //     // setState(() {
        //     //   if (index == 2) {
        //     //     Navigator.push(context,
        //     //         MaterialPageRoute(builder: (context) => Login_User()));
        //     //   } else if (index == 0) {
        //     //     Navigator.push(context,
        //     //         MaterialPageRoute(builder: (context) => Setting()));
        //     //   }
        //     // });
        //   },
        // ),
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
                                    onTap: () {
                                      setState(() {
                                        index_bottomNavigationBar = 2;
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             Login_User()));
                                    },
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
                                    )
                                    //  Padding(
                                    //   padding: const EdgeInsets.all(4.0),
                                    //   child: Icon(
                                    //     Icons.logout,
                                    //     color: Color(0xff48B5AA),
                                    //   ),
                                    // ),
                                    ))
                          ],
                        ),
                      )
                    : Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    onTap: () {
                                      setState(() {
                                        index_bottomNavigationBar = 2;
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             Login_User()));
                                    },
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
      icon: widget.pathicon == null
          ? null
          : Container(
              width: _width * 0.8,
              child: Center(
                child: Image.asset(
                  "${widget.pathicon}",
                  width: _width * 0.5,
                  height: _height * 0.2,
                ),
              ),
            ),
      title: widget.texthead == null
          ? null
          : Text(
              "${widget.texthead}",
              style: TextStyle(
                  fontFamily: context.read<DataProvider>().family,
                  fontSize:
                      widget.fontSize == null ? 16 : _width * widget.fontSize),
            ),
      content: widget.textbody == null
          ? null
          : Text(
              "${widget.textbody}",
              style: TextStyle(
                  fontFamily: context.read<DataProvider>().family,
                  fontSize:
                      widget.fontSize == null ? 16 : _width * widget.fontSize),
            ),
      actions: widget.buttonbar == null ? null : widget.buttonbar,
    );
  }
}
