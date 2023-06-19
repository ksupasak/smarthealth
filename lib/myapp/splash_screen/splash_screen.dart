import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/carecever/home/homeapp.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/init_setting.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/setting/setting.dart';
import 'package:smart_health/myapp/splash_screen/function_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:smart_health/telemed/home/homeapp.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  late List<RecordSnapshot<int, Map<String, Object?>>> init;

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

    print('${context.read<DataProvider>().app}');
    print('${context.read<DataProvider>().name_hospital}');

    print('${context.read<DataProvider>().platfromURL}');

    print('${context.read<DataProvider>().care_unit}');
    print('${context.read<DataProvider>().care_unit_id}');
    print('${context.read<DataProvider>().password}');
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
      //carecevier,telemed
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeCareCevier()));
    } else if (context.read<DataProvider>().app == 'station') {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => HomeTelemed()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Setting()));
    }
  }

  @override
  void initState() {
    print('เข้าหน้าsplash');
    setdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return _width > _height ? style_width() : style_height();
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

  Widget style_width() {
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
                  'assets/splash/backlogo2.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: _width,
                height: _width,
                child: Center(
                  child: Container(
                    width: _height * 0.8,
                    height: _height * 0.8,
                    child: SvgPicture.asset('assets/splash/logo.svg'),
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
