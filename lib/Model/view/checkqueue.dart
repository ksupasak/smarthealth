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

class CheckQueue extends StatefulWidget {
  const CheckQueue({super.key});

  @override
  State<CheckQueue> createState() => _CheckQueueState();
}

class _CheckQueueState extends State<CheckQueue> {
  var resTojson;
  String textqueue = 'not found today appointment';
  bool statusbottom = false;
  void checkqueue() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().checkqueueURL}'); //${context.read<stringitem>().uri}
    var res = await http.post(url, body: {
      'public_id': '${context.read<DataProvider>().id}',
    });
    resTojson = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        print(resTojson['message']);
        //   context.read<DataProvider>().checkqueue = resTojson;
      });
    }
  }

  void printqueue() {
    if (resTojson != null) {
      setState(() {
        statusbottom = true;
      });
      if (resTojson['message'] != textqueue) {
        print('ปริ้นคิว');
        setState(() {
          statusbottom = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                  texthead: 'รับคิวที่เครื่อง',
                  textbody: 'กำลังปริ้นคิว...',
                  pathicon: 'assets/9df753370d3f57e6d1325129db200f93.gif');
            });
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
          // Get.offNamed('menu');
        });
      } else {
        setState(() {
          statusbottom = false;
        });
      }
    }
  }

  @override
  void initState() {
    checkqueue();
    // print("${context.read<DataProvider>().checkqueue}");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        Positioned(
            child: BackGroundSmart_Health(
          BackGroundColor: [
            StyleColor.backgroundbegin,
            StyleColor.backgroundend
          ],
        )),
        Positioned(
            child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                resTojson == null
                    ? Text(
                        'กำลังโหลด...',
                        style: TextStyle(
                            color: Colors.white, fontSize: _height * 0.03),
                      )
                    : Text(
                        '${resTojson['message']}',
                        style: TextStyle(
                            color: Colors.white, fontSize: _height * 0.03),
                      ),
                SizedBox(height: _height * 0.02),
                MarkCheck(
                    height: 0.2, width: 0.4, pathicon: 'assets/queue.png'),
                SizedBox(height: _height * 0.02),
                statusbottom == false
                    ? GestureDetector(
                        onTap: () {
                          printqueue();
                        },
                        child: BoxWidetdew(
                          height: 0.08,
                          width: 0.4,
                          color: resTojson == null
                              ? Color.fromARGB(100, 89, 204, 93)
                              : resTojson['message'] == textqueue
                                  ? Color.fromARGB(100, 89, 204, 93)
                                  : Color.fromARGB(255, 0, 255, 8),
                          text: resTojson == null
                              ? 'กำลังโหลด...'
                              : resTojson['message'] == textqueue
                                  ? 'ไม่มีคิว'
                                  : 'ปริ้นคิว',
                          textcolor: resTojson == null
                              ? Color.fromARGB(100, 255, 255, 255)
                              : resTojson['message'] == textqueue
                                  ? Color.fromARGB(200, 255, 255, 255)
                                  : Color.fromARGB(255, 255, 255, 255),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.07,
                        height: MediaQuery.of(context).size.width * 0.07,
                        child: CircularProgressIndicator(),
                      ),
                SizedBox(height: _height * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: BoxWidetdew(
                    height: 0.08,
                    width: 0.4,
                    color: Color.fromARGB(255, 255, 0, 0),
                    text: 'ออก',
                    textcolor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ))
      ]),
    );
  }
}
