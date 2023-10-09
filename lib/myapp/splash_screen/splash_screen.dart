// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/caregiver/center/center.dart';

import 'package:smart_health/caregiver/home/homeapp.dart';
import 'package:smart_health/caregiver/login/login.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/init_setting.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/setting/setting.dart';
import 'package:smart_health/myapp/splash_screen/function_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_health/station/main_app/app.dart';
//import 'package:smart_health/telemed/home/homeapp.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  late List<RecordSnapshot<int, Map<String, Object?>>> initUser;

  Future<void> getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Device Model: ${androidInfo.model}');
      print('Device ID: ${androidInfo.androidId}');
      setState(() {
        context.read<DataProvider>().appId = androidInfo.androidId.toString();
      });
      // และข้อมูลอื่น ๆ ตามที่คุณต้องการ
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Device Model: ${iosInfo.model}');
      print('Device ID: ${iosInfo.identifierForVendor}');
      setState(() {
        context.read<DataProvider>().appId =
            iosInfo.identifierForVendor.toString();
      });

      // และข้อมูลอื่น ๆ ตามที่คุณต้องการ
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      print('Device Model: ${windowsInfo.computerName}');
      print('Device ID: ${windowsInfo.numberOfCores}');
    }
  }

  void setdata() async {
    Future<bool> data = showDataBaseDatauserApp();
    Future<List<RecordSnapshot<int, Map<String, Object?>>>> recordsdata;
    if (data != null) {
      if (!await data) {
        print('ไม่มีข้อมูล');
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Setting()));
          });
        });
      } else {
        print('มีข้อมูล');
        redDatabase();
      }
    }
  }

  Future<void> redDatabase() async {
    print('กำลังโหลดข้อมูล');
    init = await getAllData();
    initUser = await getAllDataUser();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      context.read<DataProvider>().app = record['myapp'].toString();
      context.read<DataProvider>().name_hospital =
          record['name_hospital'].toString();
      context.read<DataProvider>().platfromURL =
          record['platfromURL'].toString();
      context.read<DataProvider>().care_unit = record['care_unit'].toString();
      context.read<DataProvider>().care_unit_id =
          record['care_unit_id'].toString();
      context.read<DataProvider>().password =
          record['passwordsetting'].toString();
      context.read<DataProvider>().care_unit = record['care_unit'].toString();
    }
    for (RecordSnapshot<int, Map<String, Object?>> record in initUser) {
      context.read<DataProvider>().user_id = record['id'].toString();
      context.read<DataProvider>().user_name = record['name'].toString();
      context.read<DataProvider>().user_code = record['code'].toString();
    }
    print('App');
    print('${context.read<DataProvider>().app}');
    print('${context.read<DataProvider>().name_hospital}');

    print('${context.read<DataProvider>().platfromURL}');

    print('${context.read<DataProvider>().care_unit}');
    print('${context.read<DataProvider>().care_unit_id}');
    print('${context.read<DataProvider>().password}');
    print('user');
    print('${context.read<DataProvider>().user_id}');
    print('${context.read<DataProvider>().user_name}');
    print('${context.read<DataProvider>().user_code}');
    print('โหลดเสร็จเเล้ว');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        redipDatabase();
      });
    });
  }

  Future<void> redipDatabase() async {
    print('กำลังโหลดDevice');
    init = await getdevice();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      context.read<DataProvider>().mapdevices = record['mapdevices'].toString();
    }

    print('ip-device =${context.read<DataProvider>().mapdevices}');
    print('โหลดเสร็จเเล้ว');
    myapp();
  }

  void myapp() {
    if (context.read<DataProvider>().app == 'care_giver') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Center_Caregiver()));
    } else if (context.read<DataProvider>().app == 'station') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => App()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Setting()));
    }
  }

  @override
  void initState() {
    getDeviceInformation();
    print('เข้าหน้าsplash');
    setdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return style_height();
  }

  Widget style_height() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Positioned(
              child: Container(
                  width: _width,
                  height: _height,
                  child: SvgPicture.asset(
                    'assets/splash/backlogo.svg',
                    fit: BoxFit.fill,
                  ))),
          Positioned(
              child: Container(
            width: _width,
            height: _width,
            child: Center(
              child: Container(
                width: _width * 0.8,
                height: _width * 0.8,
                child: SvgPicture.asset('assets/splash/logo.svg'),
              ),
            ),
          )),
          Positioned(
            right: 0,
            child: Container(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 139, 130),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
