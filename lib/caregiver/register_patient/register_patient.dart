import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/myapp/provider/provider.dart';

class Register_Patient extends StatefulWidget {
  const Register_Patient({super.key});

  @override
  State<Register_Patient> createState() => _Register_PatientState();
}

class _Register_PatientState extends State<Register_Patient> {
  TextEditingController id = TextEditingController();
  TextEditingController prefix_name = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController subdistrict = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController hn = TextEditingController();

  bool status = false;
  String textbutton = "ยืนยัน";
  bool statusdata = false;
  Timer? timer;
  Uint8List? bytes;
  var photo;

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
              id.text = context.read<DataProvider>().creadreader[0].toString();
              first_name.text =
                  context.read<DataProvider>().creadreader[2].toString();
              prefix_name.text =
                  context.read<DataProvider>().creadreader[1].toString();
              last_name.text =
                  context.read<DataProvider>().creadreader[4].toString();
              subdistrict.text =
                  context.read<DataProvider>().creadreader[14].toString();
              district.text =
                  context.read<DataProvider>().creadreader[15].toString();
              province.text =
                  context.read<DataProvider>().creadreader[16].toString();
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

  Future<void> register() async {
    setState(() {
      status = true;
    });

    if (id.text != '' &&
        first_name.text != '' &&
        last_name.text != '' &&
        prefix_name.text != '' &&
        subdistrict.text != '' &&
        district.text != '' &&
        province.text != '') {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/add_patient');
      var res = await http.post(url, body: {
        'care_unit_id': "${context.read<DataProvider>().care_unit_id}",
        'public_id': "${id.text}",
        'prefix_name': "${prefix_name.text}",
        'first_name': "${first_name.text}",
        'last_name': "${last_name.text}",
        'subdistrict': "${subdistrict.text}",
        'district': "${district.text}",
        'province': "${province.text}",
        'hn': "${hn.text}",
      });
      var resTojson = json.decode(res.body);
      print(resTojson);
      if (resTojson['message'] == 'success') {
        setState(() {
          textbutton = 'สำเร็จ';
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              status = false;
            });
          });
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'สำเร็จ',
              )))));
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          Navigator.pop(context);
        });
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          status = false;
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ข้อมูลไม่ครบ',
              )))));
    }
  }

  @override
  void initState() {
    getdata();
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
          Positioned(
              child: Container(
            width: _width,
            height: _height * 0.25,
            child: Image.asset(
              'assets/doctors-holding-hands-together-hospitalconcept-teamwork.jpg',
              fit: BoxFit.fill,
            ),
          )),
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
                            color: Color.fromARGB(255, 212, 212, 212))),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.08),
              Container(
                width: _width,
                child: Center(
                    child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(220, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: Column(children: [
                          Text('ลงทะเบียน ',
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
                                children: [
                                  Text('คำนำหน้าชื่อ', style: textStyle)
                                ],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: prefix_name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'คำนำหน้าชื่อ';
                                  }
                                  return null;
                                },
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  errorText: prefix_name.text.isEmpty
                                      ? 'กรุณากรอกคำนำหน้าชื่อ'
                                      : null,
                                ),
                              ),
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
                                style: textFieldStyle,
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
                                style: textFieldStyle,
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
                                    return 'กรุณากรอกรหัสบัตรประจำตัวประชาชน';
                                  }
                                  return null;
                                },
                                maxLength: 13,
                                keyboardType: TextInputType.number,
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  errorText: id.text.isEmpty
                                      ? 'กรุณากรอกรหัสบัตรประจำตัวประชาชน'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [Text('แขวง/ตำบล', style: textStyle)],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: subdistrict,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'แขวง/ตำบล';
                                  }
                                  return null;
                                },
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  errorText: subdistrict.text.isEmpty
                                      ? 'กรุณากรอกแขวง/ตำบล'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [Text('เขต/อำเภอ', style: textStyle)],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: district,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'เขต/อำเภอ';
                                  }
                                  return null;
                                },
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  errorText: district.text.isEmpty
                                      ? 'กรุณากรอกเขต/อำเภอ'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [Text('จังหวัด', style: textStyle)],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: province,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'จังหวัด';
                                  }
                                  return null;
                                },
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  errorText: province.text.isEmpty
                                      ? 'กรุณากรอกจังหวัด'
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: _height * 0.05,
                              width: _width * 0.8,
                              child: Row(
                                children: [Text('รหัสHN', style: textStyle)],
                              )),
                          Container(
                            height: _height * 0.08,
                            width: _width * 0.8,
                            decoration: boxDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: hn,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'กรุณากรอกรหัสHN';
                                //   }
                                //   return null;
                                // },
                                style: textFieldStyle,
                                // decoration: InputDecoration(
                                //   errorText: hn.text.isEmpty
                                //       ? 'กรุณากรอกรหัสHN'
                                //       : null,
                                // ),
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.05),
                          status == false
                              ? GestureDetector(
                                  onTap: () {
                                    register();
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
