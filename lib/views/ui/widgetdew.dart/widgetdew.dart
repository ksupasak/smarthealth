import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/widget_decorate/WidgetDecorate.dart';

class BoxWidetdew extends StatefulWidget {
  BoxWidetdew({
    super.key,
    this.color,
    this.text,
    this.height,
    this.width,
    this.fontSize,
    this.textcolor,
    this.fontWeight,
  });
  var color;
  var text;
  var width;
  var height;
  var fontSize;
  var textcolor;
  var fontWeight;
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
        borderRadius: BorderRadius.circular(100),
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
                  fontSize: widget.fontSize == null ? 20 : widget.fontSize,
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
