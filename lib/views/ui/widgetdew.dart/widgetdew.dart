import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/views/pages/print_exam.dart';
import 'package:smart_health/views/pages/videocall.dart';
import 'package:smart_health/widget_decorate/WidgetDecorate.dart';
import 'package:http/http.dart' as http;

class backgrund extends StatefulWidget {
  const backgrund({super.key});

  @override
  State<backgrund> createState() => _backgrundState();
}

class _backgrundState extends State<backgrund> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Positioned(
        child: Container(
      width: _width,
      height: _height,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: _height * 0.25,
            width: _width,
            child: SvgPicture.asset(
              'assets/Frame 9178.svg',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    )
        //      BackGroundSmart_Health(
        //   BackGroundColor: [
        //     Color.fromARGB(255, 255, 255, 255),
        //     StyleColor.backgroundbegin,
        //     StyleColor.backgroundbegin,
        //   ],
        // )
        );
  }
}

class BoxTime extends StatefulWidget {
  BoxTime({super.key});

  @override
  State<BoxTime> createState() => _BoxTimeState();
}

class _BoxTimeState extends State<BoxTime> {
  DateTime dateTime = DateTime.parse('0000-00-00 00:00');
  String data = "";
  Timer? timer;
  @override
  void initState() {
    start();
  }

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        dateTime = DateTime.now();
        data = "เวลา ${dateTime.hour}:" +
            "${dateTime.minute}:" +
            "${dateTime.second}";
      });
    });
  }

  void stop() {
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    return Container(
      height: _height * 0.1,
      width: _width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [WidgetNameHospital(), SizedBox(width: _width * 0.08)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(context.read<DataProvider>().care_unit, style: style),
              Text(data.toString(), style: style)
            ],
          ),
        ],
      ),
    );
  }
}

class BoxWidetdew extends StatefulWidget {
  BoxWidetdew(
      {super.key,
      this.color,
      this.text,
      this.height,
      this.width,
      this.fontSize,
      this.textcolor,
      this.fontWeight,
      this.radius,
      this.colorborder});
  var color;
  var text;
  var width;
  var height;
  var fontSize;
  var textcolor;
  var fontWeight;
  var radius;
  var colorborder;
  @override
  State<BoxWidetdew> createState() => _BoxWidetdewState();
}

class _BoxWidetdewState extends State<BoxWidetdew> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        border: widget.colorborder == null
            ? null
            : Border.all(color: widget.colorborder, width: 2),
        borderRadius: widget.radius == null
            ? BorderRadius.circular(100)
            : BorderRadius.circular(widget.radius),
        color: widget.color == null ? Colors.amber : widget.color,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0.5, 2),
            color: Colors.grey,
          ),
        ],
      ),
      height: widget.height == null ? _height * 0.02 : _height * widget.height,
      width: widget.width == null ? _width * 0.08 : _width * widget.width,
      child: Center(
        child: widget.text == null
            ? null
            : Text(
                widget.text.toString(),
                style: TextStyle(
                  fontFamily: context.read<DataProvider>().fontFamily,
                  fontSize:
                      widget.fontSize == null ? 20 : _width * widget.fontSize,
                  color: widget.textcolor == null
                      ? Colors.black
                      : widget.textcolor,
                  fontWeight: widget.fontWeight == null
                      ? FontWeight.w400
                      : widget.fontWeight,
                ),
              ),
      ),
    );
  }
}

class WidgetNameHospital extends StatefulWidget {
  const WidgetNameHospital({super.key});

  @override
  State<WidgetNameHospital> createState() => _WidgetNameHospitalState();
}

class _WidgetNameHospitalState extends State<WidgetNameHospital> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    return Container(
        child: Center(
      child: Container(
          child:
              Text(context.read<DataProvider>().name_hospital, style: style)),
    ));
  }
}

class BoxRecord extends StatefulWidget {
  BoxRecord({super.key, this.keyvavlue, this.texthead, this.icon});
  var keyvavlue;
  var texthead;
  Widget? icon;
  @override
  State<BoxRecord> createState() => _BoxRecordState();
}

