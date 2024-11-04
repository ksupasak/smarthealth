// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;

class Regter extends StatefulWidget {
  const Regter({super.key});

  @override
  State<Regter> createState() => _RegterState();
}

class _RegterState extends State<Regter> {
  TextEditingController prefix_name = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController hn = TextEditingController();
  @override
  void initState() {
    setvalue();

    super.initState();
  }

  // Future<void> getImage() async {
  //   var url = Uri.parse('http://localhost:8189/api/smartcard/read-cead-only');
  //   var res = await http.post(url);
  //   var resTojson2 = json.decode(res.body);
  // }

  void setvalue() {
    debugPrint(context.read<DataProvider>().dataUserIDCard.toString());
    if (context.read<DataProvider>().dataUserIDCard != null) {
      setState(() {
        id.text = context.read<DataProvider>().dataUserIDCard["pid"];
        prefix_name.text =
            context.read<DataProvider>().dataUserIDCard["titleName"];
        first_name.text = context.read<DataProvider>().dataUserIDCard["fname"];
        last_name.text = context.read<DataProvider>().dataUserIDCard["lname"];
      });
    } else {
      setState(() {
        id.text = '--';
        prefix_name.text = '--';
        first_name.text = '--';
        last_name.text = '--';
      });
    }
  }

  void regter() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/add_patient');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': id.text,
      'prefix_name': "",
      'first_name': first_name.text,
      'last_name': last_name.text,
      'hn': hn.text
    });

    var resTojson2 = json.decode(res.body);
    debugPrint(resTojson2.toString());
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
      Get.offNamed('home');
    }
  }

  Widget BoxData({String? child}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width * 0.4,
        height: height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0))),
        child: child != null
            ? Text(child,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 28, 155),
                  fontFamily: context.read<DataProvider>().fontFamily,
                ))
            : const Text('-'));
  }

  Widget Boxheab({required String child}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width * 0.4,
        height: height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0))),
        child: Text(child,
            style: TextStyle(
              color: const Color.fromARGB(255, 3, 58, 58),
              fontFamily: context.read<DataProvider>().fontFamily,
            )));
  }

  Widget textdatauser({TextEditingController? child}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.04,
        color: Color(0xff003D5C));
    return Container(
      child: Row(
        children: [
          SizedBox(width: _width * 0.05),
          Container(
            width: _width * 0.65,
            height: _height * 0.04,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(controller: child, style: style2),
            ),
            decoration: boxDecorate,
          )
        ],
      ),
    );
  }

  Decoration boxDecorate = BoxDecoration(boxShadow: [
    BoxShadow(offset: Offset(0, 2.5), blurRadius: 3, color: Color(0xff31D6AA))
  ], borderRadius: BorderRadius.circular(10), color: Colors.white);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle textStyle = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.06,
        color: Color(0xff31D6AA));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.04,
        color: Color(0xff003D5C));
    return Scaffold(
      body: Stack(
        children: [
          backgrund(),
          Positioned(
            child: Center(
              child: ListView(
                children: [
                  BoxTime(),
                  Container(
                    child: Center(
                      child: Container(
                        width: _width * 0.85,
                        height: _height * 0.6,
                        decoration: boxDecorate,
                        child: Column(
                          children: [
                            Text('ลงทะเบียน', style: textStyle),
                            Container(
                              width: _width * 0.8,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('คำนำหน้าชื่อ', style: style2),
                                    textdatauser(child: prefix_name),
                                    Text('ชื่อ', style: style2),
                                    textdatauser(child: first_name),
                                    Text('นามสกุล', style: style2),
                                    textdatauser(child: last_name),
                                    Text('เลขประจำตัวประชาชน', style: style2),
                                    textdatauser(child: id),
                                    Text('รหัส HN', style: style2),
                                    textdatauser(child: hn),
                                  ]),
                            ),
                            SizedBox(height: _height * 0.01),
                            GestureDetector(
                              onTap: regter,
                              child: Container(
                                width: _width * 0.35,
                                height: _height * 0.06,
                                decoration: BoxDecoration(
                                    color: Color(0xff31D6AA),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 2),
                                          blurRadius: 2)
                                    ]),
                                child: Row(
                                  children: [
                                    Image.asset('assets/rsjyrsk.png'),
                                    Text('ลงทะเบียน',
                                        style: TextStyle(
                                            fontFamily: context
                                                .read<DataProvider>()
                                                .fontFamily,
                                            fontSize: _width * 0.04,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: _height * 0.03,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Get.offNamed('home');
                },
                child: Container(
                  height: _height * 0.025,
                  width: _width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color.fromARGB(255, 201, 201, 201),
                          width: _width * 0.002)),
                  child: Center(
                      child: Text(
                    '< ย้อนกลับ',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: _width * 0.03,
                        color: Color.fromARGB(255, 201, 201, 201)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
