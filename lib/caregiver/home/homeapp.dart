import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/caregiver/home/esm_cardread/cardread_Ble.dart';
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
  Stream<String>? entry;
  var devices;
  StreamSubscription? _functionScan;
  StreamSubscription? _functionReaddata;
  StreamSubscription? cardReader;
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  Timer? _timer;
  Timer? reading;
  int index_bottomNavigationBar = 1;
  void readerID() {
    try {
      Future.delayed(const Duration(seconds: 1), () {
        reader = ESMIDCard.instance;

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
        // const oneSec = Duration(seconds: 1);
        // reading = Timer.periodic(oneSec, (Timer t) => checkCard());
      });
    } on Exception catch (e) {
      print('error');
      print(e.toString());
    }
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

  void bleScan() {
    _functionScan = Stream.periodic(Duration(seconds: 5)).listen((_) {
      print('เเสกน   ');
      FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    });
    FlutterBluePlus.instance.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;

        if (r.device.name.toString() == 'FT_F5F30C4C52DE') {
          print('{เจอdeviceเครื่องอ่านบัตรที่กำหนด}');
          if (r.device.id.toString() == devices['FT_F5F30C4C52DE'].toString()) {
            print("name= ${r.device.name} id= ${r.device.id} กำลัง connect");
            r.device.connect();
            _functionScan!.cancel();
            print('หยุดค้นหา');
            readerID();
          } else {
            print(
                "name= ${r.device.name} id= ${r.device.id} ->ไม่ใช่ที่ต่องการ");
          }
        }
      }
    });
    // _functionReaddata = Stream.periodic(Duration(seconds: 4))
    //     .asyncMap((_) => FlutterBluePlus.instance.connectedDevices)
    //     .listen((connectedDevices) {
    //   connectedDevices.forEach((device) {
    //     if (device.id.toString() == devices['FT_F5F30C4C52DE'].toString()) {
    //       CardRead cardread = CardRead(device: device);
    //       cardread.parse().listen((data) {
    //         print(data);
    //       });
    //     }
    //   });
    // });
  }

  Future<void> connectCreaDreadBLE() async {
    print('กำลังโหลดตรวจสอบDeviceเครื่องอ่านบัตร');

    init = await getdevice();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      devices = record['mapdevices'];
    }
    if (devices['FT_F5F30C4C52DE'] != null) {
      print('กำลังค้นหาเรื่องอ่านบัตร ID ${devices['FT_F5F30C4C52DE']}');
      bleScan();
    } else {
      print('ไม่ได้เพิ่มdeviceเครื่องอ่านบัตร');
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

    // connectCreaDreadBLE();
    // TODO: implement initState
    super.initState();
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
      Setting(),
      Stack(
        children: [
          Positioned(child: BackGrund()),
          Positioned(child: _width > _height ? style_width() : style_height())
        ],
      ),
      Login_User()
    ];
    return SafeArea(
      child: Scaffold(
        body: body[index_bottomNavigationBar],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xff48B5AA),
          currentIndex: index_bottomNavigationBar,
          items: [
            BottomNavigationBarItem(
                label: "Settings", icon: Icon(Icons.settings)),
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(
                  Icons.home,
                )),
            BottomNavigationBarItem(label: "User", icon: Icon(Icons.person)),
          ],
          onTap: (index) {
            setState(() {
              index_bottomNavigationBar = index;
            });
            // setState(() {
            //   if (index == 2) {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Login_User()));
            //   } else if (index == 0) {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Setting()));
            //   }
            // });
          },
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
          Container(child: Numpad()),
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
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                          context.read<DataProvider>().list_patients.length > 0
                              ? list_patients()
                              : Text(
                                  'ไม่มีรายการ',
                                  style: TextStyle(
                                      fontFamily:
                                          context.read<DataProvider>().family),
                                )
                        ]),
                      ),
                    );
                  },
                  child: Container(
                    width: _width * 0.35,
                    height: _height * 0.05,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1)),
                        ],
                        color: Color(0xff31D6AA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.format_list_numbered,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'รายการตรวจ',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: context.read<DataProvider>().family,
                              fontSize: _width * 0.035),
                        )
                      ],
                    ),
                  )),
            ]),
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

  Widget list_patients() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height * 0.5,
      child: ListView.builder(
          itemCount: context.read<DataProvider>().list_patients.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Text(index.toString()),
            );
          }),
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
