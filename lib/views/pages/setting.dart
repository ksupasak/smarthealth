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
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      child: Stack(
        children: [
          Positioned(
              child: BackGroundSmart_Health(
            BackGroundColor: [
              StyleColor.backgroundbegin,
              StyleColor.backgroundend
            ],
          )),
          Positioned(
            child: Scaffold(
                body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('initsetting');
                      },
                      child: BoxWidetdew(
                        color: Colors.green,
                        width: 0.4,
                        height: 0.1,
                        fontSize: 0.05,
                        text: 'Initsetting',
                        textcolor: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('device');
                      },
                      child: BoxWidetdew(
                        color: Colors.green,
                        width: 0.4,
                        height: 0.1,
                        fontSize: 0.05,
                        text: 'Device',
                        textcolor: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Get.offNamed('home');
                      },
                      child: BoxWidetdew(
                        color: Colors.green,
                        width: 0.4,
                        height: 0.1,
                        fontSize: 0.05,
                        text: 'Exit',
                        textcolor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
