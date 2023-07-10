import 'dart:io';

import 'package:flutter/material.dart';

class Update_License extends StatefulWidget {
  const Update_License({super.key});

  @override
  State<Update_License> createState() => _Update_LicenseState();
}

class _Update_LicenseState extends State<Update_License> {
  String value = 'ว่าง';
  File? imageFile;
  void updateLicense() {
    setState(() {
      value = '----';
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update License',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xffffffff),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(children: [
        Container(
          width: _width,
          child: Center(child: Text('$value')),
        ),
        Container(
            width: _width,
            child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      updateLicense();
                    },
                    child: Text('Update License'))))
      ]),
    );
  }
}