class _BoxRecordState extends State<BoxRecord> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Color teamcolor = Color.fromARGB(255, 35, 131, 123);
    return Container(
      height: _height * 0.1,
      width: _width * 0.2,
      color: Colors.white,
      child: Column(
        children: [
          widget.texthead == null
              ? Text('')
              : Text('${widget.texthead}',
                  style: TextStyle(
                      fontFamily: context.read<DataProvider>().fontFamily,
                      fontSize: _width * 0.03,
                      color: teamcolor)),
          TextField(
            cursorColor: teamcolor,
            onChanged: (value) {
              if (value.length > 0) {
                context.read<Datafunction>().playsound();
              }
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: teamcolor,
                ),
              ),
              //   border: InputBorder.none, //เส้นไต้
            ),
            style: TextStyle(
              fontFamily: context.read<DataProvider>().fontFamily,
              color: teamcolor,
              fontSize: _height * 0.03,
            ),
            controller: widget.keyvavlue,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BoxDecorate extends StatefulWidget {
  BoxDecorate({super.key, this.child, this.color});
  var child;
  var color;

  @override
  State<BoxDecorate> createState() => _BoxDecorateState();
}

class _BoxDecorateState extends State<BoxDecorate> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return widget.child == null
        ? Container()
        : Container(
            child: Center(
              child: Container(
                  width: _width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Color.fromARGB(255, 214, 214, 214)),
                    ],
                  ),
                  child: Center(
                    child: widget.child,
                  )),
            ),
          );
  }
}

class InformationCard extends StatefulWidget {
  InformationCard({super.key, this.dataidcard});
  var dataidcard;
  @override
  State<InformationCard> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.20,
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.white),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03,
              ),
              child: widget.dataidcard['data']['picture_url'] == ''
                  ? Container(
                      color: Color.fromARGB(255, 240, 240, 240),
                      child: Image.asset('assets/user (1).png'))
                  : Image.network(
                      '${widget.dataidcard['data']['picture_url']}',
                      fit: BoxFit.fill,
                    ),
            )
            // : Icon(Icons.person)
            ),
        Container(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.dataidcard['data']['first_name']}" +
                        '  ' +
                        "${widget.dataidcard['data']['last_name']}",
                    style: TextStyle(
                      fontFamily: context.read<DataProvider>().fontFamily,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: Color.fromARGB(255, 0, 109, 64),
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 0, 109, 64),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Text(
                    "${widget.dataidcard['data']['public_id']}",
                    style: TextStyle(
                      fontFamily: context.read<DataProvider>().fontFamily,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Color.fromARGB(255, 0, 109, 64),
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 0, 109, 64),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class Line extends StatefulWidget {
  Line({super.key, this.height, this.width, this.color});
  var height;
  var width;
  var color;
  @override
  State<Line> createState() => _LineState();
}

class _LineState extends State<Line> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height == null ? 1 : widget.height,
      width: widget.width == null ? 1 : widget.width,
      color: widget.color == null ? c : widget.color,
    );
  }
}

class MarkCheck extends StatefulWidget {
  MarkCheck({super.key, this.height, this.width, this.pathicon});
  var height;
  var width;
  var pathicon;
  @override
  State<MarkCheck> createState() => _MarkCheckState();
}

class _MarkCheckState extends State<MarkCheck> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        child: widget.pathicon == null
            ? Container(
                color: Colors.amber,
              )
            : Image.asset(
                '${widget.pathicon}',
                height: widget.height == null ? 1 : _height * widget.height,
                width: widget.width == null ? 1 : _width * widget.width,
              ));
  }
}

class BoxQueue extends StatefulWidget {
  BoxQueue({super.key});

  @override
  State<BoxQueue> createState() => _BoxQueueState();
}

class _BoxQueueState extends State<BoxQueue> {
  var resTojson;
  String? textqueue;
  bool q = false;
  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      textqueue = resTojson["queue_number"];
      if (!q) {
        Future.delayed(const Duration(seconds: 2), () {
          checkt_queue();
          setState(() {
            q = true;
          });
        });
      }
    });
  }

  @override
  void initState() {
    checkt_queue();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return resTojson != null
        ? resTojson["queue_number"] != ""
            ? Container(
                width: _width * 0.8,
                height: _height * 0.15,
                child: Column(
                  children: [
                    Text(
                      'กรุณารอเรียกคิว',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().fontFamily,
                          fontSize: _width * 0.04),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(149, 18, 42, 253),
                          borderRadius: BorderRadius.circular(20)),
                      width: _width * 0.8,
                      height: _height * 0.10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.blue,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: 'หมายเลขคิวของคุณ',
                                textcolor: Colors.white,
                              ),
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.white,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: textqueue,
                                textcolor: Color.fromARGB(255, 43, 179, 161),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.blue,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: 'รออีก(คิว)',
                                textcolor: Colors.white,
                              ),
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.white,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: resTojson['wait_list'].length.toString(),
                                textcolor: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Text(resTojson["queue_number"]),
              )
        : Container(
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            child: CircularProgressIndicator(),
          );
  }
}

class BoxShoHealth_Records extends StatefulWidget {
  BoxShoHealth_Records({super.key});

  @override
  State<BoxShoHealth_Records> createState() => _BoxShoHealth_RecordsState();
}

