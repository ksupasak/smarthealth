import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/action/playsound.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FormatList extends StatefulWidget {
  const FormatList({super.key});

  @override
  State<FormatList> createState() => _FormatListState();
}

class _FormatListState extends State<FormatList> {
  List<RecordSnapshot<int, Map<String, Object?>>>? snapshot;
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
        context.read<DataProvider>().user_id != '' &&
        context.read<DataProvider>().status_internet != false) {
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

  Future<Database> openDatabase_list_health_record() async {
    Directory app = await getApplicationDocumentsDirectory();
    String dbpart = app.path + '/health_record/' + 'health_record.db';
    final db = await databaseFactoryIo.openDatabase(dbpart);
    return db;
  }

  Future<List<RecordSnapshot<int, Map<String, Object?>>>?>
      load_health_record() async {
    setState(() {
      snapshot = null;
    });
    final db = await openDatabase_list_health_record();
    final store = intMapStoreFactory.store('list_health_record');
    snapshot = await store.find(db);
    setState(() {});
    return snapshot;
  }

  @override
  void initState() {
    load_list_patients();
    load_health_record();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            context.read<DataProvider>().status_internet == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Image.asset(
                      'assets/wifi.png',
                      width: 20,
                    )),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Image.asset(
                      'assets/no-signal.png',
                      width: 20,
                    )),
                  )
            // Text(
            //   '${context.read<DataProvider>().status_internet.toString()}',
            //   style: TextStyle(color: Colors.black),
            // )
          ],
          title: Text(
            'รายการตรวจ',
            style: TextStyle(
                color: Color(0xff48B5AA),
                fontFamily: context.read<DataProvider>().family),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(indicatorColor: Color(0xff48B5AA), tabs: [
            Tab(
              // icon: Icon(Icons.abc),
              child: Text(
                "รายการที่ยังไม่ได้ส่ง",
                style: TextStyle(
                    color: Color(0xff48B5AA),
                    fontFamily: context.read<DataProvider>().family),
              ),
            ),
            Tab(
              // icon: Icon(Icons.abc),
              child: Text(
                "รายการที่ต้องตรวจ",
                style: TextStyle(
                    color: Color(0xff48B5AA),
                    fontFamily: context.read<DataProvider>().family),
              ),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            list_patients_offline(),
            context.read<DataProvider>().user_id != '' &&
                    context.read<DataProvider>().user_id != null
                ? SafeArea(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
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
                                  fontFamily:
                                      context.read<DataProvider>().family),
                            )
                    ]),
                  )
                : Container(
                    child: Center(
                        child: Text('กรุณาล็อคอิน',
                            style: TextStyle(
                                fontFamily: context.read<DataProvider>().family,
                                color: Color(0xffff0000)))),
                  ),
          ],
        ),
      ),
    );
  }

  Widget list_patients_offline() {
    return snapshot != null
        ? snapshot?.length != 0
            ? Container(
                child: ListView.builder(
                    itemCount: snapshot?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Pop_card_offline(
                          data: snapshot?[index],
                          id: index.toString(),
                          refresh: load_health_record);
                    }),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ว่าง',
                        style: TextStyle(
                            color: Color(0xff48B5AA),
                            fontSize: 22,
                            fontFamily: context.read<DataProvider>().family),
                      ),
                    ],
                  ),
                ),
              )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: CircularProgressIndicator()),
            ],
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
          Container(
            height: _height * 0.75,
            child: ListView.builder(
                itemCount: context.read<DataProvider>().list_patients.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${index + 1}"),
                      context.read<DataProvider>().list_patients[index]
                                  ['public_id'] !=
                              null
                          ? Pop_card(
                              num: context
                                  .read<DataProvider>()
                                  .list_patients[index]['public_id'],
                              name: context
                                          .read<DataProvider>()
                                          .list_patients[index]['name'] !=
                                      null
                                  ? context
                                      .read<DataProvider>()
                                      .list_patients[index]['name']
                                  : '',
                              status: context
                                  .read<DataProvider>()
                                  .list_patients[index]['status'])
                          : Container(),
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
                        child:
                            resTojson != null && resTojson['personal'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      '${resTojson['personal']['picture_url']}',
                                      fit: BoxFit.fill,
                                    ))
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
                                "${widget.name}",
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
                      ? resTojson['health_records'] != null
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
                                            resTojson['health_records'][0]
                                                ['spo2'],
                                            'min'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Temp', style: style),
                                        datatext(
                                            resTojson['health_records'][0]
                                                ['temp'],
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
                                            resTojson['health_records'][0]
                                                ['fbs'],
                                            'mg/dl'),
                                      ],
                                    ),
                                    Text('รายละเอียด :', style: style),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: _width * 0.6,
                                          child: datatext(
                                              resTojson['health_records'][0]
                                                  ['cc'],
                                              ''),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container()
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

class Pop_card_offline extends StatefulWidget {
  Pop_card_offline({
    super.key,
    this.data,
    this.id,
    required this.refresh,
  });
  RecordSnapshot<int, Map<String, Object?>>? data;
  var id;
  VoidCallback refresh;
  @override
  State<Pop_card_offline> createState() => _Pop_card_offlineState();
}

