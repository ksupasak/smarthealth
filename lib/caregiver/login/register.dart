import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/login/login.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/splash_screen/splash_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController officer_code = TextEditingController();
  bool status = false;
  bool statusdata = false;
  Timer? timer;
  Uint8List? bytes;
  var photo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String textbutton = "ยืนยัน";
  var resTojson;
  Future<void> register() async {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        status = false;
      });
    });
    if (id.text != '' &&
        first_name.text != '' &&
        last_name.text != '' &&
        officer_code.text != '') {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/add_recep');
      var res = await http.post(url, body: {
        'care_unit_id': '${context.read<DataProvider>().care_unit_id}',
        'public_id': '${id.text}',
        'name': '${first_name.text} ${last_name.text}',
        'code': '${officer_code.text}',
      });
      resTojson = json.decode(res.body);
      print(resTojson);
      if (resTojson['message'] == 'success') {
        setState(() {
          textbutton = 'สำเร็จ';
        });
      }
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          Navigator.pop(context);
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ข้อมูลไม่ครบ',
              )))));
    }
  }

  void getdata() {
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'กรุณาเสียบบัตรประชาชน',
              )))));
    });
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (context.read<DataProvider>().photo != null) {
        if (photo != context.read<DataProvider>().photo) {
          bytes = base64Decode(context.read<DataProvider>().photo);
          photo = context.read<DataProvider>().photo;
          if (context.read<DataProvider>().creadreader.length != 0) {
            if (id.text !=
                context.read<DataProvider>().creadreader[0].toString()) {
              id.text = context.read<DataProvider>().creadreader[0].toString();
              first_name.text =
                  context.read<DataProvider>().creadreader[2].toString();
              last_name.text =
                  context.read<DataProvider>().creadreader[4].toString();
            }
          }
          setState(() {
            //หยุดโหลด
            statusdata = false;
          });
        }
      }
      if (context.read<DataProvider>().creadreader.length != 0) {
        if (id.text != context.read<DataProvider>().creadreader[0].toString()) {
          setState(() {
            //โหลด
            statusdata = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    context.read<DataProvider>().creadreader = [];
    context.read<DataProvider>().photo = '';
    getdata();

    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    BoxDecoration boxDecoration = BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 250, 250, 250), width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 3, spreadRadius: 1)
        ]);
    TextStyle textStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.04,
        color: Color(0xff1B6286));

    TextStyle textFieldStyle = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 85, 85, 85),
        shadows: [
          Shadow(
              color: Color.fromARGB(255, 104, 104, 104),
              offset: Offset(0, 0),
              blurRadius: 1.0)
        ]);

    InputDecoration textFieldDecoration = InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Positioned(child: BackGrund()),
          Positioned(
              child: ListView(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('SMART CARE GIVER',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: _width * 0.05,
                            color: Color(0xffffffff))),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.05),
              Container(
                width: _width,
                child: Center(
                    child: Container(
                        width: _width * 0.9,
                        decoration: boxDecoration,
                        child: Column(children: [
                          Text('ลงทะเบียนเจ้าหน้าที่ผู้ตรวจ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      context.read<DataProvider>().family,
                                  fontSize: _width * 0.06,
                                  color: Color(0xff1B6286))),
                          Container(
                              height: _height * 0.1,
                              width: _height * 0.1,
                              child: bytes != null
                                  ? bytes!.length != 0
                                      ? Image.memory(bytes!)
                                      : statusdata == false
                                          ? Container(
                                              child: Text(''),
                                            )
                                          : Container(
                                              child: Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                  : Container()),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [Text('ชื่อ', style: textStyle)],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: first_name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกชื่อ';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorText: first_name.text.isEmpty
                                      ? 'กรุณากรอกชื่อ'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [Text('นามสกุล', style: textStyle)],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: last_name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกนามสกุล';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorText: last_name.text.isEmpty
                                      ? 'กรุณากรอกนามสกุล'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [
                                  Text('รหัสบัตรประจำตัวประชาชน',
                                      style: textStyle)
                                ],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: id,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกนามรหัสบัตรประจำตัวประชาชน';
                                  }
                                  return null;
                                },
                                maxLength: 13,
                                keyboardType: TextInputType.number,
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  errorText: id.text.isEmpty
                                      ? 'กรุณากรอกนามรหัสบัตรประจำตัวประชาชน'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [
                                  Text('รหัสเจ้าหน้าที่', style: textStyle)
                                ],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: officer_code,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกรหัสเจ้าหน้าที่';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorText: officer_code.text.isEmpty
                                      ? 'กรุณากรอกรหัสเจ้าหน้าที่'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.05),
                          status == false
                              ? GestureDetector(
                                  onTap: () {
                                    if (first_name != null &&
                                        last_name != null &&
                                        id != null &&
                                        officer_code != null) {
                                      setState(() {
                                        status = true;
                                      });
                                      register();
                                    }
                                  },
                                  child: Container(
                                      height: _height * 0.06,
                                      width: _width * 0.5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color(0xff31D6AA)),
                                      child: Center(
                                          child: Text(
                                        textbutton,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: context
                                                .read<DataProvider>()
                                                .family,
                                            fontSize: _width * 0.05,
                                            color: Color(0xffffffff)),
                                      ))),
                                )
                              : Container(
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                          SizedBox(height: _height * 0.05)
                        ]))),
              ),
            ],
          ))
        ],
      )),
    );
  }
}
