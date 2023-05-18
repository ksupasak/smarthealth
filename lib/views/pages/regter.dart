import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/widgets.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;

class Regter extends StatefulWidget {
  const Regter({super.key});

  @override
  State<Regter> createState() => _RegterState();
}

class _RegterState extends State<Regter> {
  // File? imagepath;
  // String? imagename;
  // String? imagedata;
  // ImagePicker imagePicker = new ImagePicker();
  void regter() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/add_patient');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().regter_data![0],
      'prefix_name': context.read<DataProvider>().regter_data![1],
      'first_name': context.read<DataProvider>().regter_data![2],
      'last_name': context.read<DataProvider>().regter_data![4]
    });

    var resTojson2 = json.decode(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ส่งข้อมูลสำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
      Navigator.pop(context);
    }
  }

  // Future<void> getImage() async {
  //   var getimage = await imagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     imagepath = File(getimage!.path);
  //     imagename = getimage.path.split('/').last;
  //     imagedata = base64Encode(imagepath!.readAsBytesSync());
  //   });
  // }

  Widget BoxData({required String child}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        width: _width * 0.4,
        height: _height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0))),
        child: Text(child,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 28, 155),
              fontFamily: context.read<DataProvider>().fontFamily,
            )));
  }

  Widget Boxheab({required String child}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        width: _width * 0.4,
        height: _height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0))),
        child: Text(child,
            style: TextStyle(
              color: Color.fromARGB(255, 3, 58, 58),
              fontFamily: context.read<DataProvider>().fontFamily,
            )));
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          backgrund(),
          Positioned(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: _height * 0.1,
                    child: Text('ลงทะเบียน',
                        style: TextStyle(
                          fontSize: _width * 0.08,
                          fontFamily: context.read<DataProvider>().fontFamily,
                        )),
                  ),
                  // Container(
                  //   width: 100,
                  //   height: 100,
                  //   child: imagepath == null
                  //       ? Container(child: Text("ไม่มีรูป"))
                  //       : Image.file(imagepath!),
                  // ),
                  Container(
                    height: _height * 0.6,
                    width: _width * 0.8,
                    child: Row(
                      children: [
                        Container(
                          height: _height * 0.6,
                          width: _width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Boxheab(child: 'เลขบัตรประชาชน'),
                              Boxheab(child: 'คำนำหน้าชื่อ'),
                              Boxheab(child: 'ชื่อ'),
                              Boxheab(child: 'นามสกุล'),
                              Boxheab(child: 'Prefix'),
                              Boxheab(child: 'FirstName'),
                              Boxheab(child: 'SurName'),
                              Boxheab(child: 'เลขที่'),
                              Boxheab(child: 'หมู่'),
                              Boxheab(child: 'ซอย/เเยก'),
                              Boxheab(child: 'เเขวง/ตำบล'),
                              Boxheab(child: 'เขต'),
                              Boxheab(child: 'จังหวัด'),
                            ],
                          ),
                        ),
                        Container(
                          height: _height * 0.6,
                          width: _width * 0.4,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![0]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![1]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![2]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![4]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![5]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![6]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![8]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![9]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![10]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![12]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![14]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![15]),
                                BoxData(
                                    child: context
                                        .read<DataProvider>()
                                        .regter_data![16]),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: _height * 0.3,
                    width: _width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              //  regter();
                            },
                            child: BoxWidetdew(
                                color: Colors.green,
                                height: 0.05,
                                width: 0.2,
                                text: 'สมัคร',
                                radius: 0.0,
                                textcolor: Colors.white)),
                        SizedBox(
                          width: _width * 0.1,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: BoxWidetdew(
                                color: Colors.red,
                                height: 0.05,
                                width: 0.2,
                                text: 'ยกเลิก',
                                radius: 0.0,
                                textcolor: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
