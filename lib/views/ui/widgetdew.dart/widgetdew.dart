import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
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
    return Positioned(
        child: BackGroundSmart_Health(
      BackGroundColor: [
        Color.fromARGB(255, 255, 255, 255),
        StyleColor.backgroundbegin,
        StyleColor.backgroundbegin,
      ],
    ));
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
        color: Color.fromARGB(255, 20, 142, 130),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    return Container(
      height: _height * 0.08,
      width: _width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Care Unit', style: style),
          Text(data.toString(), style: style)
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
      this.radius});
  var color;
  var text;
  var width;
  var height;
  var fontSize;
  var textcolor;
  var fontWeight;
  var radius;
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
        borderRadius: widget.radius == null
            ? BorderRadius.circular(100)
            : BorderRadius.circular(widget.radius),
        color: widget.color == null ? Colors.amber : widget.color,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: widget.color == null
                ? Color.fromARGB(0, 0, 0, 0)
                : widget.color,
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

    return Container(
      width: _width * 0.9,
      height: _height * 0.1,
      child: Center(
        child: Text(
          context.read<DataProvider>().name_hospital,
          style: style_text(
              sized: _width * context.read<DataProvider>().sized_name_hospital,
              colors: context.read<DataProvider>().color_name_hospital,
              fontWeight: context.read<DataProvider>().fontWeight_name_hospital,
              shadow: [
                Shadow(
                  color: context.read<DataProvider>().shadow_name_hospital,
                  blurRadius: 10,
                )
              ]),
        ),
      ),
    );
  }
}

class BoxRecord extends StatefulWidget {
  BoxRecord({super.key, this.keyvavlue, this.texthead});
  var keyvavlue;
  var texthead;
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
                    color: widget.color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: widget.color == null
                            ? Color.fromARGB(0, 0, 0, 0)
                            : widget.color,
                      ),
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
              child: Image.network(
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
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.white,
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
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.white,
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
  Future<void> checkt_queue() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      textqueue = resTojson["queue_number"];
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
                                text: '',
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
            : Container()
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
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
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
        fontSize: _width * 0.04);
    TextStyle styletext3 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    TextStyle styletext4 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        color: Color.fromARGB(255, 28, 1, 91),
        fontSize: _width * 0.03);
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
                                  height: _height * 0.04,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
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
      width: _width * 0.15,
      child: Center(child: widget.child),
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
  String message = '';
  String queue = '';
  Future<void> get_queue() async {
    var url = Uri.parse('https://emr-life.com/clinic_master/clinic/Api/list_q');
    var res = await http.post(url, body: {
      'care_unit_id': '63d7a282790f9bc85700000e',
    });
    setState(() {
      resTojson = json.decode(res.body);
      queue = resTojson['queue_number'];
      message = resTojson['message'];
    });
  }

  void lop_queue() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        get_queue();
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

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      child: Center(
          child: Container(
        width: _width * 0.7,
        height: _height * 0.08,
        decoration: BoxDecoration(
            color: resTojson == null
                ? Color.fromARGB(255, 233, 233, 233)
                : message != 'no queue'
                    ? Color.fromARGB(255, 232, 200, 73)
                    : Color.fromARGB(255, 233, 233, 233),
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(width: 2, color: Color.fromARGB(255, 82, 82, 82))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                resTojson == null
                    ? Text(
                        '- -',
                        style: TextStyle(
                            fontFamily: context.read<DataProvider>().fontFamily,
                            color: Colors.white,
                            fontSize: _width * 0.05),
                      )
                    : message != 'no queue'
                        ? Text(
                            'คิวที่',
                            style: TextStyle(
                                fontFamily:
                                    context.read<DataProvider>().fontFamily,
                                color: Colors.white,
                                fontSize: _width * 0.05),
                          )
                        : Text(
                            '- -',
                            style: TextStyle(
                                fontFamily:
                                    context.read<DataProvider>().fontFamily,
                                color: Colors.white,
                                fontSize: _width * 0.05),
                          ),
                SizedBox(
                  width: _width * 0.05,
                ),
                message == 'no queue'
                    ? Text(
                        '- -',
                        style: TextStyle(
                            fontFamily: context.read<DataProvider>().fontFamily,
                            color: Colors.white,
                            fontSize: _width * 0.05),
                      )
                    : Text(
                        queue,
                        style: TextStyle(
                            fontFamily: context.read<DataProvider>().fontFamily,
                            color: Colors.white,
                            fontSize: _width * 0.05),
                      ),
              ],
            ),
          ],
        ),
      )),
    );
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
        fontSize: _width * 0.05,
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
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
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
        child: Container(
          height: _height * 0.4,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          child:
                              Center(child: Text('ไม่มีรายการ', style: style)))
                    ]))
              : Container(),
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
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.04,
        color: Colors.white,
        // fontFamily: 'Prompt',
        fontWeight: FontWeight.w600);
    return widget.text == null
        ? Text('')
        : Text(
            widget.text.toString(),
            style: style,
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
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
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
        color: Colors.red,
        fontSize: _width * 0.04);
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
        height: _height * 0.2,
        width: _width,
        child: resTojson != null
            ? resTojson['todays'].length != 0
                ? Center(
                    child: Container(
                      height: _height * 0.15,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(150, 222, 255, 248),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Text('การนัดหมายวันนี้', style: styletext3),
                          Container(
                            color: Color.fromARGB(255, 115, 250, 221),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text('วันที่', style: style2))),
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text('เวลา', style: style2))),
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text('สถานที่', style: style2))),
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text('เเพทย์', style: style2))),
                              ],
                            ),
                          ),
                          Container(
                            color: Color.fromARGB(255, 100, 202, 131),
                            height: _height * 0.04,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text(
                                            resTojson['todays'][0]['date'],
                                            style: style))),
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text(
                                            resTojson['todays'][0]['slot'],
                                            style: style))),
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text(
                                            resTojson['todays'][0]['care_name'],
                                            style: style))),
                                Container(
                                    width: _width * 0.2,
                                    child: Center(
                                        child: Text(
                                            resTojson['todays'][0]
                                                ['doctor_name'],
                                            style: style))),
                              ],
                            ),
                          ),
                          // Container(
                          //   width: _width * 0.7,
                          //   child:
                          //   Row(
                          //     children: [
                          //       Container(
                          //         width: _width * 0.35,
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             BorDer(
                          //                 child: Text("โรงพยาบาล",
                          //                     style: styletext4)),
                          //             BorDer(
                          //                 child: Text("วันที่",
                          //                     style: styletext4)),
                          //             BorDer(
                          //                 child: Text("คุณหมอ",
                          //                     style: styletext4)),
                          //             BorDer(
                          //                 child:
                          //                     Text("เวลา", style: styletext4)),
                          //           ],
                          //         ),
                          //       ),
                          //       Container(
                          //         width: _width * 0.35,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           children: [
                          //             BorDer(
                          //               child: Text(
                          //                   "${resTojson['todays'][0]['care_name']}",
                          //                   style: styletext),
                          //             ),
                          //             BorDer(
                          //               child: Text(
                          //                   "${resTojson['todays'][0]['date']}",
                          //                   style: styletext),
                          //             ),
                          //             BorDer(
                          //               child: Text(
                          //                   "${resTojson['todays'][0]['doctor_name']}",
                          //                   style: styletext),
                          //             ),
                          //             BorDer(
                          //               child: Text(
                          //                   "${resTojson['todays'][0]['slot']}",
                          //                   style: styletext),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),

                          // )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'คุณไม่มีนัดหมายในวันนี้',
                      style: styletext2,
                    ),
                  )
            : Container());
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
