import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/device/ad_ua651ble.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/device/hj_narigmed.dart';
import 'package:smart_health/device/mibfs.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class HealthRecord extends StatefulWidget {
  const HealthRecord({super.key});

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {
  Timer? timer;
  bool prevent = false;
  bool ble = true;

  StreamSubscription? _streamSubscription;
  StreamSubscription? _functionSubscription;
  TextEditingController temp = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController sys = TextEditingController();
  TextEditingController dia = TextEditingController();
  TextEditingController pulse = TextEditingController();
  TextEditingController pr = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController fbs = TextEditingController();
  TextEditingController si = TextEditingController();
  TextEditingController uric = TextEditingController();
  TextEditingController height = TextEditingController();
  void restartdata() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        temp.text = context.read<DataProvider>().temp;
        weight.text = context.read<DataProvider>().weight;
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

  @override
  void dispose() {
    _streamSubscription
        ?.cancel(); // แนะนำเรียก cancel() ใน dispose() เพื่อป้องกัน memory leak
    super.dispose();
  }

  void stop() {
    setState(() {
      timer?.cancel();
      _streamSubscription?.cancel();
      _functionSubscription?.cancel();
      Get.offNamed('user_information');
    });
    ; // ยกเลิก StreamSubscription ถ้ามีการติดตาม Stream อยู่
  }

  void stop2() {
    setState(() {
      timer?.cancel();
      _streamSubscription?.cancel();
      _functionSubscription?.cancel();
    });
    ; // ยกเลิก StreamSubscription ถ้ามีการติดตาม Stream อยู่
  }

  void chackrecorddata() async {
    if (temp.text == '' ||
        weight.text == '' ||
        sys.text == '' ||
        dia.text == '' ||
        spo2.text == '' ||
        pr.text == '' ||
        pulse == '' ||
        fbs.text == '' ||
        si.text == '' ||
        uric.text == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'ข้อมูลไม่ครบ',
              textbody: 'ต่องการส่งข้อมูลหรือไม่',
              fontSize: 0.05,
              pathicon: 'assets/warning.png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      context.read<Datafunction>().playsound();
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

                      stop();
                      context.read<Datafunction>().playsound();
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
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}add_hr');
    var res = await http.post(url, body: {
      "public_id": context.read<DataProvider>().id,
      "care_unit_id": context.read<DataProvider>().care_unit_id,
      "temp": "${temp.text}",
      "weight": "${weight.text}",
      "bp_sys": "${sys.text}",
      "bp_dia": "${dia.text}",
      "pulse_rate": "${pulse.text}",
      "spo2": "${spo2.text}",
      "fbs": "${fbs.text}",
      "height": "160",
      "bmi": "122",
      "bp": "${sys.text}/${dia.text}",
      "rr": "90",
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
            Timer(Duration(seconds: 1), () {
              Navigator.pop(context);
              Timer(Duration(seconds: 1), () {
                stop();
              });
            });
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

  void bleScan() {
    var namescan;

    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
    final Map<String, String> online_devices = HashMap();
    namescan = DataProvider().namescan;
    StreamController<Map<String, String>> datas =
        StreamController<Map<String, String>>();
    FlutterBluePlus.instance.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;

        if (namescan.contains(r.device.name.toString())) {
          r.device.connect();
        }
      } else {}
    });

    _streamSubscription = Stream.periodic(Duration(seconds: 5)).listen((_) {
      FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
      FlutterBluePlus.instance.scanResults.listen((results) {
        print('streamtimeกำลังทำงาน');
        if (results.length > 0) {
          ScanResult r = results.last;

          if (namescan.contains(r.device.id.toString())) {
            r.device.connect();
          }
        }
      });
    });

    _functionSubscription = Stream.periodic(Duration(seconds: 4))
        .asyncMap((_) => flutterBlue.connectedDevices)
        .listen((connectedDevices) {
      connectedDevices.forEach((device) {
        print('functionstreamtimeกำลังทำงาน');
        if (online_devices.containsKey(device.id.toString()) == false) {
          online_devices[device.id.toString()] = device.name;
          if (device.name == 'HC-08') {
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
          } else if (device.name == 'HJ-Narigmed') {
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
          } else if (device.name == 'A&D_UA-651BLE_D57B3F') {
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
          } else if (device.name == 'MIBFS') {
            Mibfs mibfs = Mibfs(device: device);
            mibfs.parse().listen((weight) {
              Map<String, String> val = HashMap();
              val['weight'] = weight;
              setState(() {
                context.read<DataProvider>().weight = weight;
              });
            });
          }
        }
      });
    });
  }

  // Timer scanTimer([int milliseconds = 6]) =>
  //     Timer.periodic(Duration(seconds: milliseconds), (Timer timer) {
  //       FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 5));
  //     });
  @override
  void initState() {
    clearprovider();
    restartdata();
    //   scanTimer();
    bleScan();
    // TODO: implement initState
    super.initState();
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
          WidgetNameHospital(),
          Container(
            height: _height * 0.01,
          ),
          BoxDecorate(
              color: Color.fromARGB(255, 43, 179, 161),
              child: InformationCard(
                  dataidcard: context.read<DataProvider>().dataidcard)),
          SizedBox(height: heightsizedbox),
          // Container(
          //   width: _width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       SizedBox(width: _width * 0.2),
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             if (ble == true) {
          //               ble = false;
          //               stop2();
          //             } else {
          //               ble = true;
          //               restartdata();
          //             }
          //           });
          //         },
          //         child: Container(
          //           width: _width * 0.2,
          //           height: _height * 0.04,
          //           child: ble == true
          //               ? Icon(Icons.abc,
          //                   color: Colors.green, size: _width * 0.12)
          //               : Icon(Icons.abc,
          //                   color: Colors.black, size: _width * 0.12),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(height: heightsizedbox),
          BoxDecorate(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxRecord(texthead: 'TEMP', keyvavlue: temp),
                    Line(height: heightline, color: teamcolor),
                    BoxRecord(texthead: 'WEIGHT', keyvavlue: weight),
                    Line(height: heightline, color: teamcolor),
                    BoxRecord(texthead: 'height', keyvavlue: height)
                  ])),
          SizedBox(height: heightsizedbox),
          BoxDecorate(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxRecord(texthead: 'SYS', keyvavlue: sys),
                    Line(height: heightline, color: teamcolor),
                    BoxRecord(texthead: 'DIA', keyvavlue: dia),
                    Line(height: heightline, color: teamcolor),
                    BoxRecord(texthead: 'PULSE', keyvavlue: pulse)
                  ])),
          SizedBox(height: heightsizedbox),
          BoxDecorate(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxRecord(texthead: 'PR', keyvavlue: pr),
                    Line(height: heightline, color: teamcolor),
                    BoxRecord(texthead: 'SPO2', keyvavlue: spo2),
                  ])),
          SizedBox(height: heightsizedbox),
          BoxDecorate(
            color: Colors.white,
            child: Column(
              children: [
                Text('ค่าน้ำตาล',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: _width * 0.04,
                        color: teamcolor)),
                SizedBox(height: heightsizedbox),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BoxRecord(texthead: 'FBS', keyvavlue: fbs),
                      Line(height: heightline, color: teamcolor),
                      BoxRecord(texthead: 'SI', keyvavlue: si),
                      Line(height: heightline, color: teamcolor),
                      BoxRecord(texthead: 'URIC', keyvavlue: uric)
                    ]),
              ],
            ),
          ),
          SizedBox(height: heightsizedbox),
          Center(
            child: prevent == false
                ? GestureDetector(
                    onTap: () {
                      context.read<Datafunction>().playsound();

                      chackrecorddata();
                    },
                    child: BoxWidetdew(
                        height: 0.06,
                        width: 0.3,
                        text: 'บันทึก',
                        fontSize: 0.05,
                        color: teamcolor,
                        textcolor: Colors.white),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.width * 0.07,
                    child: CircularProgressIndicator(),
                  ),
          ),
          SizedBox(height: _height * 0.01),
          Center(
              child: GestureDetector(
                  onTap: () {
                    stop();
                    context.read<Datafunction>().playsound();

                    //  Navigator.pop(context);
                  },
                  child: BoxWidetdew(
                      height: 0.055,
                      width: 0.25,
                      fontSize: 0.05,
                      text: 'กลับ',
                      color: Colors.red,
                      textcolor: Colors.white)))
        ]))
      ])),
    );
  }
}