class _BoxShoHealth_RecordsState extends State<BoxShoHealth_Records> {
  var resTojson;
  void information() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      // 'care_unit_id': '63d7a282790f9bc85700000e',
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      print(resTojson);
    });
  }

  @override
  void initState() {
    information();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle styletext = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Colors.white,
        fontSize: _width * 0.04);
    TextStyle styletext2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 12, 172, 153),
        fontSize: _width * 0.03);
    TextStyle styletext3 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    TextStyle styletext4 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 28, 1, 91),
        fontSize: _width * 0.03);
    TextStyle styletext5 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 12, 172, 153),
        fontSize: _width * 0.025);
    return Container(
      width: _width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('ข้อมูลสุขภาพ', style: styletext3),
          Container(
            color: Color.fromARGB(255, 95, 182, 167),
            height: _height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BoxDataHealth(child: Text('วันที่', style: styletext)),
                BoxDataHealth(child: Text('height', style: styletext)),
                BoxDataHealth(child: Text('weight', style: styletext)),
                BoxDataHealth(child: Text('temp', style: styletext)),
                BoxDataHealth(child: Text('sys.', style: styletext)),
                BoxDataHealth(child: Text('dia', style: styletext)),
                BoxDataHealth(child: Text('spo2', style: styletext)),
                // Text('fbs', style: styletext),
                // Text('si', style: styletext),
                // Text('uric', style: styletext),
                // Text('pulse_rate.', style: styletext),
              ],
            ),
          ),
          resTojson != null
              ? resTojson['health_records'].length != 0
                  ? Container(
                      height: _height * 0.35,
                      child: ListView.builder(
                        itemCount: resTojson['health_records'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              context.read<Datafunction>().playsound();
                              print(index);
                            },
                            child: Column(
                              children: [
                                Container(height: 1, color: Colors.white),
                                Container(
                                  color: Color.fromARGB(255, 219, 246, 240),
                                  height: _height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      resTojson['health_records'][index]
                                                  ['updated_at'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['updated_at']}',
                                                  style: styletext5)),
                                      resTojson['health_records'][index]
                                                  ['height'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['height']}',
                                                  style: styletext2)),
                                      resTojson['health_records'][index]
                                                  ['weight'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['weight']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['temp'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['temp']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['bp_dia'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['bp_dia']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['bp_sys'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['bp_sys']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['spo2'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['spo2']}',
                                                  style: styletext2),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ))
                  : Container(
                      height: _height * 0.04,
                      color: Color.fromARGB(100, 255, 255, 255),
                      child: Center(
                          child: Text('ไม่มีข้อมูลสุขภาพ', style: styletext4)),
                    )
              : Container()
        ],
      ),
    );
  }
}

class BoxDataHealth extends StatefulWidget {
  BoxDataHealth({super.key, required this.child});
  Widget child;
  @override
  State<BoxDataHealth> createState() => _BoxDataHealthState();
}

class _BoxDataHealthState extends State<BoxDataHealth> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width * 0.14,
      child: Center(child: widget.child),
    );
  }
}

class BoxRunQueue2 extends StatefulWidget {
  const BoxRunQueue2({super.key});

  @override
  State<BoxRunQueue2> createState() => _BoxRunQueue2State();
}

