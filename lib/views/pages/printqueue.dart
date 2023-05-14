import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';

import 'package:smart_health/provider/provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';
import 'package:smart_health/provider/provider_function.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/test/esm_printer.dart';
import 'package:smart_health/test/image_utils.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:image/image.dart' as img;

class PrintQueue extends StatefulWidget {
  const PrintQueue({super.key});

  @override
  State<PrintQueue> createState() => _PrintQueueState();
}

class _PrintQueueState extends State<PrintQueue> {
  var resTojson;
  BluetoothPrinter? selectedPrinter;
  DateTime dateTime = DateTime.parse('0000-00-00 00:00');
  String datatime = "";
  ESMPrinter? printer;
  var devices = <BluetoothPrinter>[];
  List default_deivces = [];
  Future<void> checkt_queue() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
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
    // setState(() {});
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
      printqueue();
    }
  }

  void printqueue() async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');

    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text(context.read<DataProvider>().name_hospital,
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text('Queue',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            fontType: PosFontType.fontA));
    bytes += generator.text(resTojson['queue_number'],
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size3,
            height: PosTextSize.size3,
            fontType: PosFontType.fontA));
    bytes += generator.row([
      PosColumn(
          width: 2,
          text: 'height',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 2,
          text: 'weight',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 2,
          text: 'temp',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 2,
          text: 'sys',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 2,
          text: 'dia',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
      PosColumn(
          width: 2,
          text: 'spo2',
          styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
    ]);
    // bytes += generator.text(
    //     '${resTojson['personal']['first_name']}   ${resTojson['personal']['last_name']}',
    //     styles: const PosStyles(align: PosAlign.center, codeTable: '255'));
    //  printer?.printTest();
    printer?.printEscPos(bytes, generator);
  }

  @override
  void initState() {
    printer = ESMPrinter([
      {'vendor_id': '1137', 'product_id': '85'}
    ]);
    checkt_queue();
    setState(() {
      dateTime = DateTime.now();
      datatime = "เวลา ${dateTime.hour}: " + "${dateTime.minute}";
    });
    super.initState();
  }

  Widget queue() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle stylequeue = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.07);
    TextStyle name_hospital = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.05);
    TextStyle text = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.02);
    return Container(
      height: _height * 0.5,
      width: _width * 0.8,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: _width * 0.1),
              Text(context.read<DataProvider>().name_hospital,
                  style: name_hospital),
              Container(
                  width: _width * 0.1,
                  height: _height * 0.04,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        datatime,
                        style: TextStyle(
                            fontFamily: context.read<DataProvider>().fontFamily,
                            fontSize: _width * 0.015),
                      ),
                    ],
                  )),
            ],
          ),
          Text('คิวที่', style: stylequeue),
          Text(resTojson['queue_number'], style: stylequeue),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${resTojson['personal']['first_name']}  ', style: text),
            Text('  ${resTojson['personal']['last_name']}', style: text)
          ]),
          Container(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Health(child: Text('height', style: text)),
                      Health(child: Text('weight', style: text)),
                      Health(child: Text('temp', style: text)),
                      Health(child: Text('sys.', style: text)),
                      Health(child: Text('dia', style: text)),
                      Health(child: Text('spo2', style: text)),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      resTojson['health_records'][0]['height'] == null
                          ? Health(child: Text(' - '))
                          : Health(
                              child: Text(
                                  '${resTojson['health_records'][0]['height']}',
                                  style: text)),
                      resTojson['health_records'][0]['weight'] == null
                          ? Health(child: Text(' - '))
                          : Health(
                              child: Text(
                                  '${resTojson['health_records'][0]['weight']}',
                                  style: text),
                            ),
                      resTojson['health_records'][0]['temp'] == null
                          ? Health(child: Text(' - '))
                          : Health(
                              child: Text(
                                  '${resTojson['health_records'][0]['temp']}',
                                  style: text),
                            ),
                      resTojson['health_records'][0]['bp_dia'] == null
                          ? Health(child: Text(' - '))
                          : Health(
                              child: Text(
                                  '${resTojson['health_records'][0]['bp_dia']}',
                                  style: text),
                            ),
                      resTojson['health_records'][0]['bp_sys'] == null
                          ? Health(child: Text(' - '))
                          : Health(
                              child: Text(
                                  '${resTojson['health_records'][0]['bp_sys']}',
                                  style: text),
                            ),
                      resTojson['health_records'][0]['spo2'] == null
                          ? Health(child: Text(' - '))
                          : Health(
                              child: Text(
                                  '${resTojson['health_records'][0]['spo2']}',
                                  style: text),
                            ),
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          backgrund(),
          Positioned(
              child: Center(
                  child: Container(
                      child: Container(
            height: _height * 0.8,
            width: _width * 0.8,
            child: ListView(
              children: [
                resTojson == null
                    ? Container(height: _height * 0.5, width: _width * 0.8)
                    : queue(),
                SizedBox(height: _height * 0.05),
                GestureDetector(
                  onTap: () {
                    context.read<Datafunction>().playsound();
                    //  print2();
                    //  printer?.printTest();
                    Deviceprint();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Text(
                              'printqueue',
                              style: TextStyle(
                                  fontFamily:
                                      context.read<DataProvider>().fontFamily,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03),
                            )))));
                    print('ปริ้น');
                  },
                  child: BoxWidetdew(
                      radius: 10.0,
                      color: Colors.green,
                      height: 0.06,
                      width: 0.4,
                      text: 'ปริ้นอีกครั้ง',
                      fontSize: 0.05,
                      textcolor: Colors.white),
                ),
                SizedBox(height: _height * 0.05),
                GestureDetector(
                  onTap: () {
                    context.read<Datafunction>().playsound();
                    Navigator.pop(context);
                  },
                  child: BoxWidetdew(
                      radius: 10.0,
                      color: Colors.red,
                      height: 0.06,
                      width: 0.4,
                      text: 'กลับ',
                      fontSize: 0.05,
                      textcolor: Colors.white),
                ),
              ],
            ),
          )))),
        ]),
      ),
    );
  }
}

class Health extends StatefulWidget {
  Health({super.key, required this.child});
  Widget child;
  @override
  State<Health> createState() => _HealthState();
}

class _HealthState extends State<Health> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width * 0.13,
      child: Center(child: widget.child),
    );
  }
}
