import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
  TextEditingController prefix_name = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController hn = TextEditingController();
  @override
  void initState() {
    setvalue();
    // TODO: implement initState
    super.initState();
  }

  void setvalue() {
    print(context.read<DataProvider>().regter_data);
    if (context.read<DataProvider>().regter_data != null) {
      setState(() {
        id.text = context.read<DataProvider>().regter_data![0];
        prefix_name.text = context.read<DataProvider>().regter_data![1];
        first_name.text = context.read<DataProvider>().regter_data![2];
        last_name.text = context.read<DataProvider>().regter_data![4];
      });
    } else {
      setState(() {
        id.text = '--';
        prefix_name.text = '--';
        first_name.text = '--';
        last_name.text = '--';
      });
    }
  }

  void regter() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/add_patient');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': id.text,
      'prefix_name': prefix_name.text,
      'first_name': first_name.text,
      'last_name': last_name.text,
      'hn': hn.text
    });

    var resTojson2 = json.decode(res.body);
    print(resTojson2);
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
      Get.offNamed('home');
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

  Widget BoxData({String? child}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        width: _width * 0.4,
        height: _height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0))),
        child: child != null
            ? Text("$child",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 28, 155),
                  fontFamily: context.read<DataProvider>().fontFamily,
                ))
            : Text('-'));
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

  Widget textdatauser({TextEditingController? child}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.04,
        color: Color(0xff003D5C));
    return Container(
      child: Row(
        children: [
          SizedBox(width: _width * 0.05),
          Container(
            width: _width * 0.65,
            height: _height * 0.04,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(controller: child, style: style2),
            ),
            decoration: boxDecorate,
          )
        ],
      ),
    );
  }

  Decoration boxDecorate = BoxDecoration(boxShadow: [
    BoxShadow(offset: Offset(0, 2.5), blurRadius: 3, color: Color(0xff31D6AA))
  ], borderRadius: BorderRadius.circular(10), color: Colors.white);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle textStyle = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.06,
        color: Color(0xff31D6AA));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: _width * 0.04,
        color: Color(0xff003D5C));
    return Scaffold(
      body: Stack(
        children: [
          backgrund(),
          Positioned(
            child: Center(
              child: ListView(
                children: [
                  BoxTime(),
                  Container(
                    child: Center(
                      child: Container(
                        width: _width * 0.85,
                        height: _height * 0.6,
                        decoration: boxDecorate,
                        child: Column(
                          children: [
                            Text('ลงทะเบียน', style: textStyle),
                            Container(
                              width: _width * 0.8,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('คำนำหน้าชื่อ', style: style2),
                                    textdatauser(child: prefix_name),
                                    Text('ชื่อ', style: style2),
                                    textdatauser(child: first_name),
                                    Text('นามสกุล', style: style2),
                                    textdatauser(child: last_name),
                                    Text('เลขประจำตัวประชาชน', style: style2),
                                    textdatauser(child: id),
                                    Text('รหัส HN', style: style2),
                                    textdatauser(child: hn),
                                  ]),
                            ),
                            SizedBox(height: _height * 0.01),
                            GestureDetector(
                              onTap: regter,
                              child: Container(
                                width: _width * 0.35,
                                height: _height * 0.06,
                                decoration: BoxDecoration(
                                    color: Color(0xff31D6AA),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 2),
                                          blurRadius: 2)
                                    ]),
                                child: Row(
                                  children: [
                                    Image.asset('assets/rsjyrsk.png'),
                                    Text('ลงทะเบียน',
                                        style: TextStyle(
                                            fontFamily: context
                                                .read<DataProvider>()
                                                .fontFamily,
                                            fontSize: _width * 0.04,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Container(
                  //   height: _height * 0.6,
                  //   width: _width * 0.8,
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         height: _height * 0.6,
                  //         width: _width * 0.4,
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  // Boxheab(child: 'เลขบัตรประชาชน'),
                  // Boxheab(child: 'คำนำหน้าชื่อ'),
                  // Boxheab(child: 'ชื่อ'),
                  // Boxheab(child: 'นามสกุล'),
                  // Boxheab(child: 'Prefix'),
                  // Boxheab(child: 'FirstName'),
                  // Boxheab(child: 'SurName'),
                  // Boxheab(child: 'เลขที่'),
                  // Boxheab(child: 'หมู่'),
                  // Boxheab(child: 'ซอย/เเยก'),
                  // Boxheab(child: 'เเขวง/ตำบล'),
                  // Boxheab(child: 'เขต'),
                  // Boxheab(child: 'จังหวัด'),
                  //           ],
                  //         ),
                  //       ),
                  //       context.read<DataProvider>().regter_data != null
                  //           ? Container(
                  //               height: _height * 0.6,
                  //               width: _width * 0.4,
                  //               child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![0]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![1]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![2]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![4]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![5]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![6]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![8]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![9]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![10]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![12]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![14]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![15]),
                  //                     BoxData(
                  //                         child: context
                  //                             .read<DataProvider>()
                  //                             .regter_data![16]),
                  //                   ]),
                  //             )
                  //           : Container(
                  //               child: Column(children: [
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //                 BoxData(),
                  //               ]),
                  //             )
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   height: _height * 0.3,
                  //   width: _width,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       GestureDetector(
                  //           onTap: () {
                  //             //  regter();
                  //             setState(() {
                  //               context.read<DataProvider>().id = '';
                  //             });
                  //           },
                  //           child: BoxWidetdew(
                  //               color: Colors.green,
                  //               height: 0.05,
                  //               width: 0.2,
                  //               text: 'สมัคร',
                  //               radius: 0.0,
                  //               textcolor: Colors.white)),
                  //       SizedBox(
                  //         width: _width * 0.1,
                  //       ),
                  //       GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               context.read<DataProvider>().id = '';
                  //             });
                  //             Navigator.pop(context);
                  //           },
                  //           child: BoxWidetdew(
                  //               color: Colors.red,
                  //               height: 0.05,
                  //               width: 0.2,
                  //               text: 'ยกเลิก',
                  //               radius: 0.0,
                  //               textcolor: Colors.white)),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: _height * 0.03,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Get.offNamed('home');
                },
                child: Container(
                  height: _height * 0.025,
                  width: _width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color.fromARGB(255, 201, 201, 201),
                          width: _width * 0.002)),
                  child: Center(
                      child: Text(
                    '< ย้อนกลับ',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: _width * 0.03,
                        color: Color.fromARGB(255, 201, 201, 201)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
