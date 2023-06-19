import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/carecever/health_record/device/ad_ua651ble.dart';
import 'package:smart_health/carecever/health_record/device/hc08.dart';
import 'package:smart_health/carecever/health_record/device/hj_narigmed.dart';
import 'package:smart_health/carecever/health_record/device/mibfs.dart';
import 'package:smart_health/carecever/home/homeapp.dart';
import 'package:smart_health/carecever/user_information/user_information.dart';
import 'package:smart_health/carecever/widget/informationCard.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/widgetdew.dart';
import 'package:http/http.dart' as http;

class HealthRecord2 extends StatefulWidget {
  const HealthRecord2({super.key});

  @override
  State<HealthRecord2> createState() => _HealthRecord2State();
}

class _HealthRecord2State extends State<HealthRecord2> {
  TextEditingController temp = TextEditingController();
  TextEditingController weight1 = TextEditingController();
  TextEditingController sys = TextEditingController();
  TextEditingController dia = TextEditingController();
  TextEditingController pulse = TextEditingController();
  TextEditingController pr = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController fbs = TextEditingController();
  TextEditingController si = TextEditingController();
  TextEditingController uric = TextEditingController();
  TextEditingController height = TextEditingController();
  bool prevent = false;
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  List<dynamic>? convertedListdevice;
  List<String> namescan = DataProvider().namescan;
  StreamSubscription? _functionScan;
  StreamSubscription? _functionReaddata;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final Map<String, String> online_devices = HashMap();
  StreamController<Map<String, String>> datas =
      StreamController<Map<String, String>>();
  Timer? timer;
  TextEditingController cc = TextEditingController();
  void restartdata() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        temp.text = context.read<DataProvider>().temp;
        weight1.text = context.read<DataProvider>().weight;
        sys.text = context.read<DataProvider>().sys;
        dia.text = context.read<DataProvider>().dia;
        spo2.text = context.read<DataProvider>().spo2;
        pr.text = context.read<DataProvider>().pr;
        pulse.text = context.read<DataProvider>().pul;
        fbs.text = context.read<DataProvider>().fbs;
        si.text = context.read<DataProvider>().si;
        uric.text = context.read<DataProvider>().uric;
      });
    });
  }
  ////

  void bleScan() {
    _functionScan = Stream.periodic(Duration(seconds: 5)).listen((_) {
      print('เเสกน   ');
      FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    });
    FlutterBluePlus.instance.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;

        if (namescan.contains(r.device.name.toString())) {
          print('{เจอdeviceที่กำหนด}');
          if (convertedListdevice!.contains(r.device.id.toString())) {
            print("name= ${r.device.name} id= ${r.device.id} กำลัง connect");
            r.device.connect();
          } else {
            print(
                "name= ${r.device.name} id= ${r.device.id} ->ไม่ใช่ที่ต่องการ");
          }
        }
      }
    });

    _functionReaddata = Stream.periodic(Duration(seconds: 4))
        .asyncMap((_) => flutterBlue.connectedDevices)
        .listen((connectedDevices) {
      connectedDevices.forEach((device) {
        if (device.name == 'Yuwell HT-YHW' &&
            convertedListdevice!.contains(device.id.toString())) {
          Hc08 hc08 = Hc08(device: device);
          hc08.parse().listen((temp) {
            if (temp != null && temp != '') {
              Map<String, String> val = HashMap();
              val['temp'] = temp;
              datas.add(val);
              setState(() {
                context.read<DataProvider>().temp = temp;
              });
            }
          });
        }
        if (device.name == 'Yuwell BO-YX110-FDC7' &&
            convertedListdevice!.contains(device.id.toString())) {
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          HjNarigmed hjNarigmed = HjNarigmed(device: device);
          hjNarigmed.parse().listen((mVal) {
            Map<String, String> val = HashMap();
            val['spo2'] = mVal['spo2'];
            val['pr'] = mVal['pr'];
            datas.add(val);
            setState(() {
              context.read<DataProvider>().spo2 = mVal['spo2'];
              context.read<DataProvider>().pr = mVal['pr'];
            });
          });
        }
        if (device.name == 'Yuwell BP-YE680A' &&
            convertedListdevice!.contains(device.id.toString())) {
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          AdUa651ble adUa651ble = AdUa651ble(device: device);
          adUa651ble.parse().listen((nVal) {
            Map<String, String> val = HashMap();
            val['sys'] = nVal['sys'];
            val['dia'] = nVal['dia'];
            val['pul'] = nVal['pul'];
            datas.add(val);
            setState(() {
              context.read<DataProvider>().sys = nVal['sys'];
              context.read<DataProvider>().dia = nVal['dia'];
              context.read<DataProvider>().pul = nVal['pul'];
            });
          });
        }
        if (device.name == 'MIBFS' &&
            convertedListdevice!.contains(device.id.toString())) {
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          Mibfs mibfs = Mibfs(device: device);
          mibfs.parse().listen((weight) {
            Map<String, String> val = HashMap();
            val['weight'] = weight;
            datas.add(val);
            setState(() {
              context.read<DataProvider>().weight = weight;
            });
          });
        }
      });
    });
  }

  ////
  Future<void> redipDatabase() async {
    print('กำลังโหลดDevice');
    init = await getdevice();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      context.read<DataProvider>().mapdevices = record['mapdevices'];
    }
    print(context.read<DataProvider>().mapdevices);

    print('โหลดเสร็จเเล้ว');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            convertedListdevice = context
                .read<DataProvider>()
                .mapdevices
                .values
                .toList()
                .map((value) => value.toString())
                .toList(); //เเปลงmapเป็นList string
            print('กำลังหา device ID $convertedListdevice');
            bleScan();
            restartdata();
          });
        });
      });
    });
  }

  @override
  void initState() {
    clearprovider();
    redipDatabase(); //1
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _functionScan!.cancel();
    _functionReaddata!.cancel();
    timer!.cancel();
    super.dispose();
  }

  void clearprovider() {
    setState(() {
      context.read<DataProvider>().temp = '';
      context.read<DataProvider>().weight = '';
      context.read<DataProvider>().sys = '';
      context.read<DataProvider>().dia = '';
      context.read<DataProvider>().spo2 = '';
      context.read<DataProvider>().pr = '';
      context.read<DataProvider>().pul = '';
      context.read<DataProvider>().fbs = '';
      context.read<DataProvider>().si = '';
      context.read<DataProvider>().uric = '';
    });
  }

  void chackrecorddata() async {
    if (temp.text == '' ||
        weight1.text == '' ||
        sys.text == '' ||
        dia.text == '' ||
        spo2.text == '' ||
        pulse == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'ข้อมูลไม่ครบ',
              textbody: 'ต้องการส่งข้อมูลหรือไม่',
              fontSize: 0.05,
              pathicon: 'assets/warning.png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      //    context.read<Datafunction>().playsound();
                      Navigator.pop(context);
                    },
                    child: MarkCheck(
                        pathicon: 'assets/close.png',
                        height: 0.05,
                        width: 0.05)),
                SizedBox(width: 50),
                GestureDetector(
                    onTap: () {
                      recorddata();
                      Navigator.pop(context);
                      //   context.read<Datafunction>().playsound();
                    },
                    child: MarkCheck(
                        pathicon: 'assets/check.png',
                        height: 0.08,
                        width: 0.08)),
                SizedBox(width: 50),
              ],
            );
          });
    } else {
      print('value!=null');
      recorddata();
    }
  }

  void recorddata() async {
    setState(() {
      prevent = true;
    });
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/add_hr');
    var res = await http.post(url, body: {
      "public_id": context.read<DataProvider>().id,
      "care_unit_id": context.read<DataProvider>().care_unit_id,
      "temp": "${temp.text}",
      "weight": "${weight1.text}",
      "bp_sys": "${sys.text}",
      "bp_dia": "${dia.text}",
      "pulse_rate": "${pulse.text}",
      "spo2": "${spo2.text}",
      "fbs": "${fbs.text}",
      "height": "${height.text}",
      "bmi": "",
      "bp": "${sys.text}/${dia.text}",
      "rr": "",
      "cc": "${cc.text}",
    });
    var resTojson = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        if (resTojson['message'] == "success") {
          setState(() {
            prevent = false;

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Popup(
                      fontSize: 0.05,
                      texthead: 'สำเร็จ',
                      pathicon: 'assets/correct.png');
                });
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
              Navigator.pop(context);
            });

            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => User_Information()));
          });
        } else {
          setState(() {
            prevent = false;
            setState(() {
              prevent = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Popup(
                        texthead: 'ไม่สำเร็จ',
                        textbody: 'message unsuccessful',
                        pathicon: 'assets/warning (1).png');
                  });
            });
          });
        }
      });
    } else {
      setState(() {
        prevent = false;
        setState(() {
          prevent = false;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Popup(
                    texthead: 'ไม่สำเร็จ',
                    textbody: 'statusCode 404',
                    pathicon: 'assets/warning (1).png');
              });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double heightsizedbox = _height * 0.02;
    double heightline = _height * 0.03;
    Color teamcolor = Color.fromARGB(255, 47, 174, 164);
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          backgrund(),
          Positioned(
              child: ListView(children: [
            Container(height: _height * 0.05),
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
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  BoxRecord(
                      image: 'assets/shr.png',
                      texthead: 'HEIGHT',
                      keyvavlue: height),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/srhnate.png',
                      texthead: 'WEIGHT',
                      keyvavlue: weight1),
                ])),
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  BoxRecord(
                      image: 'assets/jhv.png', texthead: 'SYS', keyvavlue: sys),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/jhvkb.png',
                      texthead: 'DIA',
                      keyvavlue: dia),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/jhbjk;.png',
                      texthead: 'PULSE',
                      keyvavlue: pulse)
                ])),
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  BoxRecord(
                      image: 'assets/jhgh.png',
                      texthead: 'TEMP',
                      keyvavlue: temp),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/kauo.png',
                      texthead: 'SPO2',
                      keyvavlue: spo2),
                ])),
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
              child: Center(
                child: TextField(
                  cursorColor: Color(0xff48B5AA),
                  keyboardType: TextInputType.multiline,
                  maxLines: max(4, 4),
                  maxLength: 200,
                  textInputAction: TextInputAction.go,
                  controller: cc,
                  style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    color: Color(0xff48B5AA),
                    fontSize: _height * 0.02,
                  ),
                  decoration: InputDecoration(
                    labelText: 'รายระเอียดเพิ่มเติม',

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff48B5AA),
                      ),
                    ),
                    //   border: InputBorder.none, //เส้นไต้
                  ),
                ),
              ),
            ),
            SizedBox(height: _height * 0.01),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: prevent == false
                        ? GestureDetector(
                            onTap: () {
                              //    context.read<Datafunction>().playsound();

                              chackrecorddata();
                            },
                            child: BoxWidetdew(
                                height: 0.06,
                                width: 0.35,
                                text: 'บันทึก',
                                fontSize: 0.05,
                                radius: 15.0,
                                color: Color(0xff31D6AA),
                                textcolor: Colors.white),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.07,
                            height: MediaQuery.of(context).size.width * 0.07,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _height * 0.05),
          ])),
        ]),
      ),
    );
  }
}

class BoxDecorate2 extends StatefulWidget {
  BoxDecorate2({super.key, this.child, this.color});
  var child;
  var color;
  @override
  State<BoxDecorate2> createState() => _BoxDecorate2State();
}

class _BoxDecorate2State extends State<BoxDecorate2> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return widget.child == null
        ? Container()
        : Container(
            width: _width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    //   width: _width * 0.8,
                    width: _width * 0.9,
                    height: _height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1.5,
                            color: Color(0xff48B5AA),
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Center(
                      child: widget.child,
                    )),
              ],
            ),
          );
  }
}
