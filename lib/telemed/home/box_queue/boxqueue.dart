import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/provider/provider.dart';

import 'package:http/http.dart' as http;

class BoxQueue extends StatefulWidget {
  const BoxQueue({super.key});

  @override
  State<BoxQueue> createState() => _BoxQueueState();
}

class _BoxQueueState extends State<BoxQueue> {
  Timer? _timer;
  Map<String, dynamic>? resTojson;

  void lop() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        get_queue();
      });
    });
  }

  Future<void> get_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
    });

    var jsonData = json.decode(res.body);
    if (resTojson.toString() != jsonData.toString()) {
      resTojson = jsonData;
    }
  }

  @override
  void initState() {
    print('เปิดFunctionเช็คคิว');
    lop();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    print('ปิดFunctionเช็คคิว');
    // TODO: implement dispose
    super.dispose();
  }

  BoxDecoration boxdecoration_box = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 0)
      ]);
  BoxDecoration boxDecorationbutton = BoxDecoration(
    boxShadow: [
      BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 2),
          blurRadius: 1,
          spreadRadius: 0)
    ],
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
    color: Color(0xffffffff),
  );
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return _width > _height ? style_width() : style_height();
  }

  Widget style_height() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle textStyle = TextStyle(
        color: Colors.white,
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.04);
    TextStyle textStyledata = TextStyle(
        color: Color(0xff1B6286),
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.02);
    BoxDecoration boxdecoration_head = BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      color: Color(0xff31D6AA),
    );

    return Container(
      height: _height * 0.37,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: _width * 0.9,
            height: _height * 0.2,
            decoration: boxdecoration_box,
            child: Column(
              children: [
                SizedBox(height: _width * 0.001),
                Container(
                  decoration: boxdecoration_head,
                  width: _width * 0.9,
                  height: _height * 0.04,
                  child: Row(
                    children: [
                      Container(
                        width: _width * 0.5,
                        child: Center(
                          child: Text(
                            'เเพย์',
                            style: textStyle,
                          ),
                        ),
                      ),
                      Container(
                        width: _width * 0.2,
                        child: Center(
                          child: Text(
                            'คิวที่',
                            style: textStyle,
                          ),
                        ),
                      ),
                      Container(
                        width: _width * 0.2,
                        child: Center(
                          child: Text(
                            'สถานะ',
                            style: textStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                resTojson != null
                    ? resTojson!['callings'].length != 0
                        ? Container(
                            height: _height * 0.04,
                            decoration: boxDecorationbutton,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resTojson!['callings'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  //   color: Color.fromARGB(100, 81, 7, 255),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: _width * 0.5,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['callings'][index]['doctor_name']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['callings'][index]['queue_number']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "เรียกคิว",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
                resTojson != null
                    ? resTojson!['processings'].length != 0
                        ? Container(
                            height: (_height * 0.04),
                            //   color: Color.fromARGB(98, 110, 255, 7),
                            decoration: boxDecorationbutton,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resTojson!['processings'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  //color: Color.fromARGB(100, 81, 7, 255),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: _width * 0.5,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['processings'][index]['doctor_name']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['processings'][index]['queue_number']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "กำลังตรวจ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
              ],
            ),
          ),
          Container(
            width: _width * 0.6,
            //  height: _height * 0.15, //ลบ
            decoration: boxdecoration_box,
            child: Column(children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: _height * 0.05,
                      width: _width * 0.2,
                      child: Center(
                          child: Container(
                              height: _height * 0.04,
                              width: _width * 0.15,
                              decoration: boxdecoration_box,
                              child: Center(
                                  child: Text(
                                'คิวที่รอ',
                                style: textStyledata,
                              )))),
                    ),
                    Container(
                      height: _height * 0.05,
                      width: _width * 0.4,
                      child: resTojson != null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resTojson!['waits'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Center(
                                    child: Container(
                                      height: _height * 0.04,
                                      width: _width * 0.15,
                                      decoration: boxdecoration_box,
                                      child: Center(
                                        child: Text(
                                          resTojson!['waits'][index],
                                          style: textStyledata,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text(''),
                    ),
                  ],
                ),
              ),
              resTojson != null
                  ? resTojson!['calleds'].length != 0
                      ? Container(
                          child: Row(
                            children: [
                              Container(
                                height: _height * 0.05,
                                width: _width * 0.2,
                                child: Center(
                                    child: Container(
                                        height: _height * 0.04,
                                        width: _width * 0.15,
                                        decoration: boxdecoration_box,
                                        child: Center(
                                            child: Text(
                                          'เรียกเเล้ว',
                                          style: textStyledata,
                                        )))),
                              ),
                              Container(
                                height: _height * 0.05,
                                width: _width * 0.4,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: resTojson!['calleds'].length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Center(
                                        child: Container(
                                          height: _height * 0.04,
                                          width: _width * 0.15,
                                          decoration: boxdecoration_box,
                                          child: Center(
                                            child: Text(
                                              resTojson!['calleds'][index],
                                              style: textStyledata,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : Container(),
              resTojson != null
                  ? resTojson!['completes'].length != 0
                      ? Container(
                          child: Row(
                            children: [
                              Container(
                                height: _height * 0.05,
                                width: _width * 0.2,
                                child: Center(
                                    child: Container(
                                        height: _height * 0.04,
                                        width: _width * 0.15,
                                        decoration: boxdecoration_box,
                                        child: Center(
                                            child: Text(
                                          'รับผลตรวจ',
                                          style: textStyledata,
                                        )))),
                              ),
                              Container(
                                height: _height * 0.05,
                                width: _width * 0.4,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: resTojson!['completes'].length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Center(
                                        child: Container(
                                          height: _height * 0.04,
                                          width: _width * 0.15,
                                          decoration: boxdecoration_box,
                                          child: Center(
                                            child: Text(
                                              resTojson!['completes'][index],
                                              style: textStyledata,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                  : Container()
            ]),
          )
        ],
      ),
    );
  }

  Widget style_width() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle textStyle = TextStyle(
        color: Colors.white,
        fontFamily: context.read<DataProvider>().family,
        fontSize: _height * 0.04);
    TextStyle textStyledata = TextStyle(
        color: Color(0xff1B6286),
        fontFamily: context.read<DataProvider>().family,
        fontSize: _height * 0.02);
    BoxDecoration boxdecoration_head = BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      color: Color(0xff31D6AA),
    );
    return Container(
      height: _height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: _width * 0.9,
            height: _height * 0.4,
            decoration: boxdecoration_box,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _width * 0.001),
                Container(
                  width: _width * 0.9,
                  decoration: boxdecoration_head,
                  child: Row(
                    children: [
                      Container(
                        width: _width * 0.5,
                        child: Center(
                          child: Text(
                            'เเพย์',
                            style: textStyle,
                          ),
                        ),
                      ),
                      Container(
                        width: _width * 0.2,
                        child: Center(
                          child: Text(
                            'คิวที่',
                            style: textStyle,
                          ),
                        ),
                      ),
                      Container(
                        width: _width * 0.2,
                        child: Center(
                          child: Text(
                            'สถานะ',
                            style: textStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                resTojson != null
                    ? resTojson!['callings'].length != 0
                        ? Container(
                            height: _height * 0.04,
                            decoration: boxDecorationbutton,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resTojson!['callings'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  //   color: Color.fromARGB(100, 81, 7, 255),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: _width * 0.5,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['callings'][index]['doctor_name']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['callings'][index]['queue_number']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "เรียกคิว",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
                resTojson != null
                    ? resTojson!['processings'].length != 0
                        ? Container(
                            height: (_height * 0.04),
                            //   color: Color.fromARGB(98, 110, 255, 7),
                            decoration: boxDecorationbutton,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resTojson!['processings'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  //color: Color.fromARGB(100, 81, 7, 255),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: _width * 0.5,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['processings'][index]['doctor_name']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "${resTojson!['processings'][index]['queue_number']} ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.2,
                                        child: Center(
                                          child: Text(
                                            "กำลังตรวจ",
                                            style: textStyledata,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
              ],
            ),
          ),
          Container(
            width: _width * 0.6,
            height: _height * 0.15, //ลบ
            decoration: boxdecoration_box,
            child: Column(children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: _height * 0.05,
                      width: _width * 0.2,
                      color: Color.fromARGB(99, 7, 255, 7),
                      child: Center(child: Text('คิวที่รอ')),
                    ),
                    Container(
                      height: _height * 0.05,
                      width: _width * 0.4,
                      color: Color.fromARGB(100, 255, 193, 7),
                      child: resTojson != null
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resTojson!['waits'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Center(
                                    child: Text(
                                      resTojson!['waits'][index],
                                      style:
                                          TextStyle(color: Color(0xff1B6286)),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text(''),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
