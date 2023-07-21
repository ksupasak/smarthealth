import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/action/playsound.dart';
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

  Future<void> load_list_patients() async {
    var resTojson;
    if (context.read<DataProvider>().user_id != null &&
        context.read<DataProvider>().user_id != '') {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/get_recep');
      var res = await http
          .post(url, body: {'public_id': context.read<DataProvider>().user_id});
      resTojson = json.decode(res.body);

      setState(() {
        context.read<DataProvider>().list_patients = resTojson['list'];
        print("List Patients${context.read<DataProvider>().list_patients}");
      });
    }
  }

  @override
  void initState() {
    load_list_patients();
    // TODO: implement initState
    super.initState();
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
                      width: _width * 0.1,
                      child: Center(child: Text('ลำดับ', style: textStyle))),
                  Container(
                      width: _width * 0.7,
                      child: Center(child: Text('รายการ', style: textStyle))),
                ],
              )),
          Container(
            height: _height * 0.8,
            child: ListView.builder(
                itemCount: context.read<DataProvider>().list_patients.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${index + 1}"),
                      Pop_card(
                          num: context.read<DataProvider>().list_patients[index]
                              ['public_id'],
                          name: context
                              .read<DataProvider>()
                              .list_patients[index]['name'],
                          status: context
                              .read<DataProvider>()
                              .list_patients[index]['status']),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Pop_card extends StatefulWidget {
  Pop_card({
    super.key,
    required this.num,
    required this.name,
    required this.status,
  });
  String num;
  String name;
  String status;
  @override
  State<Pop_card> createState() => _Pop_cardState();
}

class _Pop_cardState extends State<Pop_card> {
  bool show = false;
  var resTojson;
  void getdata() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': widget.num,
    });

    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  TextStyle style = TextStyle(fontFamily: DataProvider().family);
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
      child: GestureDetector(
        onTap: () {
          keypad_sound();
          setState(() {
            show = !show;
            getdata();
          });
        },
        child: Container(
          decoration: BoxDecoration(
              //    border: Border.all(),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(255, 184, 184, 184),
                    offset: Offset(2, 8),
                    blurRadius: 20)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(40))),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                offset: Offset(0, 3),
                                color: Colors.grey,
                              ),
                            ],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: resTojson != null
                            ? ClipRRect(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: resTojson['personal']
                                                ['picture_url'] ==
                                            ''
                                        ? Container(
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            child: Image.asset(
                                                'assets/user (1).png'))
                                        : Image.network(
                                            '${resTojson['personal']['picture_url']}',
                                            fit: BoxFit.fill,
                                          )))
                            : Container()),
                  ),
                  Container(
                    width: _width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: _width * 0.4,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " ${widget.name}",
                                style: TextStyle(
                                    fontFamily:
                                        context.read<DataProvider>().family),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.status,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily:
                                      context.read<DataProvider>().family),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              show == true
                  ? resTojson != null
                      ? Container(
                          width: _width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(40))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SYS/DIA', style: style),
                                    Row(
                                      children: [
                                        datatext(
                                            resTojson['health_records'][0]
                                                ['bp_sys'],
                                            '/ '),
                                        datatext(
                                            resTojson['health_records'][0]
                                                ['bp_dia'],
                                            'mmHg'),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Height', style: style),
                                    datatext(
                                        resTojson['health_records'][0]
                                            ['height'],
                                        'cm'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Spo2', style: style),
                                    datatext(
                                        resTojson['health_records'][0]['spo2'],
                                        'min'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Temp', style: style),
                                    datatext(
                                        resTojson['health_records'][0]['temp'],
                                        '°C'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Weight', style: style),
                                    datatext(
                                        resTojson['health_records'][0]
                                            ['weight'],
                                        'kg'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pulse Rate', style: style),
                                    datatext(
                                        resTojson['health_records'][0]
                                            ['pulse_rate'],
                                        'bpm'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('fbs', style: style),
                                    datatext(
                                        resTojson['health_records'][0]['fbs'],
                                        'mg/dl'),
                                  ],
                                ),
                                Text('รายละเอียด :', style: style),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: _width * 0.6,
                                      child: datatext(
                                          resTojson['health_records'][0]['cc'],
                                          ''),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.05,
                              height: MediaQuery.of(context).size.width * 0.05,
                              child: CircularProgressIndicator(
                                  color: Color(0xff48B5AA)),
                            ),
                          ),
                        )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget datatext(String? data, String? measure) {
    return data != null
        ? Text("${data} ${measure}", style: style)
        : Text("-- ${measure}", style: style);
  }
}
