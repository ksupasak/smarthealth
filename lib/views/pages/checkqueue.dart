import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/local/local.dart';
import 'package:smart_health/provider/provider.dart';

class CheckQueue extends StatefulWidget {
  const CheckQueue({super.key});

  @override
  State<CheckQueue> createState() => _CheckQueueState();
}

class _CheckQueueState extends State<CheckQueue> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: BackGroundSmart_Health(
          BackGroundColor: [
            StyleColor.backgroundbegin,
            StyleColor.backgroundend
          ],
        )),
        Positioned(
            child: ListView(
          children: [
            GestureDetector(
                onTap: (() {
                  addDataInfoToDatabase(DataProvider());
                }),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.amber,
                ))
          ],
        ))
      ],
    );
  }
}
