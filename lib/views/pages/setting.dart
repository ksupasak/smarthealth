import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: (() {
            FocusScope.of(context).requestFocus(FocusNode());
          }),
          child: Stack(
            children: [
              backgrund(),
              Positioned(
                child: Container(
                  width: _width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.toNamed('initsetting');
                          },
                          child: BoxSetting(text: 'Initsetting')),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed('device');
                          },
                          child: BoxSetting(text: 'Device')),
                      GestureDetector(
                          onTap: () {
                            Get.offNamed('home');
                          },
                          child: BoxSetting(text: 'Exit')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
