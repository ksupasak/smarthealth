import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  void sendDataHealthrecord() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/add_hr');
    var res = await http.post(url, body: {
      "public_id": context.read<DataProvider>().id,
      "care_unit_id": context.read<DataProvider>().care_unit_id,
      "temp": context.read<DataProvider>().tempHealthrecord.text,
      "weight": context.read<DataProvider>().weightHealthrecord.text,
      "bp_sys": context.read<DataProvider>().sysHealthrecord.text,
      "bp_dia": context.read<DataProvider>().diaHealthrecord.text,
      "pulse_rate": context.read<DataProvider>().pulseHealthrecord.text,
      "spo2": context.read<DataProvider>().spo2Healthrecord.text,
      "fbs": "",
      "height": context.read<DataProvider>().heightHealthrecord.text,
      "bmi": "",
      "bp":
          "${context.read<DataProvider>().sysHealthrecord.text}/${context.read<DataProvider>().diaHealthrecord.text}",
      "rr": "",
      "cc": "",
      "recep_public_id": "",
    });
    var resTojson = json.decode(res.body);
    if (res.statusCode == 200) {
      debugPrint("ส่งค่าHealthrecord สำเร็จ");
      debugPrint(resTojson.toString());
      Get.offNamed('user_information');
    }
  }

  Future<void> send() async {
    var url = Uri.parse('http://localhost:8189/api/smartcard/confirm-save');
    var res = await http.post(url, body: {
      "pid": context.read<DataProvider>().id,
      "claimType": context.read<DataProvider>().claimType,
      "mobile": "",
      "correlationId": context.read<DataProvider>().correlationId,
      "hn": ""
    });
    var resTojson = json.decode(res.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
        height: height * 0.7,
        width: width,
        child: ListView(children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/shr.png',
                    texthead: 'HEIGHT',
                    keyvavlue: context.read<DataProvider>().heightHealthrecord),
                BoxRecord(
                    image: 'assets/srhnate.png',
                    texthead: 'WEIGHT',
                    keyvavlue: context.read<DataProvider>().weightHealthrecord),
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
                    keyvavlue: context.read<DataProvider>().sysHealthrecord),
                BoxRecord(
                    image: 'assets/jhvkb.png',
                    texthead: 'DIA',
                    keyvavlue: context.read<DataProvider>().diaHealthrecord),
                BoxRecord(
                    image: 'assets/jhbjk;.png',
                    texthead: 'PULSE',
                    keyvavlue: context.read<DataProvider>().pulseHealthrecord)
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
                    keyvavlue: context.read<DataProvider>().spo2Healthrecord),
                BoxRecord(
                    image: 'assets/jhgh.png',
                    texthead: 'TEMP',
                    keyvavlue: context.read<DataProvider>().tempHealthrecord),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        dataProvider.updateviewhealthrecord("spo2");
                      },
                      child: Text(
                        "ย้อนกลับ",
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        sendDataHealthrecord();
                        // dataProvider.updateviewhealthrecord("");
                        // dataProvider.updateViewHome("waiting_for_the_doctor");
                      },
                      child: Text(
                        "ส่ง",
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      ))
                ]),
          )
        ]));
  }
}
