import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/provider/provider.dart';

class BoxTimer extends StatefulWidget {
  BoxTimer({super.key});

  @override
  State<BoxTimer> createState() => _BoxTimerState();
}

class _BoxTimerState extends State<BoxTimer> {
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
        data = "${dateTime.day}/" +
            "${dateTime.month}/" +
            "${dateTime.year}-" +
            "${dateTime.hour}:" +
            "${dateTime.minute.toString().padLeft(2, '0')}:" +
            "${dateTime.second.toString().padLeft(2, '0')}";
      });
    });
  }

  void stop() {
    timer?.cancel();
  }

  @override
  void dispose() {
    stop();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: _width * 0.03,
        shadows: [
          Shadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 10)
        ],
        fontWeight: FontWeight.w600);
    return Container(
        width: _width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      width: _width * 0.3,
                      height: _height * 0.03,
                      child: Row(
                        children: [
                          Text(data.toString(), style: style),
                        ],
                      )),
                ],
              )),
            ],
          ),
        ));
  }
}
