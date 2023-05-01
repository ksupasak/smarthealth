import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class PrintQueue extends StatefulWidget {
  const PrintQueue({super.key});

  @override
  State<PrintQueue> createState() => _PrintQueueState();
}

class _PrintQueueState extends State<PrintQueue> {
  var resTojson;

  Future<File> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 200,
                  ),
                  pw.Text(
                    '${resTojson['todays'][0]['care_name'].toString()} ',
                    style: pw.TextStyle(fontSize: 20),
                  ),
                  pw.Container(
                      width: 200,
                      height: 100,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                              '${resTojson['todays'][0]['slot'].toString()} '),
                        ],
                      )),
                  pw.Text(
                    '${resTojson['todays'][0]['queue_number'].toString()}',
                    style: pw.TextStyle(fontSize: 26),
                  ),
                  pw.Container(
                    width: 200,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              ' น้ำหนัก ${resTojson['health_records'][0]['weight']} '),
                          pw.Text(
                              ' อุณหภูมิ ${resTojson['health_records'][0]['temp']} '),
                          pw.Text(
                              ' SYS. ${resTojson['health_records'][0]['bp_sys']} '),
                          pw.Text(
                              ' DIA. ${resTojson['health_records'][0]['bp_dia']} '),
                          pw.Text(
                              ' PUL. ${resTojson['health_records'][0]['pulse_rate']} '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]));
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  void safe() async {
    final pdf = await generatePdf();
    final file = File('path/to/your/file.pdf');
    await file.writeAsBytes(await pdf.readAsBytes());
  }

  @override
  void initState() {
    resTojson = context.read<DataProvider>().resTojson;
    generatePdf();
    // print(context.read<DataProvider>().resTojson.toString());
    // print('${resTojson['care_name'].toString()}');
    // TODO: implement initState
    super.initState();
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
            height: _height * 0.7,
            width: _width * 0.8,
            child: Column(
              children: [
                Container(
                  height: _height * 0.5,
                  width: _width * 0.8,
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: _width * 0.1,
                            ),
                            Text(
                              '${resTojson['todays'][0]['care_name'].toString()} ',
                              style: TextStyle(fontSize: _width * 0.07),
                            ),
                            Container(
                                width: _width * 0.1,
                                height: _height * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //     '${resTojson['todays'][0]['slot'].toString()} '),
                                  ],
                                )),
                          ],
                        ),
                        Text(
                          '${resTojson['todays'][0]['queue_number'].toString()}',
                          style: TextStyle(fontSize: _width * 0.2),
                        ),
                        Container(
                          width: _width * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    ' น้ำหนัก ${resTojson['health_records'][0]['weight']} '),
                                Text(
                                    ' อุณหภูมิ ${resTojson['health_records'][0]['temp']} '),
                                Text(
                                    ' SYS. ${resTojson['health_records'][0]['bp_sys']} '),
                                Text(
                                    ' DIA. ${resTojson['health_records'][0]['bp_dia']} '),
                                Text(
                                    ' PUL. ${resTojson['health_records'][0]['pulse_rate']} '),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: _height * 0.05),
                GestureDetector(
                  onTap: () {
                    context.read<Datafunction>().playsound();
                    Navigator.pop(context);
                  },
                  child: BoxWidetdew(
                      radius: 10.0,
                      color: Colors.yellow,
                      height: 0.06,
                      width: 0.4,
                      text: 'กลับ',
                      textcolor: Colors.white),
                ),
              ],
            ),
          )))),
          // ElevatedButton(
          //   onPressed: () async {
          //     final pdfFile = await generatePdf();
          //     setState(() {
          //       safe();
          //     });
          //   },
          //   child: Text('testปริ้น'),
          // )
        ]),
      ),
    );
  }
}