class _BoxRunQueue2State extends State<BoxRunQueue2> {
  Timer? _timer;
  var resTojson;
  bool loadplatfromURL = false;
  Future<void> get_queue() async {
    try {
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
      });
      setState(() {
        resTojson = json.decode(res.body);
      });
    } catch (e) {
      _timer!.cancel();
      loadplatfromURL = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'platfromURL ไม่ถูหต้อง',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void lop_queue() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL != '') {
          get_queue();
        }
      });
    });
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    lop_queue();
    // TODO: implement initState
    super.initState();
  }

  BoxDecoration boxdecoration_head_blue = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff00a3ff),
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1.5),
            blurRadius: 1,
            spreadRadius: 1)
      ]);
  BoxDecoration boxdecoration_head_yellow = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xffffa800),
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1.5),
            blurRadius: 1,
            spreadRadius: 1)
      ]);
  BoxDecoration boxdecoration_head_grey = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1.5),
            blurRadius: 1,
            spreadRadius: 1)
      ]);
  BoxDecoration boxdecoration_box = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white, // context.read<StyleColorsApp>().blue_app,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 0)
      ]);
  BoxDecoration boxdecoration_boxbutton = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff31d6aa), // context.read<StyleColorsApp>().blue_app,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 2)
      ]);
  BoxDecoration boxdecoration_boxbutton_in = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xffffffff), // context.read<StyleColorsApp>().blue_app,
      border: Border.all(color: Colors.grey));

  Widget status() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().fontFamily);
    return Container(
      height: _height * 0.08,
      child: Container(
        decoration: resTojson != null
            ? resTojson['message'] == 'no queue'
                ? resTojson['completes'].length != 0
                    ? boxdecoration_head_yellow
                    : boxdecoration_head_grey
                : resTojson['message'] == 'calling'
                    ? boxdecoration_head_blue
                    : boxdecoration_head_blue
            : boxdecoration_head_grey,
        height: _height * 0.08,
        width: _width * 0.68,
        child: Center(
            child: resTojson != null
                ? resTojson['message'] == 'no queue'
                    ? resTojson['completes'].length != 0
                        ? Text('รอรับผลตรวจ', style: style)
                        : Text('ยังไม่เรียก', style: style)
                    : resTojson['message'] == 'calling'
                        ? Text('เรียกคิว', style: style)
                        : Text('?', style: style)
                : Text(
                    "--",
                    style: style,
                  )),
      ),
    );
  }

  Widget numberqueue() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: Color(0xffffa800),
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().fontFamily);
    TextStyle style2 = TextStyle(
        color: Colors.grey,
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().fontFamily);
    return Center(
        child: resTojson != null
            ? resTojson['message'] == 'no queue'
                ? resTojson['completes'].length != 0
                    ? Text(resTojson['completes'][0], style: style)
                    : Text('--', style: style2)
                : resTojson['message'] == 'calling'
                    ? Text(resTojson['queue_number'], style: style)
                    : Text(resTojson['queue_number'], style: style)
            : Text(
                "--",
                style: style2,
              ));
  }

  Widget listQ() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, 2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resTojson['waits'].length,
            itemBuilder: (context, index) {
              return Container(
                width: _width * 0.08,
                decoration: decoration,
                margin: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    resTojson['waits'][index],
                    style: TextStyle(color: Color(0xff1B6286)),
                  ),
                ),
              );
            },
          )
        : Container();
  }

  Widget calleds() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, 2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resTojson['calleds'].length,
            itemBuilder: (context, index) {
              return Container(
                decoration: decoration,
                width: _width * 0.08,
                margin: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    resTojson['calleds'][index],
                    style: TextStyle(color: Color(0xff1B6286)),
                  ),
                ),
              );
            },
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().fontFamily);
    TextStyle style2 = TextStyle(
        color: Color(0xffffa800),
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().fontFamily);
    TextStyle style3 = TextStyle(
        color: Colors.white,
        fontSize: _width * 0.03,
        fontFamily: context.read<DataProvider>().fontFamily);
    BoxDecoration boxdecoration_text_queue_blue = BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff00a3ff),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(0, 0.5),
              blurRadius: 2,
              spreadRadius: 0)
        ]);
    BoxDecoration boxdecoration_text_queue_green = BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffcccccc),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(0, 0.5),
              blurRadius: 2,
              spreadRadius: 0)
        ]);
    return Column(
      children: [
        Container(
            height: _height * 0.25,
            width: _width,
            child: Center(
                child: Container(
                    height: _height * 0.2,
                    width: _width * 0.7,
                    decoration: boxdecoration_box,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          status(),
                          Container(
                              height: _height * 0.1,
                              child: Container(
                                  height: _height * 0.1,
                                  width: _width * 0.68,
                                  child: Row(children: [
                                    Container(
                                      decoration: boxdecoration_boxbutton,
                                      height: _height * 0.1,
                                      width: _width * 0.3325,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: _height * 0.05,
                                            width: _width * 0.3325,
                                            child: Center(
                                                child: Text(
                                              'คิวที่',
                                              style: style,
                                            )),
                                          ),
                                          Container(
                                            decoration:
                                                boxdecoration_boxbutton_in,
                                            height: _height * 0.05,
                                            width: _width * 0.3325,
                                            child: numberqueue(),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: _width * 0.015,
                                    ),
                                    Container(
                                        decoration: boxdecoration_boxbutton,
                                        height: _height * 0.1,
                                        width: _width * 0.3325,
                                        child: Column(children: [
                                          Container(
                                            height: _height * 0.05,
                                            width: _width * 0.3325,
                                            child: Center(
                                                child: Text(
                                              'ช่องบริการ',
                                              style: style,
                                            )),
                                          ),
                                          Container(
                                              decoration:
                                                  boxdecoration_boxbutton_in,
                                              height: _height * 0.05,
                                              width: _width * 0.3325,
                                              child: Center(
                                                  child: Text(
                                                '',
                                                style: style2,
                                              )))
                                        ]))
                                  ])))
                        ])))),
        Container(
          height: _height * 0.09,
          width: _width,
          child: Center(
            child: Container(
              height: _height * 0.09,
              decoration: boxdecoration_box,
              width: _width * 0.52,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: _height * 0.038,
                            width: _width * 0.12,
                            decoration: boxdecoration_text_queue_blue,
                            child:
                                Center(child: Text('คิวต่อไป', style: style3)),
                          ),
                          Container(
                            height: _height * 0.04,
                            width: _width * 0.38,
                            child: listQ(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: _height * 0.038,
                            width: _width * 0.12,
                            decoration: boxdecoration_text_queue_green,
                            child: Center(
                                child: Text('เรียกเเล้ว', style: style3)),
                          ),
                          Container(
                            height: _height * 0.04,
                            width: _width * 0.38,
                            child: calleds(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class BoxRunQueue extends StatefulWidget {
  const BoxRunQueue({super.key});

  @override
  State<BoxRunQueue> createState() => _BoxRunQueueState();
}

class _BoxRunQueueState extends State<BoxRunQueue> {
  Timer? _timer;
  var resTojson;
  bool loadplatfromURL = false;
  Future<void> get_queue() async {
    try {
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
      });
      setState(() {
        resTojson = json.decode(res.body);
      });
    } catch (e) {
      _timer!.cancel();
      loadplatfromURL = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'platfromURL ไม่ถูหต้อง',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void lop_queue() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL != '') {
          get_queue();
        }
      });
    });
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    lop_queue();
    // TODO: implement initState
    super.initState();
  }

  Widget Q() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontSize: _width * 0.035,
        fontFamily: context.read<DataProvider>().fontFamily,
        fontWeight: FontWeight.w600,
        color: Colors.white);
    TextStyle style2 = TextStyle(
        fontSize: _width * 0.025,
        fontFamily: context.read<DataProvider>().fontFamily,
        fontWeight: FontWeight.w600,
        color: Colors.white);
    return resTojson != null
        ? resTojson['message'] == 'no queue'
            ? resTojson['completes'].length != 0
                ? Container(
                    width: _width * 0.7,
                    height: _height * 0.08,
                    child: Row(children: [
                      Container(
                        width: _width * 0.4,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: resTojson['completes'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: _width * 0.1,
                              height: _height * 0.01,
                              margin: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  resTojson['completes'][index],
                                  style: style2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                          width: _width * 0.3,
                          child: Center(
                              child: Text('กรุณารับผลตรวจ', style: style)))
                    ]))
                : Center(
                    child: Container(
                      width: _width * 0.7,
                      child: Center(child: Text("ยังไม่เรียก", style: style)),
                    ),
                  )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _width * 0.4,
                    child: Center(
                        child:
                            Text("${resTojson['queue_number']}", style: style)),
                  ),
                  Container(
                    width: _width * 0.3,
                    child: resTojson != null
                        ? resTojson['message'] == 'calling'
                            ? Text('เรียกตรวจ', style: style)
                            : resTojson['message'] == 'processing'
                                ? Text('กำลังตรวจ', style: style)
                                : Text(resTojson['message'])
                        : Text(''),
                  )
                ],
              )
        : loadplatfromURL == true
            ? Container(
                child: Center(
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
                  Text('platfromURL ไม่ถูหต้อง')
                ],
              )))
            : Container();
  }

  Widget listQ() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, -2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resTojson['waits'].length,
            itemBuilder: (context, index) {
              return Container(
                width: _width * 0.08,
                decoration: decoration,
                margin: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    resTojson['waits'][index],
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          )
        : Container();
  }

  Widget calleds() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, -2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: resTojson['calleds'].length,
      itemBuilder: (context, index) {
        return Container(
          decoration: decoration,
          width: _width * 0.08,
          margin: EdgeInsets.all(8),
          child: Center(
            child: Text(
              resTojson['calleds'][index],
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    BoxDecoration boxDecoration = BoxDecoration(
      //  color: Color.fromARGB(255, 221, 221, 221),
      borderRadius: BorderRadius.circular(10),
    );
    BoxDecoration boxDecoration2 = BoxDecoration(
      color: resTojson != null
          ? resTojson['message'] == 'no queue'
              ? resTojson['completes'].length != 0
                  ? Colors.green
                  : Color.fromARGB(255, 175, 175, 175)
              : resTojson['message'] == 'processing'
                  ? Colors.blue
                  : Colors.yellow
          : Color.fromARGB(255, 175, 175, 175),
      borderRadius: BorderRadius.circular(10),
    );
    TextStyle style = TextStyle(
        fontSize: _width * 0.015,
        fontFamily: context.read<DataProvider>().fontFamily,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 0, 98, 82));
    return Container(
        child: Container(
      width: _width * 0.7,
      decoration: boxDecoration,
      child: Column(
        children: [
          resTojson != null
              ? resTojson['waits'].length != 0
                  ? Container(
                      width: _width * 0.7,
                      height: _height * 0.05,
                      child: Row(
                        children: [
                          Container(
                              width: _width * 0.1,
                              child:
                                  Center(child: Text('กำลังรอ', style: style))),
                          Container(width: _width * 0.6, child: listQ()),
                        ],
                      ))
                  : Container()
              : Container(),
          Container(
              width: _width * 0.7,
              height: _height * 0.08,
              decoration: boxDecoration2,
              child: Q()),
          resTojson != null
              ? resTojson['calleds'].length != 0
                  ? Container(
                      width: _width * 0.7,
                      height: _height * 0.05,
                      child: Row(
                        children: [
                          Container(
                              width: _width * 0.1,
                              child: Text('คิวที่ถูกข้าม')),
                          Container(width: _width * 0.6, child: calleds()),
                        ],
                      ))
                  : Container()
              : Container()
        ],
      ),
    ));
  }
}

class HeadBoxAppointments extends StatefulWidget {
  const HeadBoxAppointments({super.key});

  @override
  State<HeadBoxAppointments> createState() => _HeadBoxAppointmentsState();
}

class _HeadBoxAppointmentsState extends State<HeadBoxAppointments> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w800);
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 0, 73, 129),
        fontSize: _width * 0.045,
        fontWeight: FontWeight.w600);
    return Container(
      child: Column(
        children: [
          Text("การนัดหมายครั้งถัดไป", style: style),
          Container(
            color: Color.fromARGB(255, 115, 250, 221),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('วันที่', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('เวลา', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('สถานที่', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('เเพทย์', style: style2))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoxAppointments extends StatefulWidget {
  BoxAppointments({
    super.key,
  });

  @override
  State<BoxAppointments> createState() => _BoxAppointmentsState();
}

class _BoxAppointmentsState extends State<BoxAppointments> {
  var resTojson;
  void information() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      // 'care_unit_id': '63d7a282790f9bc85700000e',
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  @override
  void initState() {
    information();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    return Container(
        width: _width,
        child: Column(
          children: [
            Container(
              height: _height * 0.38,
              child: resTojson != null
                  ? resTojson['appointments'].length != 0
                      ? ListView.builder(
                          itemCount: resTojson['appointments'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<Datafunction>().playsound();
                                print(index);
                              },
                              child: Container(
                                color: Color.fromARGB(255, 219, 246, 240),
                                height: _height * 0.04,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['date'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['slot'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['care_name'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['doctor_name'],
                                                style: style))),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Column(children: [
                          Container(
                              width: _height,
                              height: _height * 0.04,
                              color: Color.fromARGB(100, 255, 255, 255),
                              child: Center(
                                  child: Text('ไม่มีรายการ', style: style)))
                        ]))
                  : Container(),
            ),
            SizedBox(
              height: _height * 0.01,
            ),
            ButtonAddAppointToday()
          ],
        ));
  }
}

class BoxButtonVideoCall extends StatefulWidget {
  BoxButtonVideoCall({
    super.key,
  });

  @override
  State<BoxButtonVideoCall> createState() => _BoxButtonVideoCallState();
}

class _BoxButtonVideoCallState extends State<BoxButtonVideoCall> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ConnectPage()));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: BoxWidetdew(
          height: 0.05,
          width: 0.4,
          radius: 20.0,
          color: Color.fromARGB(80, 91, 223, 95),
          text: 'video call',
          textcolor: Colors.white,
        ),
      ),
    );
  }
}

class BoxSetting extends StatefulWidget {
  BoxSetting({super.key, this.text, this.textstyle});
  String? text;
  TextStyle? textstyle;
  @override
  State<BoxSetting> createState() => _BoxSettingState();
}

class _BoxSettingState extends State<BoxSetting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 20, 142, 130),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        width: _width * 0.98,
        height: _height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10.0, color: Color.fromARGB(255, 63, 86, 83))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: _width * 0.98,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: _width * 0.47,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.text == null
                                      ? Center(child: Text(''))
                                      : Center(
                                          child: Text(
                                            widget.text.toString(),
                                            style: widget.textstyle == null
                                                ? style1
                                                : widget.textstyle,
                                          ),
                                        ),
                                ],
                              ),
                            )),
                        Container(
                            width: _width * 0.45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: Text(
                                    '>',
                                    style: widget.textstyle == null
                                        ? style1
                                        : widget.textstyle,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class BoxTextFieldSetting extends StatefulWidget {
  BoxTextFieldSetting(
      {super.key,
      this.keyvavlue,
      this.texthead,
      this.textinputtype,
      this.lengthlimitingtextinputformatter});
  var keyvavlue;
  String? texthead;
  TextInputType? textinputtype;
  int? lengthlimitingtextinputformatter;
  @override
  State<BoxTextFieldSetting> createState() => _BoxTextFieldSettingState();
}

class _BoxTextFieldSettingState extends State<BoxTextFieldSetting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 19, 100, 92));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 0, 0, 0));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.texthead == null
                  ? Text('')
                  : Text(widget.texthead.toString(), style: style1),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow()],
                    border: Border.all(
                        color: Color.fromARGB(255, 0, 85, 71), width: 2),
                    borderRadius: BorderRadius.circular(5)),
                width: _width * 0.9,
                child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: widget.textinputtype,
                    controller: widget.keyvavlue,
                    inputFormatters:
                        widget.lengthlimitingtextinputformatter == null
                            ? []
                            : [
                                LengthLimitingTextInputFormatter(
                                    widget.lengthlimitingtextinputformatter),
                              ],
                    style: style2),
              ),
            ]),
      ),
    );
  }
}

