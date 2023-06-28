import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/widget/backgrund.dart';
import 'package:smart_health/myapp/provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var resTojson;
  Future<void> login() async {
    var url = Uri.parse('');
    var res = await http.post(url, body: {' ': ''});
    resTojson = json.decode(res.body);
  }

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
                child: Text(
                  'ลงทเเบียน',
                  style: TextStyle(
                      fontFamily: context.read<DataProvider>().family),
                ),
              ),
            ],
          ))
        ],
      )),
    );
  }
}
