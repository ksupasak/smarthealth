import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/blue.dart';
import 'package:smart_health/provider/Provider.dart';
import 'package:smart_health/provider/local.dart';
import 'package:smart_health/searchbluetooth.dart';
import 'package:http/http.dart' as http;

class settinglist extends StatefulWidget {
  const settinglist({super.key});

  @override
  State<settinglist> createState() => _settinglistState();
}

class _settinglistState extends State<settinglist> {
  TextEditingController Hospitalname = TextEditingController();
  TextEditingController LicenseKey = TextEditingController();
  TextEditingController PlatfromURL = TextEditingController();
  TextEditingController care_unit_id = TextEditingController();
  String CheckConnections = '';
  void adddata() {
    context.read<stringitem>().Hospitalname = Hospitalname.text;
    context.read<stringitem>().LicenseKey = LicenseKey.text;
    context.read<stringitem>().PlatfromURL = PlatfromURL.text;
    context.read<stringitem>().care_unit_id = care_unit_id.text;
    // Adddatabaseapp(context.read<stringitem>());
    Navigator.pop(context);
  }

  void CheckConnection() async {
    var url = Uri.parse(
        '${PlatfromURL.text}check_connect?care_unit_id=${care_unit_id.text}');
    var res = await http.get(
      url,
    );
    var resTojson = json.decode(res.body);

    if (resTojson['message'] == 'success') {
      setState(() {
        CheckConnections = 'OK';
      });
    }
  }

  void reset() {
    Hospitalname.text = context.read<stringitem>().Hospitalname;
    LicenseKey.text = context.read<stringitem>().LicenseKey;
    PlatfromURL.text = context.read<stringitem>().PlatfromURL;
    care_unit_id.text = context.read<stringitem>().care_unit_id;
  }

  @override
  void initState() {
    reset();
    CheckConnection();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Stack(children: [
          Positioned(
              child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 70, 180, 170),
                  Colors.white,
                ],
              ),
            ),
          )),
          Positioned(
              child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hospital name"),
                        TextField(
                          controller: Hospitalname,
                        ),
                        Text('License Key'),
                        TextField(
                          controller: LicenseKey,
                        ),
                        Text('Platfrom URL'),
                        TextField(
                          controller: PlatfromURL,
                        ),
                        Text('care_unit_id'),
                        TextField(
                          controller: care_unit_id,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  CheckConnections = '';
                                });
                                CheckConnection();
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      decoration: BoxDecoration(
                                          color: CheckConnections == ''
                                              ? Colors.white
                                              : CheckConnections == 'OK'
                                                  ? Color.fromARGB(
                                                      255, 170, 252, 173)
                                                  : CheckConnections == ''
                                                      ? Color.fromARGB(
                                                          255, 189, 68, 60)
                                                      : Colors.white,
                                          boxShadow: [
                                            BoxShadow(blurRadius: 1),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02)),
                                      child: Center(
                                        child: CheckConnections == ''
                                            ? Text('Check Connection')
                                            : CheckConnections == 'OK'
                                                ? Text('Check Connection')
                                                : CheckConnections == 'NO'
                                                    ? Text('Check Connection')
                                                    : Text('Check Connection'),
                                      ),
                                    ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                reset();
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(blurRadius: 1),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02)),
                                      child: Center(child: Text('Reset')),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlutterBlueApp(),
                              ),
                            );
                          },
                          child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(blurRadius: 1),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.02)),
                                  child: Center(
                                    child: Text('บูลทูธ'),
                                  ),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            adddata();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.055,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Center(
                                child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 1),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.02)),
                              child: Center(
                                child: Text('บันทึก'),
                              ),
                            )),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ))
        ]),
      ),
    );
  }
}
