import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smart_health/caregiver/home/homeapp.dart';
import 'package:smart_health/caregiver/login/register.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/myapp/provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/splash_screen/splash_screen.dart';

class Login_User extends StatefulWidget {
  const Login_User({super.key});

  @override
  State<Login_User> createState() => _Login_UserState();
}

class _Login_UserState extends State<Login_User> {
  TextEditingController password = TextEditingController();
  TextEditingController id = TextEditingController();
  bool status = false;
  bool statusdelete = false;
  var resTojson;
  Future<void> login() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/get_recep');
    var res = await http.post(url, body: {'public_id': id.text});
    resTojson = json.decode(res.body);
    print(resTojson);

    if (resTojson['message'] == 'not found') {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          status = false;
        });
      });
      print('ไม่มีบัญชี');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: Container(child: Image.asset('assets/warning.png')),
              title: Text(
                'ไม่มีข้อมูล',
                style: TextStyle(
                    color: Color(0xff48B5AA),
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: 22),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'กลับ',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: context.read<DataProvider>().family),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: context.read<DataProvider>().family),
                    ),
                  ),
                )
              ],
            );
          });
    } else if (resTojson['message'] == 'success') {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          status = false;
          safe();
        });
      });
    }
  }

  void safe() async {
    setState(() {
      status = true;
      context.read<DataProvider>().user_id = resTojson['data']['public_id'];
      context.read<DataProvider>().user_name = resTojson['data']['name'];
      context.read<DataProvider>().user_code = resTojson['data']['code'];
      print('บันทึก');
      print('${context.read<DataProvider>().user_id}');
      print('${context.read<DataProvider>().user_name}');
      print('${context.read<DataProvider>().user_code}');
      addDataInfoToDatabaseUser(context.read<DataProvider>());
    });
  }

  Future<void> addDataInfoToDatabaseUser(DataProvider data) async {
    deletedatabaseUser();
    final db = await openDatabaseappUser();
    final store = intMapStoreFactory.store('data_user_smart_healt');
    final key = await store.add(db, {
      'id': data.user_id,
      'code': data.user_code,
      'name': data.user_name,
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        status = false;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Splash_Screen()));
      });
    });
    await db.close();
  }

  Future<void> delete() async {
    setState(() {
      statusdelete = true;
    });
    deletedatabaseUser();
    final db = await openDatabaseappUser();
    final store = intMapStoreFactory.store('data_user_smart_healt');
    final key = await store.add(db, {
      'id': '',
      'code': '',
      'name': '',
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        statusdelete = true;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Splash_Screen()));
      });
    });
    await db.close();
  }

  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Positioned(child: BackGrund()),
          Positioned(
              child: ListView(
            children: [
              SizedBox(height: _height * 0.05),
              Container(
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                        fontSize: _width * 0.15,
                        fontFamily: context.read<DataProvider>().family),
                  ),
                ),
              ),
              SizedBox(height: _height * 0.02),

              Container(
                child: Center(
                  child: Container(
                    width: _width * 0.8,
                    child: Column(children: [
                      Row(
                        children: [
                          Text(
                            'ล็อกอินผู้ตรวจด้วยเลขบัตรประชาชน',
                            style: TextStyle(
                                fontFamily: context.read<DataProvider>().family,
                                fontSize: _width * 0.035,
                                color: Color(0xff48B5AA)),
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 1)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: TextStyle(
                                  fontFamily:
                                      context.read<DataProvider>().family,
                                  color: Color(0xff48B5AA),
                                  fontSize: _height * 0.02,
                                  shadows: [
                                    Shadow(
                                        color:
                                            Color.fromARGB(255, 104, 104, 104),
                                        offset: Offset(0, 1),
                                        blurRadius: 1.0)
                                  ]),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff48B5AA)))),
                              textAlign: TextAlign.center,
                              controller: id,
                              keyboardType: TextInputType.number,
                              maxLength: 13,
                            ),
                          )),
                    ]),
                  ),
                ),
              ),
              SizedBox(height: _height * 0.02),
              status == false
                  ? Container(
                      child: Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff48B5AA),
                            ),
                            onPressed: () {
                              setState(() {
                                status = true;
                              });
                              login();
                            },
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                  fontFamily:
                                      context.read<DataProvider>().family,
                                  fontSize: _width * 0.04,
                                  color: Color(0xffffffff)),
                            )),
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                          height: MediaQuery.of(context).size.width * 0.05,
                          child: CircularProgressIndicator(
                              color: Color(0xff48B5AA)),
                        ),
                      ),
                    ),
              //   SizedBox(height: _height * 0.5),
              Container(
                width: _width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 1, width: _width * 0.42, color: Colors.grey),
                    Text(
                      ' ro ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Container(
                        height: 1, width: _width * 0.42, color: Colors.grey),
                  ],
                ),
              ),
              context.read<DataProvider>().user_name != null &&
                      context.read<DataProvider>().user_name != ''
                  ? Container(
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                                width: _width * 0.8,
                                child: Text(
                                  'ผู้ตรวจปัจจุบัน',
                                  style: TextStyle(
                                      fontFamily:
                                          context.read<DataProvider>().family,
                                      fontSize: _width * 0.035,
                                      color: Color(0xff48B5AA)),
                                )),
                            Container(
                              width: _width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 1)
                                  ]),
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              height: _height * 0.05,
                                              width: _height * 0.05,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xff48B5AA)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Icon(
                                                Icons.person,
                                                color: Color(0xff48B5AA),
                                              )),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                'ผู้ตรวจ: ${context.read<DataProvider>().user_name}',
                                                style: TextStyle(
                                                    fontFamily: context
                                                        .read<DataProvider>()
                                                        .family,
                                                    fontSize: _width * 0.04,
                                                    color: Color(0xff48B5AA)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'ลบผู้ตรวจ!',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffff0000),
                                                        fontFamily: context
                                                            .read<
                                                                DataProvider>()
                                                            .family,
                                                        fontSize: 22),
                                                  ),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'ยกเลิก',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily: context
                                                                  .read<
                                                                      DataProvider>()
                                                                  .family),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        delete();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'ลบ',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontFamily: context
                                                                  .read<
                                                                      DataProvider>()
                                                                  .family),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: statusdelete == false
                                              ? Icon(
                                                  Icons.delete,
                                                  color: Color(0xffff0000),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: _height * 0.02),
              Container(
                child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff48B5AA),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text(
                        'ลงทะเบียน',
                        style: TextStyle(
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: _width * 0.04,
                            color: Color(0xffffffff)),
                      )),
                ),
              ),
            ],
          ))
        ],
      )),
    );
  }
}