class _Pop_card_offlineState extends State<Pop_card_offline> {
  bool show = false;
  bool status = false;
  Future<void> delete() async {
    print("delete data key :${widget.data?.key}");
    Directory app = await getApplicationDocumentsDirectory();
    String dbpart = app.path + '/health_record/' + 'health_record.db';
    final db = await databaseFactoryIo.openDatabase(dbpart);
    final store = intMapStoreFactory.store('list_health_record');

    await store.delete(
      db,
      finder: Finder(
          filter: Filter.or([
        Filter.byKey(widget.data?.key),
      ])),
    );
    setState(() {
      status = false;
      widget.data = null;
    });
  }

  void sendDataOffline() async {
    if (context.read<DataProvider>().status_internet == true) {
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/add_hr');
      var res = await http.post(url, body: {
        "public_id": "${widget.data?['public_id']}",
        "care_unit_id": context.read<DataProvider>().care_unit_id,
        "temp": '${widget.data?['temp']}',
        "weight": '${widget.data?['weight']}',
        "bp_sys": '${widget.data?['bp_sys']}',
        "bp_dia": '${widget.data?['bp_dia']}',
        "pulse_rate": '${widget.data?['pulse_rate']}',
        "spo2": '${widget.data?['spo2']}',
        "fbs": '${widget.data?['fbs']}',
        "height": '${widget.data?['height']}',
        "bmi": "",
        "bp": '${widget.data?['bp_sys']}/${widget.data?['bp_dia']}',
        "rr": "",
        "cc": '${widget.data?['cc']}',
        "recep_public_id": context.read<DataProvider>().user_id,
      });
      var resTojson = json.decode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          if (resTojson['message'] == "success") {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text(
                        'สำเร็จ',
                      )))));
              delete();
            });
          } else {
            status = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      'Error',
                    )))));
          }
        });
      } else {
        setState(() {
          status = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'Error404',
                  )))));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return widget.data?['status'] == 'unsuccessful'
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                keypad_sound();
                setState(() {
                  show = !show;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: _width,
                        child: Text(
                          "${widget.data?['prefix_name']} ${widget.data?['first_name']} ${widget.data?['last_name']}",
                          style: TextStyle(
                            color: Color(0xff48B5AA),
                            fontFamily: context.read<DataProvider>().family,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: _width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "เลขบัตร : ${widget.data?['public_id']}",
                              style: TextStyle(
                                color: Color(0xff48B5AA),
                                fontFamily: context.read<DataProvider>().family,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "สถานะ :",
                                  style: TextStyle(
                                    color: Color(0xff48B5AA),
                                    fontFamily:
                                        context.read<DataProvider>().family,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  " ยังไม่ส่ง",
                                  style: TextStyle(
                                    color: Color(0xffff0000),
                                    fontFamily:
                                        context.read<DataProvider>().family,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      show != false
                          ? Column(
                              children: [
                                Text(
                                  'ข้อมูลสุขภาพ',
                                  style: TextStyle(
                                      color: Color(0xff48B5AA),
                                      fontFamily:
                                          context.read<DataProvider>().family,
                                      fontSize: 18),
                                ),
                                Container(
                                  child: Column(children: [
                                    box_data(
                                        'อุณหภูมิ', '${widget.data?['temp']}'),
                                    box_data(
                                        'น้ำหนัก', '${widget.data?['weight']}'),
                                    box_data('pulse_rate',
                                        '${widget.data?['pulse_rate']}'),
                                    box_data('bp',
                                        '${widget.data?['bp_sys']}/${widget.data?['bp_dia']}'),
                                    box_data('spo2', '${widget.data?['spo2']}'),
                                    box_data(
                                        'น้ำตาล', '${widget.data?['fbs']}'),
                                    box_data(
                                        'ความสูง', '${widget.data?['height']}'),
                                    box_data(
                                        'รายละเอียด', '${widget.data?['cc']}'),
                                    box_data('เวลา', '${widget.data?['time']}'),
                                  ]),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromARGB(255, 255, 0, 0),
                                          onPrimary: Colors.white,
                                        ),
                                        onPressed: () {
                                          keypad_sound();
                                          delete();
                                        },
                                        child: Text(' ลบ ')),
                                    status == false
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: context
                                                          .read<DataProvider>()
                                                          .status_internet ==
                                                      false
                                                  ? Color.fromARGB(
                                                      45, 72, 181, 170)
                                                  : Color.fromARGB(
                                                      255, 72, 181, 170),
                                              onPrimary: Colors.white,
                                            ),
                                            onPressed: () {
                                              keypad_sound();
                                              sendDataOffline();
                                              setState(() {
                                                status = true;
                                              });
                                            },
                                            child: Text(' ส่ง '))
                                        : CircularProgressIndicator(),
                                  ],
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget box_data(String text, String data) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '$text',
          style: TextStyle(
            color: Color(0xff48B5AA),
            fontFamily: context.read<DataProvider>().family,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$data',
          style: TextStyle(
            color: Color.fromARGB(255, 72, 123, 181),
            fontFamily: context.read<DataProvider>().family,
          ),
        ),
      ]),
    );
  }
}
