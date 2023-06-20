import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/init_setting.dart';
import 'package:smart_health/myapp/setting/setting.dart';

class BoxHead extends StatefulWidget {
  const BoxHead({super.key});

  @override
  State<BoxHead> createState() => _BoxHeadState();
}

class _BoxHeadState extends State<BoxHead> {
  DateTime dateTime = DateTime.parse('0000-00-00 00:00');
  String data = "";
  Timer? timer;
  Color _color = Colors.white;
  @override
  void initState() {
    start();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        dateTime = DateTime.now();
        data = "${dateTime.hour}:" +
            "${dateTime.minute.toString().padLeft(2, '0')}:" +
            "${dateTime.second.toString().padLeft(2, '0')}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return _height > _width ? style_height() : style_width();
  }

  Widget style_height() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width,
      child: Row(
        children: [
          Container(
            width: _width * 0.85,
            height: _height * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  context.read<DataProvider>().name_hospital != null
                      ? Text(
                          '${context.read<DataProvider>().name_hospital}',
                          style: TextStyle(
                              fontSize: _width * 0.04,
                              fontFamily: context.read<DataProvider>().family,
                              color: _color),
                        )
                      : Container(),
                  context.read<DataProvider>().care_unit != null
                      ? Text(
                          '${context.read<DataProvider>().care_unit}',
                          style: TextStyle(
                              fontSize: _width * 0.035,
                              fontFamily: context.read<DataProvider>().family,
                              color: _color),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => Setting())));
            },
            child: Container(
              width: _width * 0.15,
              child: Text(data,
                  style: TextStyle(
                      fontSize: _height * 0.015,
                      fontFamily: context.read<DataProvider>().family,
                      color: _color)),
            ),
          ),
        ],
      ),
    );
  }

  Widget style_width() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width,
      child: Row(
        children: [
          Container(
            width: _width * 0.85,
            height: _height * 0.2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  context.read<DataProvider>().name_hospital != null
                      ? Text(
                          '${context.read<DataProvider>().name_hospital}',
                          style: TextStyle(
                              fontSize: _height * 0.04,
                              fontFamily: context.read<DataProvider>().family,
                              color: _color),
                        )
                      : Container(),
                  context.read<DataProvider>().care_unit != null
                      ? Text(
                          '${context.read<DataProvider>().care_unit}',
                          style: TextStyle(
                              fontSize: _height * 0.035,
                              fontFamily: context.read<DataProvider>().family,
                              color: _color),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Container(
            width: _width * 0.15,
            child: Text(data,
                style: TextStyle(
                    fontSize: _height * 0.025,
                    fontFamily: context.read<DataProvider>().family,
                    color: _color)),
          ),
        ],
      ),
    );
  }
}
