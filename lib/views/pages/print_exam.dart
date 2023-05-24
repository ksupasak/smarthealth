import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/capability_profile.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/generator.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_column.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_styles.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/provider/provider_function.dart';
import 'package:smart_health/test/esm_printer.dart';
import 'package:http/http.dart' as http;
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class Print_Exam extends StatefulWidget {
  const Print_Exam({super.key});

  @override
  State<Print_Exam> createState() => _Print_ExamState();
}

class _Print_ExamState extends State<Print_Exam> {
  String datatime = "";
  ESMPrinter? printer;
  var resTojson;
  String doctor_note = '--';
  String dx = '--';
  BluetoothPrinter? selectedPrinter;
  var devices = <BluetoothPrinter>[];
  List default_deivces = [];

  Future<void> finished() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/finish_appoint');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  Future<void> get_exam() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      doctor_note = resTojson['data']['doctor_note'];
      dx = resTojson['data']['dx'];
      if (resTojson != null) {
        startTimer();
        Deviceprint();
      }
    });
  }

  void Deviceprint() {
    debugPrint('call print test');
    if (selectedPrinter == null) {
      for (final device in devices) {
        var vendor_id = device.vendorId;
        var product_id = device.productId;
        debugPrint('scan for ${vendor_id} ${product_id}');
        if (default_deivces != null) {
          for (final s in default_deivces) {
            if (s['vendor_id'] == vendor_id && s['product_id'] == product_id) {
              debugPrint('found ');
              selectDevice(device);
            }
          }
        }
      }
    }

    if (selectDevice != null) {
      printexam();
    }
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance
            .disconnect(type: selectedPrinter!.typePrinter);
      }
    }
    selectedPrinter = device;
  }

  void printexam() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.text(context.read<DataProvider>().name_hospital,
        styles: const PosStyles(align: PosAlign.center));
    // bytes += generator.text("Examination",
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         width: PosTextSize.size3,
    //         height: PosTextSize.size3,
    //         fontType: PosFontType.fontA));
    bytes += generator.text('Examination',
        styles: const PosStyles(
            width: PosTextSize.size1, height: PosTextSize.size1));
    bytes += generator.text('\n');
    bytes += generator.text('Doctor  :  pairot tanyajasesn');
    bytes += generator.text('Results :  ${dx}');
    bytes += generator.text('        :  ${doctor_note}');
    printer?.printTest(bytes);
  }

  int remainingSeconds = 5;
  Timer? timer;
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        remainingSeconds--;
      });

      if (remainingSeconds == 0) {
        timer!.cancel();
        Get.offNamed('home');
      }
    });
  }

  @override
  void initState() {
    finished();

    printer = ESMPrinter([
      {'vendor_id': '1137', 'product_id': '85'}
    ]);
    get_exam();
    setState(() {
      var dateTime = DateTime.now();
      datatime = "${dateTime.hour}: " +
          "${dateTime.minute}  ${dateTime.day}/${dateTime.month}/${dateTime.year}";
    });
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
          backgrund(),
          Positioned(
              child: Container(
            width: _width,
            height: _height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: _height * 0.5,
                  width: _width * 0.8,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(height: _height * 0.01),
                Text(
                  'กำลังออกใน: $remainingSeconds วินาที',
                  style: TextStyle(
                      fontSize: _width * 0.04,
                      fontFamily: context.read<DataProvider>().fontFamily),
                ),
                // GestureDetector(
                //   onTap: () {
                //     context.read<Datafunction>().playsound();

                //     Deviceprint();
                //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //         content: Container(
                //             width: MediaQuery.of(context).size.width,
                //             child: Center(
                //                 child: Text(
                //               'ปริ้นผลตรวจ',
                //               style: TextStyle(
                //                   fontFamily:
                //                       context.read<DataProvider>().fontFamily,
                //                   fontSize:
                //                       MediaQuery.of(context).size.width * 0.03),
                //             )))));
                //   },
                //   child: BoxWidetdew(
                //       radius: 10.0,
                //       color: Colors.green,
                //       height: 0.06,
                //       width: 0.4,
                //       text: 'ปริ้นผลตรวจซ้ำ',
                //       fontSize: 0.05,
                //       textcolor: Colors.white),
                // ),
                // SizedBox(height: _height * 0.02),
                // GestureDetector(
                //   onTap: () {
                //     context.read<Datafunction>().playsound();
                //     Get.offNamed('user_information');
                //   },
                //   child: BoxWidetdew(
                //       radius: 10.0,
                //       color: Colors.red,
                //       height: 0.06,
                //       width: 0.4,
                //       text: 'กลับ',
                //       fontSize: 0.05,
                //       textcolor: Colors.white),
                // ),
              ],
            ),
          ))
        ],
      )),
    );
  }
}