class BoxText extends StatefulWidget {
  BoxText({super.key, this.text});
  String? text;
  @override
  State<BoxText> createState() => _BoxTextState();
}

class _BoxTextState extends State<BoxText> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
      shadows: [
        Shadow(
          color: Color(0x80000000),
          offset: Offset(0, 2),
          blurRadius: 2,
        ),
      ],
      fontFamily: context.read<DataProvider>().fontFamily,
      fontSize: _width * 0.035,
      color: Color(0xff00A3FF),
    );
    return widget.text == null
        ? Text('')
        : Center(
            child: Text(
              widget.text.toString(),
              style: style,
            ),
          );
  }
}

class BoxToDay extends StatefulWidget {
  const BoxToDay({super.key});

  @override
  State<BoxToDay> createState() => _BoxToDayState();
}

class _BoxToDayState extends State<BoxToDay> {
  var resTojson;

  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  @override
  void initState() {
    checkt_queue();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle styletext = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Colors.green,
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    TextStyle styletext2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color(0xff00A3FF),
        shadows: [
          Shadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 0,
          ),
        ],
        fontSize: _width * 0.05);
    TextStyle styletext3 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.035,
        fontWeight: FontWeight.w600);
    TextStyle styletext4 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 28, 1, 91),
        fontSize: _width * 0.03);
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.035,
        fontWeight: FontWeight.w800);
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 0, 73, 129),
        fontSize: _width * 0.045,
        fontWeight: FontWeight.w600);
    return Container(
        width: _width,
        child: resTojson != null
            ? resTojson['todays'].length != 0
                ? Center(
                    child: Container(
                      // height: _height * 0.35,
                      width: _width * 0.8,
                      color: Colors.grey,
                    ),
                  )

                //  Center(  //Ui การนัดหมายอันเก่า
                //     child: Container(
                //         height: _height * 0.15,
                //         width: _width * 0.8,
                //         decoration: BoxDecoration(
                //             color: Color.fromARGB(146, 167, 255, 236),
                //             borderRadius: BorderRadius.circular(20)),
                //         child: Column(children: [
                //           Text('การนัดหมายวันนี้', style: styletext3),
                //           Container(
                //             color: Color.fromARGB(255, 115, 250, 221),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Container(
                //                     width: _width * 0.2,
                //                     child: Center(
                //                         child: Text('วันที่', style: style2))),
                //                 Container(
                //                     width: _width * 0.2,
                //                     child: Center(
                //                         child: Text('เวลา', style: style2))),
                //                 Container(
                //                     width: _width * 0.2,
                //                     child: Center(
                //                         child: Text('สถานที่', style: style2))),
                //                 Container(
                //                     width: _width * 0.2,
                //                     child: Center(
                //                         child: Text('เเพทย์', style: style2))),
                //               ],
                //             ),
                //           ),
                //           Container(
                //               color: Color.fromARGB(255, 100, 202, 131),
                //               height: _height * 0.04,
                //               child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Container(
                //                         width: _width * 0.2,
                //                         child: Center(
                //                             child: Text(
                //                                 resTojson['todays'][0]['date'],
                //                                 style: style))),
                //                     Container(
                //                         width: _width * 0.2,
                //                         child: Center(
                //                             child: Text(
                //                                 resTojson['todays'][0]['slot'],
                //                                 style: style))),
                //                     Container(
                //                         width: _width * 0.2,
                //                         child: Center(
                //                             child: Text(
                //                                 resTojson['todays'][0]
                //                                     ['care_name'],
                //                                 style: style))),
                //                     Container(
                //                         width: _width * 0.2,
                //                         child: Center(
                //                             child: Text(
                //                                 resTojson['todays'][0]
                //                                     ['doctor_name'],
                //                                 style: style))),
                //                   ]))
                //         ])))
                : Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: _width * 0.2,
                            width: _width * 0.2,
                            child: SvgPicture.asset(
                              'assets/hlsg.svg',
                              fit: BoxFit.fill,
                            ),
                          ),

                          Text('วันนี้ท่านไม่มีกำหนดนัดหมาย',
                              style: styletext2),
                          SizedBox(
                            height: _height * 0.01,
                          ),
                          //  ButtonAddAppointToday()
                        ],
                      ),
                    ),
                  )
            : Container());
  }
}

