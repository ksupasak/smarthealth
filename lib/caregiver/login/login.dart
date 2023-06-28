//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/home/homeapp.dart';
import 'package:smart_health/caregiver/login/register.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/myapp/provider/provider.dart';

//import 'package:http/http.dart' as http;

class Login_User extends StatefulWidget {
  const Login_User({super.key});

  @override
  State<Login_User> createState() => _Login_UserState();
}

class _Login_UserState extends State<Login_User> {
  // var resTojson;
  // Future<void> login() async {
  //   var url = Uri.parse(
  //       'https://emr-life.com/clinic_master/clinic/Api/list_care_unit');
  //   var res = await http.post(url, body: {' ': ''});
  //   resTojson = json.decode(res.body);
  // }

  @override
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
              Container(
                child: Center(
                  child: Text(
                    'ผู้ตรวจ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: _width * 0.06,
                        fontFamily: context.read<DataProvider>().family),
                  ),
                ),
              ),
              SizedBox(height: _height * 0.1),
              Container(
                child: Center(
                  child: Container(
                    width: _width * 0.8,
                    height: _height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 1),
                              blurRadius: 2)
                        ]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text('ชื่อ  -  นามสกุล  -'),
                          )
                        ]),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeCareCevier()));
                      },
                      child: Text('เข้าตรวจ')),
                ),
              ),
              Container(
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text('สมัค')),
                ),
              )
            ],
          ))
        ],
      )),
    );
  }
}
