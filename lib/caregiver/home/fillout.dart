import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/user_information/user_information.dart';
import 'package:smart_health/myapp/provider/provider.dart';

class Fill_Out extends StatefulWidget {
  Fill_Out({super.key, this.id});
  String? id;
  @override
  State<Fill_Out> createState() => _Fill_OutState();
}

class _Fill_OutState extends State<Fill_Out> {
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  final prefix_name = ['นาย', 'เด็กชาย', 'นาง', 'นางสาว', 'เด็กหญิง'];
  String? value;
  DataProvider provider = DataProvider();
  void sing() async {
    List data = [];

    if (value != null && first_name.text != '' && last_name.text != '') {
      data.add(widget.id);
      data.add(value);
      data.add(first_name.text);
      data.add('');
      data.add(last_name.text);
      provider.creadreader = data;
      print(provider.creadreader);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => User_Information()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ตรวจเเบบ Offline',
              )))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'กรุณากรอกข้อมูลให้ครบ',
              )))));
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: _height * 0.9,
      child: Column(children: [
        Text(
          "กรอกข้อมูล",
          style: TextStyle(
              fontSize: 22, fontFamily: context.read<DataProvider>().family),
        ),
        // boxtext_Fill_Out('คำนำหน้าชื่อ', prefix_name),
        Container(
          width: _width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'คำนำหน้าชื่อ',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: context.read<DataProvider>().family),
              ),
              DropdownButton<String>(
                  value: value,
                  items: prefix_name.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => this.value = value!)),
            ],
          ),
        ),
        boxtext_Fill_Out('ชื่อ', first_name),
        boxtext_Fill_Out('นามสกุล', last_name),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xff48B5AA),
              onPrimary: Colors.white,
            ),
            onPressed: sing,
            child: Text('เข้าตรวจ'))
      ]),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontFamily: context.read<DataProvider>().family),
      ));

  Widget boxtext_Fill_Out(String text, TextEditingController value) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Container(
            width: _width * 0.9,
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: context.read<DataProvider>().family),
                ),
              ],
            ),
          ),
          Container(
            width: _width * 0.9,
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .black), // เปลี่ยนสีเส้นที่อยู่ด้านล่างเมื่อมี Focus
                ),
              ),
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              controller: value,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
