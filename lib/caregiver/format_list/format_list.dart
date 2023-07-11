import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:http/http.dart' as http;

class FormatList extends StatefulWidget {
  const FormatList({super.key});

  @override
  State<FormatList> createState() => _FormatListState();
}

class _FormatListState extends State<FormatList> {
  Future<void> getdatapatient(String id) async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': id,
    });
    var resTojson = json.decode(res.body);
    print(resTojson);
    return resTojson;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return context.read<DataProvider>().user_id != '' &&
            context.read<DataProvider>().user_id != null
        ? SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    // height: _height * 0.01,
                    // width: _width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey)),
              ),
              context.read<DataProvider>().list_patients.length > 0
                  ? list_patients()
                  : Text(
                      'ไม่มีรายการ',
                      style: TextStyle(
                          color: Color(0xff48B5AA),
                          fontSize: 22,
                          fontFamily: context.read<DataProvider>().family),
                    )
            ]),
          )
        : Container(
            child: Center(
                child: Text('กรุณาล็อคอิน',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().family,
                        color: Color(0xffff0000)))),
          );
  }

  Widget list_patients() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle textStyle = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color(0xff909090));
    return Container(
      child: Column(
        children: [
          Text('รายการตรวจ',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: context.read<DataProvider>().family,
                  fontSize: _width * 0.05,
                  color: Color(0xff48B5AA))),
          Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: _width * 0.25,
                      child:
                          Center(child: Text('ชื่อ-สกุล', style: textStyle))),
                  Container(
                      width: _width * 0.5,
                      child: Center(
                          child: Text('เลขประจำตัวประชาชน', style: textStyle))),
                  Container(
                      width: _width * 0.25,
                      child: Center(child: Text('สถานะ', style: textStyle)))
                ],
              )),
          Container(
            height: _height * 0.8,
            child: ListView.builder(
                itemCount: context.read<DataProvider>().list_patients.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: _width * 0.33,
                            child: Center(
                              child: Text(
                                  '${context.read<DataProvider>().list_patients[index]['name']}',
                                  style: textStyle),
                            ),
                          ),
                          Container(
                            width: _width * 0.33,
                            child: Center(
                              child: Text(
                                  '${context.read<DataProvider>().list_patients[index]['public_id']}',
                                  style: textStyle),
                            ),
                          ),
                          Container(
                            width: _width * 0.33,
                            child: Center(
                              child: Text(
                                  '${context.read<DataProvider>().list_patients[index]['status']}',
                                  style: textStyle),
                            ),
                          )
                        ],
                      ));
                }),
          ),
        ],
      ),
    );
  }
}

class BoxPatient extends StatefulWidget {
  BoxPatient({super.key, this.id});
  String? id;
  @override
  State<BoxPatient> createState() => _BoxPatientState();
}

class _BoxPatientState extends State<BoxPatient> {
  var resTojson;
  Future<void> getdatapatient() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': widget.id,
    });
    resTojson = json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return resTojson != null
        ? Container(
            child: Text('${resTojson['']}'),
          )
        : Container(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.width * 0.05,
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}
