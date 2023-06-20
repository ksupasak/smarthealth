import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/station/device/ad_ua651ble.dart';
import 'package:smart_health/station/device/hc08.dart';
import 'package:smart_health/station/device/hj_narigmed.dart';
import 'package:smart_health/station/device/mibfs.dart';
import 'package:smart_health/station/local/local.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/provider/provider_function.dart';
import 'package:smart_health/station/test/esm_idcard.dart';
import 'package:smart_health/station/views/pages/home.dart';
import 'package:smart_health/station/views/pages/numpad.dart';
import 'package:smart_health/station/views/pages/user_information2.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  var name_hospital;
  var care_unit;
  var care_unit_id;
  var platfromURL;
  var passwordsetting;
  var myapp;
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  bool status = false;
  final idcard = Numpad();
  ESMIDCard? reader;
  Stream<String>? entry;
  Timer? readingtime;
  Timer? reading;

  Future<void> printDatabase() async {
    var device;

    init = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      name_hospital = record['name_hospital'].toString();
      platfromURL = record['platfromURL'].toString();
      care_unit_id = record['care_unit_id'].toString();
      passwordsetting = record['passwordsetting'].toString();
      myapp = record['myapp'].toString();
      care_unit = record['care_unit'].toString();
      device = record['device'];
      print(name_hospital);
      print(platfromURL);
      print(care_unit_id);
      print(care_unit);
      print(passwordsetting);
      safe();
    }
  }

  void safe() {
    context.read<DataProvider>().name_hospital = name_hospital;
    context.read<DataProvider>().platfromURL = platfromURL;
    context.read<DataProvider>().care_unit_id = care_unit_id;
    context.read<DataProvider>().passwordsetting = passwordsetting;
    context.read<DataProvider>().care_unit = care_unit;
    context.read<DataProvider>().myapp = myapp;
    setState(() {
      addDataInfoToDatabase(context.read<DataProvider>());
    });
  }

  @override
  void dispose() {
    // readingtime?.cancel();
    // reading?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    printDatabase();
    Future.delayed(const Duration(seconds: 4), () {
      Get.offAllNamed('home');
    });
    //scanTimer(4500);
    // bleScan(); //
    //  TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: //Homeapp()
            Stack(
      children: [
        Positioned(
          child: Center(
            child: Container(
              width: _width,
              height: _height,
              child: Container(
                height: _height * 0.2,
                width: _width,
                child: SvgPicture.asset(
                  'assets/splash.svg',
                  fit: BoxFit.fill,
                ),
              ),

              // CircularProgressIndicator(),
            ),
          ),
        ),
        Positioned(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: _width * 0.1,
                      width: _width * 0.1,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 139, 130),
                      )),
                ],
              ),
              SizedBox(height: _width * 0.1, width: _width * 0.1),
            ],
          ),
        )
      ],
    ));
  }
}
