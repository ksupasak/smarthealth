import 'dart:convert';

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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String textbutton = "ยืนยัน";
  var resTojson;
  Future<void> register() async {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        status = false;
      });
    });
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login_User()));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
      //   border: InputBorder.none, //เส้นไต้
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
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Container(
                                    height: _height * 0.1,
                                    width: _height * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Color(0xff1B6286))),
                                    child: Icon(Icons.person,
                                        color: Color(0xff1B6286)),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white),
                                        child: Icon(Icons.add,
                                            color: Color(0xff1B6286))))
                              ],
                            ),
                          ),
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
                                  // labelText: 'ชื่อ',
                                  errorText: first_name.text.isEmpty
                                      ? 'กรุณากรอกชื่อ'
                                      : null,
                                ),
                              ),
                              // TextField(
                              //     controller: first_name,
                              //     decoration: textFieldDecoration,
                              //     style: textFieldStyle),
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
                                  // labelText: 'ชื่อ',
                                  errorText: last_name.text.isEmpty
                                      ? 'กรุณากรอกนามสกุล'
                                      : null,
                                ),
                              ),
                              //  TextField(
                              //     controller: last_name,
                              //     decoration: textFieldDecoration,
                              //     style: textFieldStyle),
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
                                    return 'กรุณากรอกนามรหัสเจ้าหน้าที่';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorText: officer_code.text.isEmpty
                                      ? 'กรุณากรอกนามรหัสเจ้าหน้าที่'
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
