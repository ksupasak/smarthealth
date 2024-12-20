import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/myapp/action/playsound.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/device.dart';
import 'package:smart_health/myapp/setting/device/requestLocationPermission.dart';
import 'package:smart_health/myapp/setting/init_setting.dart';
import 'package:smart_health/myapp/setting/talamed_setting.dart';
import 'package:smart_health/myapp/setting/update_license.dart';
import 'package:smart_health/myapp/setting/videotest.dart';
import 'package:smart_health/myapp/widgetdew.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    requestLocationPermission();
    // TODO: implement initState
    super.initState();
  }

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
              const backgrund(),
              Positioned(
                child: Container(
                  width: _width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            keypad_sound();
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
                            keypad_sound();
                          
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  TalamedSetting()));
                          },
                          child: BoxSetting(text: 'Talamed  Setting')),
                      GestureDetector(
                          onTap: () {
                            keypad_sound();
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
                            keypad_sound();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Update_License()));
                          },
                          child: BoxSetting(text: 'Update License')),
                      GestureDetector(
                          onTap: () {
                            keypad_sound();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Test_Video()));
                          },
                          child: BoxSetting(text: 'Video')),
                      GestureDetector(
                          onTap: () {
                            keypad_sound();
                            //  context.read<Datafunction>().playsound();
                            //  Get.offNamed('home');
                            if (context.read<DataProvider>().app == "station") {
                              Navigator.pop(context);
                            }
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
