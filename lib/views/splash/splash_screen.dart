import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/device/ad_ua651ble.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/device/hj_narigmed.dart';
import 'package:smart_health/device/mibfs.dart';
import 'package:smart_health/local/local.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/test/esm_idcard.dart';
import 'package:smart_health/views/pages/home.dart';
import 'package:smart_health/views/pages/numpad.dart';
import 'package:smart_health/views/pages/user_information2.dart';
import 'package:smart_health/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  var name_hospital;
  var platfromURL;
  var checkqueueURL;
  var care_unit_id;
  var passwordsetting;
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
      checkqueueURL = record['checkqueueURL'].toString();
      care_unit_id = record['care_unit_id'].toString();
      passwordsetting = record['passwordsetting'].toString();
      device = record['device'];
      print(name_hospital);
      print(platfromURL);
      print(checkqueueURL);
      print(care_unit_id);
      print(passwordsetting);
      // for (var devices in device) {
      // print(devices);
      // }
    }
    safe();
  }

  void safe() async {
    context.read<DataProvider>().name_hospital = name_hospital;
    context.read<DataProvider>().platfromURL = platfromURL;
    context.read<DataProvider>().checkqueueURL = checkqueueURL;
    context.read<DataProvider>().care_unit_id = care_unit_id;
    context.read<DataProvider>().passwordsetting = passwordsetting;
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
      body: Homeapp(),
    );
  }
}
