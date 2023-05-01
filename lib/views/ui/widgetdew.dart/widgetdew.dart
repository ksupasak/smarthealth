import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        StyleColor.backgroundend,
        StyleColor.backgroundbegin,
      ],
    ));
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
                widget.text,
                style: TextStyle(
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
                  style: TextStyle(fontSize: _width * 0.03, color: teamcolor)),
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
  BoxQueue({super.key, this.queue});
  var queue;
  @override
  State<BoxQueue> createState() => _BoxQueueState();
}

class _BoxQueueState extends State<BoxQueue> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Color.fromARGB(255, 2, 72, 113)),
          ],
          color: Color.fromARGB(255, 2, 72, 113),
          borderRadius: BorderRadius.circular(10)),
      width: _width * 0.8,
      height: _height * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BoxWidetdew(
                width: 0.38,
                height: 0.05,
                color: Colors.blue,
                radius: 10.0,
                fontSize: 0.04,
                text: 'หมายเลขคิวของคุณ',
                textcolor: Colors.white,
              ),
              BoxWidetdew(
                width: 0.38,
                height: 0.05,
                color: Colors.white,
                radius: 10.0,
                fontSize: 0.04,
                text: widget.queue == null ? '' : widget.queue,
                textcolor: Color.fromARGB(255, 43, 179, 161),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BoxWidetdew(
                width: 0.38,
                height: 0.05,
                color: Colors.blue,
                radius: 10.0,
                fontSize: 0.04,
                text: 'รออีก(คิว)',
                textcolor: Colors.white,
              ),
              BoxWidetdew(
                width: 0.38,
                height: 0.05,
                color: Colors.white,
                radius: 10.0,
                fontSize: 0.04,
                text: '',
                textcolor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BoxShoHealth_Records extends StatefulWidget {
  BoxShoHealth_Records({
    super.key,
    this.height,
    this.weight,
    this.sys,
    this.dia,
    this.pulse_rate,
    this.temp,
    this.spo2,
    this.fbs,
    this.si,
    this.uric,
  });
  var height;
  var weight;
  var sys;
  var dia; //
  var pulse_rate;
  var temp; //
  var spo2;
  var fbs;
  var si;
  var uric;

  @override
  State<BoxShoHealth_Records> createState() => _BoxShoHealth_RecordsState();
}

class _BoxShoHealth_RecordsState extends State<BoxShoHealth_Records> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle styletext =
        TextStyle(color: Colors.white, fontSize: _width * 0.04);
    TextStyle styletext2 = TextStyle(
        color: Color.fromARGB(255, 12, 172, 153), fontSize: _width * 0.04);
    return Container(
      width: _width,
      height: _height * 0.08,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            color: Color.fromARGB(255, 95, 182, 167),
            height: _height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('height', style: styletext),
                Text('weight', style: styletext),
                Text('sys.', style: styletext),
                Text('dia', style: styletext),
                Text('temp', style: styletext),
                Text('spo2', style: styletext),
                Text('fbs', style: styletext),
                Text('si', style: styletext),
                Text('uric', style: styletext),
                Text('pulse_rate.', style: styletext),
              ],
            ),
          ),
          Container(
            height: _height * 0.04,
            color: Color.fromARGB(255, 197, 230, 225),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.height == 'null'
                    ? Text('-')
                    : Text('${widget.height}', style: styletext2),
                widget.weight == 'null'
                    ? Text('-')
                    : Text('${widget.weight}', style: styletext2),
                widget.sys == 'null'
                    ? Text('-')
                    : Text('${widget.sys}', style: styletext2),
                widget.dia == 'null'
                    ? Text('-')
                    : Text('${widget.dia}', style: styletext2),
                widget.temp == 'null'
                    ? Text('-')
                    : Text('${widget.temp}', style: styletext2),
                widget.spo2 == 'null'
                    ? Text('-')
                    : Text('${widget.spo2}', style: styletext2),
                widget.fbs == 'null'
                    ? Text('-')
                    : Text('${widget.fbs}', style: styletext2),
                widget.si == 'null'
                    ? Text('-')
                    : Text('${widget.si}', style: styletext2),
                widget.uric == 'null'
                    ? Text('-')
                    : Text('${widget.uric}', style: styletext2),
                widget.pulse_rate == 'null'
                    ? Text('-')
                    : Text('${widget.pulse_rate}', style: styletext2),
              ],
            ),
          ),
        ],
      ),
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'คิวที่',
                style: TextStyle(color: Colors.white, fontSize: _width * 0.05),
              ),
              SizedBox(
                width: _width * 0.05,
              ),
              message == 'no queue'
                  ? Text(
                      '- -',
                      style: TextStyle(
                          color: Colors.white, fontSize: _width * 0.05),
                    )
                  : Text(
                      queue,
                      style: TextStyle(
                          color: Colors.white, fontSize: _width * 0.05),
                    ),
            ],
          ),
        ],
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
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.05,
        fontWeight: FontWeight.w800);
    TextStyle style2 = TextStyle(
        color: Color.fromARGB(255, 0, 73, 129),
        fontSize: _width * 0.045,
        fontWeight: FontWeight.w600);
    return Container(
      child: Column(
        children: [
          Text("การนัดหมาย", style: style),
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
  BoxAppointments({super.key, this.list_appointments});
  var list_appointments;
  @override
  State<BoxAppointments> createState() => _BoxAppointmentsState();
}

class _BoxAppointmentsState extends State<BoxAppointments> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        color: Color.fromARGB(255, 69, 0, 0),
        fontSize: _width * 0.035,
        fontWeight: FontWeight.w800);
    return Container(
        width: _width,
        child: Container(
          height: _height * 0.12,
          child: widget.list_appointments != null
              ? ListView.builder(
                  itemCount: widget.list_appointments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Color.fromARGB(255, 219, 246, 240),
                      height: _height * 0.04,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: _width * 0.25,
                              child: Center(
                                  child: Text(
                                      widget.list_appointments[index]['date'],
                                      style: style))),
                          Container(
                              width: _width * 0.25,
                              child: Center(
                                  child: Text(
                                      widget.list_appointments[index]['slot'],
                                      style: style))),
                          Container(
                              width: _width * 0.25,
                              child: Center(
                                  child: Text(
                                      widget.list_appointments[index]
                                          ['care_name'],
                                      style: style))),
                          Container(
                              width: _width * 0.25,
                              child: Center(
                                  child: Text(
                                      widget.list_appointments[index]
                                          ['doctor_name'],
                                      style: style))),
                        ],
                      ),
                    );
                  },
                )
              : SizedBox(),
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
        fontSize: _width * 0.05, color: Color.fromARGB(255, 19, 100, 92));
    TextStyle style2 =
        TextStyle(fontSize: _width * 0.05, color: Color.fromARGB(255, 0, 0, 0));

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
