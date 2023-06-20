import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smart_health/telemed/home/box_queue/boxqueue.dart';
import 'package:smart_health/telemed/widget/backgrund.dart';
import 'package:smart_health/telemed/widget/boxhead.dart';
import 'package:smart_health/telemed/widget/numpad.dart';

class HomeTelemed extends StatefulWidget {
  const HomeTelemed({super.key});

  @override
  State<HomeTelemed> createState() => _HomeTelemedState();
}

class _HomeTelemedState extends State<HomeTelemed> {
  @override
  void initState() {
    print('เข้าหน้าHomeTelemed');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Positioned(child: BackGrund()),
          Positioned(child: _width > _height ? style_width() : style_height())
        ],
      )),
    );
  }

  Widget style_height() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height,
      width: _width,
      child: ListView(children: [
        Container(child: BoxHead()),
        Container(child: BoxQueue()),
        Container(child: Numpad())
      ]),
    );
  }

  Widget style_width() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height,
      width: _width,
      child: ListView(children: [
        Container(child: BoxHead()),
        Container(child: BoxQueue()),
        //  Container(child: Numpad())
      ]),
    );
  }
}
