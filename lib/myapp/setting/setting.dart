import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/setting/device.dart';
import 'package:smart_health/myapp/setting/init_setting.dart';
import 'package:smart_health/myapp/widgetdew.dart';

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
                            //    context.read<Datafunction>().playsound();
                            //  Get.toNamed('initsetting');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Initsetting()));
                          },
                          child: BoxSetting(text: 'Init Setting')),
                      GestureDetector(
                          onTap: () {
                            //   context.read<Datafunction>().playsound();
                            //   Get.toNamed('device');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Device()));
                          },
                          child: BoxSetting(text: 'Device')),
                      GestureDetector(
                          onTap: () {
                            //  context.read<Datafunction>().playsound();
                            //  Get.offNamed('home');
                            Navigator.pop(context);
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