class ButtonAddAppointToday extends StatefulWidget {
  const ButtonAddAppointToday({super.key});

  @override
  State<ButtonAddAppointToday> createState() => _ButtonAddAppointTodayState();
}

class _ButtonAddAppointTodayState extends State<ButtonAddAppointToday> {
  bool ontap = false;
  void addAppointToday() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/add_appoint_today');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
      'care_unit_id': context.read<DataProvider>().care_unit_id
    });
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เพิ่มนัดหมายสำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));

      setState(() {
        ontap == false;
        Navigator.pop(context);
        Get.offNamed('user_information');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เพิ่มนัดหมายไม่สำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ontap == false
        ? GestureDetector(
            onTap: () {
              setState(() {
                ontap = true;
              });
              addAppointToday();
            },
            child: Container(
                child: Center(
                    child: BoxWidetdew(
              height: 0.06,
              width: 0.35,
              color: Colors.blue,
              radius: 5.0,
              fontSize: 0.04,
              text: 'เพิ่มนัดหมาย',
              textcolor: Colors.white,
            ))),
          )
        : Container(
            height: 0.06, width: 0.35, child: CircularProgressIndicator());
  }
}

class BorDer extends StatefulWidget {
  BorDer({super.key, this.child, this.height, this.width});
  var child;
  var height;
  var width;
  @override
  State<BorDer> createState() => _BorDerState();
}

