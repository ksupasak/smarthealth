import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/caregiver/widget/boxtime.dart';
import 'package:smart_health/myapp/action/playsound.dart';
import 'package:smart_health/myapp/action/vibrateDevice.dart';
import 'package:smart_health/myapp/setting/device/ad_ua651ble.dart';
import 'package:smart_health/myapp/setting/device/hc08.dart';
import 'package:smart_health/myapp/setting/device/hj_narigmed.dart';

import 'package:smart_health/myapp/setting/device/mibfs.dart';
import 'package:smart_health/caregiver/home/homeapp.dart';
import 'package:smart_health/caregiver/widget/informationCard.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/device/yuwell%20_glucose.dart';
import 'package:smart_health/myapp/setting/device/yuwell_bo_yx110_fdg7.dart';
import 'package:smart_health/myapp/setting/device/yuwell_bp_ye680a.dart';
import 'package:smart_health/myapp/setting/device/yuwell_ht_yhw.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/widgetdew.dart';
import 'package:http/http.dart' as http;

// import 'package:image_picker/image_picker.dart';

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
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked21 = false;
  bool _isChecked22 = false;
  bool _isChecked23 = false;

  bool mibfs = false;
  bool yuwell_HT_YHW = false;
  bool yuwell_BP_YE680A = false;
  bool yuwell_BO_YX110_FDC7 = false;
  bool hJ_Narigmed = false;
  bool hC_08 = false;
  bool aD_UA_651BLE_D57B3F = false;
  bool yuwell_Glucose = false;

  void restartdata() {
    String temp_value = '';
    String weight_value = '';
    String sys_value = '';
    String dia_value = '';
    String spo2_value = '';
    String pr_value = '';
    String pulse_value = '';
    String fbs_value = '';
    String si_value = '';
    String uric_value = '';

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        if (temp_value != context.read<DataProvider>().temp) {
          temp.text = context.read<DataProvider>().temp;
          temp_value = context.read<DataProvider>().temp;
          playsound();
          vibrateDevice();
        }
        if (weight_value != context.read<DataProvider>().weight) {
          weight1.text = context.read<DataProvider>().weight;
          weight_value = context.read<DataProvider>().weight;
          playsound();
          vibrateDevice();
        }
        if (sys_value != context.read<DataProvider>().sys) {
          sys.text = context.read<DataProvider>().sys;
          sys_value = context.read<DataProvider>().sys;
          playsound();
          vibrateDevice();
        }
        if (dia_value != context.read<DataProvider>().dia) {
          dia.text = context.read<DataProvider>().dia;
          dia_value = context.read<DataProvider>().dia;
          playsound();
          vibrateDevice();
        }
        if (spo2_value != context.read<DataProvider>().spo2) {
          spo2.text = context.read<DataProvider>().spo2;
          spo2_value = context.read<DataProvider>().spo2;
          playsound();
          vibrateDevice();
        }
        if (pr_value != context.read<DataProvider>().pr) {
          pr.text = context.read<DataProvider>().pr;
          pr_value = context.read<DataProvider>().pr;
          playsound();
          vibrateDevice();
        }
        if (pulse_value != context.read<DataProvider>().pul) {
          pulse.text = context.read<DataProvider>().pul;
          pulse_value = context.read<DataProvider>().pul;
          playsound();
          vibrateDevice();
        }
        if (fbs_value != context.read<DataProvider>().fbs) {
          fbs.text = context.read<DataProvider>().fbs;
          fbs_value = context.read<DataProvider>().fbs;
          playsound();
          vibrateDevice();
        }
        if (si_value != context.read<DataProvider>().si) {
          si.text = context.read<DataProvider>().si;
          si_value = context.read<DataProvider>().si;
          playsound();
          vibrateDevice();
        }
        if (uric_value != context.read<DataProvider>().uric) {
          uric.text = context.read<DataProvider>().uric;
          uric_value = context.read<DataProvider>().uric;
          playsound();
          vibrateDevice();
        }
      });
    });
  }

  void bleScan() {
    _functionScan = Stream.periodic(Duration(seconds: 5)).listen((_) {
      print('สเเกน   ');
      FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    });
    FlutterBluePlus.instance.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;
        // print(r.device.name);
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
        if (device.name == 'Yuwell Glucose' &&
            convertedListdevice!.contains(device.id.toString())) {
          if (yuwell_Glucose == false) {
            setState(() {
              yuwell_Glucose = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ Yuwell Glucose',
                    )))));
          }
          print('อ่านค่าน้ำตาล');
          Yuwell_Glucose glucose = Yuwell_Glucose(device: device);
          glucose.parse().listen((glucoses) {
            if (glucoses != null && glucoses != '') {
              Map<String, String> val = HashMap();
              val['glucose'] = glucoses;
              datas.add(val);
              setState(() {
                context.read<DataProvider>().fbs = glucoses;
              });
            }
          });
        }
        if (device.name == 'HC-08' &&
            convertedListdevice!.contains(device.id.toString())) {
          if (hC_08 == false) {
            setState(() {
              hC_08 = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ HC-08',
                    )))));
          }
          Hc08 ht = Hc08(device: device);
          ht.parse().listen((temp) {
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
        if (device.name == 'HJ-Narigmed' &&
            convertedListdevice!.contains(device.id.toString())) {
          if (hJ_Narigmed == false) {
            setState(() {
              hJ_Narigmed = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ HJ-Narigmed',
                    )))));
          }
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          HjNarigmed spo2 = HjNarigmed(device: device);
          spo2.parse().listen((mVal) {
            Map<String, String> val = HashMap();
            val['spo2'] = mVal['spo2'];
            val['pr'] = mVal['pr'];
            datas.add(val);
            setState(() {
              context.read<DataProvider>().spo2 = mVal['spo2'];
              context.read<DataProvider>().pul = mVal['pr'];
            });
          });
        }
        if (device.name == 'A&D_UA-651BLE_D57B3F' &&
            convertedListdevice!.contains(device.id.toString())) {
          if (aD_UA_651BLE_D57B3F == false) {
            setState(() {
              aD_UA_651BLE_D57B3F = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ A&D_UA-651BLE_D57B3F',
                    )))));
          }
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          AdUa651ble bp = AdUa651ble(device: device);
          bp.parse().listen((nVal) {
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
        if (device.name == 'Yuwell HT-YHW' &&
            convertedListdevice!.contains(device.id.toString())) {
          if (yuwell_HT_YHW == false) {
            setState(() {
              yuwell_HT_YHW = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ Yuwell HT-YHW',
                    )))));
          }
          Yuwell_HT_YHW ht = Yuwell_HT_YHW(device: device);
          ht.parse().listen((temp) {
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
          if (yuwell_BO_YX110_FDC7 == false) {
            setState(() {
              yuwell_BO_YX110_FDC7 = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ Yuwell BO-YX110-FDC7',
                    )))));
          }
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          Yuwell_BO_YX110_FDC7 spo2 = Yuwell_BO_YX110_FDC7(device: device);
          spo2.parse().listen((mVal) {
            Map<String, String> val = HashMap();
            val['spo2'] = mVal['spo2'];
            val['pr'] = mVal['pr'];
            datas.add(val);
            setState(() {
              context.read<DataProvider>().spo2 = mVal['spo2'];
              //    context.read<DataProvider>().pr = mVal['pr'];
              context.read<DataProvider>().pul = mVal['pr'];
            });
          });
        }
        if (device.name == 'Yuwell BP-YE680A' &&
            convertedListdevice!.contains(device.id.toString())) {
          if (yuwell_BP_YE680A == false) {
            setState(() {
              yuwell_BP_YE680A = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ Yuwell BP-YE680A',
                    )))));
          }
          print('functionstreamtimeกำลังทำงาน ${device.name}');
          Yuwell_BP_YE680A bp = Yuwell_BP_YE680A(device: device);
          bp.parse().listen((nVal) {
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
          if (mibfs == false) {
            setState(() {
              mibfs = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'พบ MIBFS ',
                    )))));
          }
          Mibfs w = Mibfs(device: device);
          w.parse().listen((weight) {
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
      "recep_public_id": context.read<DataProvider>().user_id,
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
    TextStyle textStyle = TextStyle(
      fontFamily: context.read<DataProvider>().family,
      fontSize: _width * 0.03,
      color: Color.fromARGB(255, 35, 131, 123),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      body: Stack(children: [
        backgrund(),
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
                  image: 'assets/jhv.png',
                  texthead: 'SYS',
                  keyvavlue: sys,
                  colorboxShadow: double.tryParse("0${sys.text}")! == 0
                      ? Colors.white
                      : double.tryParse("0${sys.text}")! < 89
                          ? Color.fromARGB(255, 218, 15, 0)
                          : double.tryParse("0${sys.text}")! < 99
                              ? Color.fromARGB(255, 253, 159, 105)
                              : double.tryParse("0${sys.text}")! < 199
                                  ? Color.fromARGB(255, 58, 253, 133)
                                  : double.tryParse("0${sys.text}")! > 199
                                      ? Colors.white
                                      : Colors.white,
                ),
                Line(height: heightline, color: teamcolor),
                BoxRecord(
                  image: 'assets/jhvkb.png',
                  texthead: 'DIA',
                  keyvavlue: dia,
                  colorboxShadow: double.tryParse("0${sys.text}")! == 0
                      ? Colors.white
                      : double.tryParse("0${dia.text}")! < 39
                          ? Color.fromARGB(255, 218, 15, 0)
                          : double.tryParse("0${dia.text}")! < 49
                              ? Color.fromARGB(255, 253, 159, 105)
                              : double.tryParse("0${dia.text}")! < 99
                                  ? Color.fromARGB(255, 58, 253, 133)
                                  : double.tryParse("0${dia.text}")! < 109
                                      ? Color.fromARGB(255, 253, 159, 105)
                                      : double.tryParse("0${dia.text}")! < 129
                                          ? Color.fromARGB(255, 252, 79, 79)
                                          : double.tryParse("0${dia.text}")! >
                                                  129
                                              ? Color.fromARGB(255, 218, 15, 0)
                                              : Colors.brown,
                ),
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
                    keyvavlue: temp,
                    colorboxShadow: double.tryParse("0${temp.text}")! == 0
                        ? Colors.white
                        : double.tryParse("0${temp.text}")! < 33.9
                            ? Color.fromARGB(255, 102, 186, 255)
                            : double.tryParse("0${temp.text}")! < 34.9
                                ? Color.fromARGB(255, 150, 208, 255)
                                : double.tryParse("0${temp.text}")! < 35.9
                                    ? Color.fromARGB(255, 137, 255, 182)
                                    : double.tryParse("0${temp.text}")! < 37.9
                                        ? Color.fromARGB(255, 58, 253, 133)
                                        : double.tryParse("0${temp.text}")! <
                                                38.9
                                            ? Color.fromARGB(255, 253, 159, 105)
                                            : double.tryParse(
                                                        "0${temp.text}")! <
                                                    39.9
                                                ? Color.fromARGB(
                                                    255, 252, 79, 79)
                                                : double
                                                            .tryParse(
                                                                "0${temp.text}")! >
                                                        39.9
                                                    ? Color.fromARGB(
                                                        255, 218, 15, 0)
                                                    : Colors.brown),
                Line(height: heightline, color: teamcolor),
                BoxRecord(
                  image: 'assets/kauo.png',
                  texthead: 'SPO2',
                  keyvavlue: spo2,
                  colorboxShadow: double.tryParse("0${spo2.text}")! == 0
                      ? Colors.white
                      : double.tryParse("0${spo2.text}")! < 84
                          ? Color.fromARGB(255, 218, 15, 0)
                          : double.tryParse("0${spo2.text}")! < 89
                              ? Color.fromARGB(255, 252, 79, 79)
                              : double.tryParse("0${spo2.text}")! < 92
                                  ? Color.fromARGB(255, 253, 159, 105)
                                  : double.tryParse("0${spo2.text}")! > 92
                                      ? Color.fromARGB(255, 58, 253, 133)
                                      : Colors.brown,
                ),
              ])),
          SizedBox(height: heightsizedbox),
          BoxDecorate2(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BoxRecord(
                  texthead: 'BloodGlucose',
                  keyvavlue: fbs,
                  image: 'assets/Frame 9184.png',
                  colorboxShadow: double.tryParse("0${fbs.text}")! == 0
                      ? Colors.white
                      : double.tryParse("0${fbs.text}")! < 130
                          ? Color.fromARGB(255, 58, 253, 133)
                          : Colors.red,
                ),
                Line(height: heightline, color: teamcolor),
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Row(
                          children: [
                            Text('ก่อนอาหาร', style: textStyle),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_isChecked1) {
                                      _isChecked1 = false;
                                    } else {
                                      _isChecked1 = true;
                                      _isChecked2 = false;
                                    }
                                  });
                                },
                                child: Container(
                                  width: _width * 0.05,
                                  height: _width * 0.05,
                                  decoration: BoxDecoration(
                                      color: _isChecked1
                                          ? Colors.green
                                          : Color.fromARGB(255, 216, 216, 216),
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                              ),
                            )
                          ],
                        )),
                        Container(
                            child: Row(
                          children: [
                            Text('หลังอาหาร', style: textStyle),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_isChecked2) {
                                      _isChecked2 = false;
                                    } else {
                                      _isChecked1 = false;
                                      _isChecked2 = true;
                                    }
                                  });
                                },
                                child: Container(
                                  width: _width * 0.05,
                                  height: _width * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: _isChecked2
                                        ? Colors.green
                                        : Color.fromARGB(255, 216, 216, 216),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                      ]),
                ),
                Line(height: heightline, color: teamcolor),
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('เช้า', style: textStyle),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_isChecked21) {
                                        _isChecked21 = false;
                                      } else {
                                        _isChecked21 = true;
                                        _isChecked22 = false;
                                        _isChecked23 = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: _width * 0.05,
                                    height: _width * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: _isChecked21
                                          ? Colors.green
                                          : Color.fromARGB(255, 216, 216, 216),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text('กลางวัน', style: textStyle),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_isChecked22) {
                                        _isChecked22 = false;
                                      } else {
                                        _isChecked21 = false;
                                        _isChecked22 = true;
                                        _isChecked23 = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: _width * 0.05,
                                    height: _width * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: _isChecked22
                                          ? Colors.green
                                          : Color.fromARGB(255, 216, 216, 216),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text('เย็น', style: textStyle),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_isChecked23) {
                                        _isChecked23 = false;
                                      } else {
                                        _isChecked21 = false;
                                        _isChecked22 = false;
                                        _isChecked23 = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: _width * 0.05,
                                    height: _width * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: _isChecked23
                                          ? Colors.green
                                          : Color.fromARGB(255, 216, 216, 216),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
          // SizedBox(height: heightsizedbox),
          // BoxDecorate2(child: ListImage()),
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

class BoxRecord extends StatefulWidget {
  BoxRecord({
    super.key,
    this.keyvavlue,
    this.texthead,
    this.icon,
    this.image,
    this.colorboxShadow,
  });
  var keyvavlue;
  var texthead;
  var image;
  Widget? icon;
  Color? colorboxShadow;
  @override
  State<BoxRecord> createState() => _BoxRecordState();
}

class _BoxRecordState extends State<BoxRecord> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Color teamcolor = Color.fromARGB(255, 35, 131, 123);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: _width * 0.2,
        decoration: BoxDecoration(boxShadow: [
          // BoxShadow(
          //     blurRadius: 10,
          //     spreadRadius: 0,
          //     color: widget.colorboxShadow ?? Colors.white)
        ], borderRadius: BorderRadius.circular(50)),
        child: Column(
          children: [
            widget.texthead == null
                ? Text('')
                : Row(
                    children: [
                      widget.image != null
                          ? Container(
                              width: _width * 0.05,
                              child: Image.asset(widget.image))
                          : SizedBox(),
                      Container(
                        width: _width * 0.15,
                        child: Text('${widget.texthead}',
                            style: TextStyle(
                              fontFamily: context.read<DataProvider>().family,
                              fontSize: _width * 0.03,
                              color: teamcolor,
                            )),
                      ),
                    ],
                  ),
            TextField(
              //  autofocus: false,//ปิดแป้นพิม
              cursorColor: teamcolor,
              onChanged: (value) {
                if (value.length > 0) {}
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: teamcolor,
                  ),
                ),
                //   border: InputBorder.none, //เส้นไต้
              ),
              style: TextStyle(
                  fontFamily: context.read<DataProvider>().family,
                  color: widget.colorboxShadow ?? teamcolor,
                  fontSize: _height * 0.03,
                  shadows: [
                    Shadow(
                        color: Color.fromARGB(255, 104, 104, 104),
                        offset: Offset(1, 1),
                        blurRadius: 1.0)
                  ]),
              controller: widget.keyvavlue,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
