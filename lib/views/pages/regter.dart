import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;

class Regter extends StatefulWidget {
  const Regter({super.key});

  @override
  State<Regter> createState() => _RegterState();
}

class _RegterState extends State<Regter> {
  void regter() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/add_patient');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().regter_id,
      'prefix_name': context.read<DataProvider>().regter_prefix_name,
      'first_name': context.read<DataProvider>().regter_first_name,
      'last_name': context.read<DataProvider>().regter_last_name
    });

    var resTojson2 = json.decode(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ส่งข้อมูลสำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          backgrund(),
          Positioned(
            child: Center(
              child: Container(
                height: _height * 0.5,
                width: _width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'ลงทะเบียน',
                        style: TextStyle(fontSize: _width * 0.08),
                      ),
                      Text(context.read<DataProvider>().regter_id),
                      Text(
                          "${context.read<DataProvider>().regter_prefix_name} ${context.read<DataProvider>().regter_first_name} ${context.read<DataProvider>().regter_last_name}"),
                      GestureDetector(
                          onTap: () {
                            regter();
                          },
                          child: BoxWidetdew(
                              color: Colors.green,
                              height: 0.05,
                              width: 0.2,
                              text: 'สมัค',
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
                              text: 'ออก',
                              radius: 0.0,
                              textcolor: Colors.white)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