class _BorDerState extends State<BorDer> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      child: Center(child: widget.child),
      height: widget.height == null ? _height * 0.025 : widget.height,
      width: widget.height == null ? _width * 0.35 : widget.height,
      decoration: BoxDecoration(border: Border.all()),
    );
  }
}

class BoxStatusinform extends StatefulWidget {
  BoxStatusinform({super.key, this.status});
  var status;

  @override
  State<BoxStatusinform> createState() => _BoxStatusinformState();
}

class _BoxStatusinformState extends State<BoxStatusinform> {
  String? status;
  Timer? _timer;
  var resTojson;
  Future<void> check_status() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_video_status');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });

    resTojson = json.decode(res.body);
    if (resTojson['message'] == 'finished' ||
        resTojson['message'] == 'completed') {
      setState(() {
        status = resTojson['message'];
        stop();
      });
    }
  }

  void lop() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        check_status();
        print('รอผลตรวจ');
      });
    });
  }

  void stop() {
    setState(() {
      _timer?.cancel();
    });
  }

  @override
  void initState() {
    status = widget.status;
    if (status == 'end') {
      lop();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        color: Colors.green,
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.04);
    return widget.status != null
        ? Container(
            child: status == 'processing'
                ? Container(
                    child: Column(
                      children: [
                        Text('ถึงคิวเเล้ว', style: style),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrePareVideo()));
                          },
                          child: BoxWidetdew(
                            radius: 2.0,
                            color: Colors.blue,
                            width: 0.3,
                            height: 0.05,
                            text: 'Video',
                            textcolor: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 0.04,
                          ),
                        )
                      ],
                    ),
                  )
                : status == 'end'
                    ? Container(
                        child: Column(
                        children: [
                          Text('การตรวจเสร็จสิ้นกรุณารอผลตรวจ', style: style),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.07,
                            height: MediaQuery.of(context).size.width * 0.07,
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ))
                    : status == 'completed'
                        ? Container(
                            child: Column(
                              children: [
                                Text('รับผลตรวจ', style: style),
                                GestureDetector(
                                  onTap: () {
                                    //api finished
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Print_Exam()));
                                  },
                                  child: BoxWidetdew(
                                    radius: 2.0,
                                    color: Colors.green,
                                    width: 0.3,
                                    height: 0.05,
                                    text: 'ปริ้นผลตรวจ',
                                    textcolor: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 0.04,
                                  ),
                                )
                              ],
                            ),
                          )
                        : status == 'finished'
                            ? Container(
                                child: Column(
                                children: [
                                  Text('รายการวันนี้เสร็จสิ้น', style: style),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Print_Exam()));
                                    },
                                    child: BoxWidetdew(
                                      radius: 2.0,
                                      color: Colors.green,
                                      width: 0.3,
                                      height: 0.05,
                                      text: 'ปริ้นผลตรวจซ้ำ',
                                      textcolor: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 0.04,
                                    ),
                                  )
                                ],
                              ))
                            : Text('--', style: style))
        : Container();
  }
}
