import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class SumHealthrecord extends StatefulWidget {
  const SumHealthrecord({super.key});

  @override
  State<SumHealthrecord> createState() => _SumHealthrecordState();
}

class _SumHealthrecordState extends State<SumHealthrecord> {
  TextEditingController sysHealthrecord = TextEditingController();
  TextEditingController diaHealthrecord = TextEditingController();
  TextEditingController pulseHealthrecord = TextEditingController();
  TextEditingController heightHealthrecord = TextEditingController();
  TextEditingController weightHealthrecord = TextEditingController();
  TextEditingController spo2Healthrecord = TextEditingController();

  void sendDataHealthrecord() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/add_hr');
    var res = await http.post(url, body: {
      "public_id": "1710501456572",
      "care_unit_id": "63edead4790f9b775b00004f",
      "temp": " ",
      "weight": "",
      "bp_sys": "",
      "bp_dia": "",
      "pulse_rate": "",
      "spo2": "",
      "fbs": "",
      "height": "",
      "bmi": "",
      "bp": "",
      "rr": "",
      "cc": "",
      "recep_public_id": "",
    });
    var resTojson = json.decode(res.body);
    if (res.statusCode == 200) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    weightHealthrecord.text = context.read<DataProvider>().weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
        height: height,
        width: width,
        child: ListView(children: [
          const Text("รวม"),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/shr.png',
                    texthead: 'HEIGHT',
                    keyvavlue: heightHealthrecord),
                BoxRecord(
                    image: 'assets/srhnate.png',
                    texthead: 'WEIGHT',
                    keyvavlue: weightHealthrecord),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/jhv.png',
                    texthead: 'SYS',
                    keyvavlue: sysHealthrecord),
                BoxRecord(
                    image: 'assets/jhvkb.png',
                    texthead: 'DIA',
                    keyvavlue: diaHealthrecord),
                BoxRecord(
                    image: 'assets/jhbjk;.png',
                    texthead: 'PULSE',
                    keyvavlue: pulseHealthrecord)
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/kauo.png',
                    texthead: 'SPO2',
                    keyvavlue: spo2Healthrecord),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
                onPressed: () {
                  dataProvider.updateviewhealthrecord("spo2");
                },
                child: const Text("ย้อนกลับ")),
            ElevatedButton(
                onPressed: () {
                  sendDataHealthrecord();
                  // dataProvider.updateviewhealthrecord("");
                  // dataProvider.updateViewHome("waiting_for_the_doctor");
                },
                child: const Text("ส่ง"))
          ])
        ]));
  }
}
