import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/Model/view/widgetdew.dart/popup.dart';
import 'package:smart_health/Model/view/widgetdew.dart/widgetdew.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/povider/provider.dart';

class HealthRecord extends StatefulWidget {
  const HealthRecord({super.key});

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {
  Timer? timer;
  bool prevent = false;
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

  void scan() {
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

  void stop() {
    timer?.cancel();
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
              pathicon: 'assets/warning.png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: MarkCheck(
                        pathicon: 'assets/close.png',
                        height: 0.05,
                        width: 0.05)),
                GestureDetector(
                    onTap: () {
                      recorddata();
                      Navigator.pop(context);
                    },
                    child: MarkCheck(
                        pathicon: 'assets/check.png',
                        height: 0.05,
                        width: 0.05)),
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
      // "spo2": "${spo2.text}",
      // "fbs": "${fbs.text}",
    });
    var resTojson = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        if (resTojson['message'] == "success") {
          setState(() {
            prevent = false;
            stop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Popup(
                      texthead: 'สำเร็จ', pathicon: 'assets/correct.png');
                });
            Timer(Duration(seconds: 2), () {
              Navigator.pop(context);
              Navigator.pop(context);
              //  Get.offNamed('menu');
              //    Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => Menu()));
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

  @override
  void initState() {
    clearprovider();
    //  scan();
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

    return Scaffold(
        body: Stack(children: [
      Positioned(
          child: BackGroundSmart_Health(
        BackGroundColor: [StyleColor.backgroundbegin, StyleColor.backgroundend],
      )),
      Positioned(
          child: ListView(children: [
        WidgetNameHospital(),
        BoxDecorate(
            color: Color.fromARGB(255, 43, 179, 161),
            child: InformationCard(
                dataidcard: context.read<DataProvider>().dataidcard)),
        SizedBox(height: heightsizedbox),
        BoxDecorate(
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BoxRecord(texthead: 'TEMP', keyvavlue: temp),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(texthead: 'WEIGHT', keyvavlue: weight)
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
                  style: TextStyle(fontSize: _width * 0.04, color: teamcolor)),
              SizedBox(height: heightsizedbox),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                    chackrecorddata();
                  },
                  child: BoxWidetdew(
                      height: 0.06,
                      width: 0.3,
                      text: 'บันทึก',
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
                  Navigator.pop(context);
                },
                child: BoxWidetdew(
                    height: 0.055,
                    width: 0.25,
                    text: 'กลับ',
                    color: Colors.red,
                    textcolor: Colors.white)))
      ]))
    ]));
  }
}
