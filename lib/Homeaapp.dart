import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Menu.dart';
import 'package:smart_health/provider/Provider.dart';
import 'package:smart_health/searchbluetooth.dart';
import 'package:smart_health/setting.dart';
import 'package:smart_health/ss.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});

  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  String chake = 'chakepassword';
  String passwordslogin = '1710501456572';
  double mediaQuerywidth = 0.0;
  bool chakesendinformation = false;

  String colortexts = 'back';
  bool button = false;
  var resTojson;

  int checkDigit(String id) {
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(id[i]);
      sum += digit * (13 - i);
    }

    int remainder = sum % 11;
    int result = (11 - remainder) % 10;

    return result;
  }

  void chakepasswordslogin() {
    if (passwordslogin.length >= 14) {
      setState(() {
        passwordslogin.substring(0, 1);
        int g = passwordslogin.length - 1;
        passwordslogin = passwordslogin.substring(0, g);
      });
    } else if (passwordslogin.length == 13) {
      int id = checkDigit(passwordslogin);
      String ids = id.toString();
      if (ids == passwordslogin[12]) {
        colortexts = 'green';
      } else {
        setState(() {
          colortexts = 'red';
        });
      }
    } else {
      colortexts = 'back';
    }
  }

  void sendinformation() async {
    if (passwordslogin.length == 13) {
      setState(() {
        button = true;
      });
      int id = checkDigit(passwordslogin);
      String ids = id.toString();
      if (ids == passwordslogin[12]) {
        var url = Uri.parse(
            '${context.read<stringitem>().PlatfromURL}get_patient?public_id=$passwordslogin'); //${context.read<stringitem>().uri}
        var res = await http.get(url);
        resTojson = json.decode(res.body);
        print(resTojson);
        if (resTojson['message'] == 'success') {
          print(resTojson['message']);
          setState(() {
            button = false;
            passwordslogin = '';
            context.read<stringitem>().first_name =
                resTojson['data']['first_name'];
            context.read<stringitem>().last_name =
                resTojson['data']['last_name'];
            context.read<stringitem>().tel = resTojson['data']['tel'];
            context.read<stringitem>().image = resTojson['data']['picture_url'];
            context.read<stringitem>().id = passwordslogin;

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Menuindexuser()));
          });
        }
      }
    } else {
      setState(() {
        colortexts = 'red';
      });
    }
  }

//   String? id;
//   List<BluetoothDevice> devicesList2 = [];
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   void scanDevices() async {
//     FlutterBluePlus.instance.turnOn();
//     flutterBlue.startScan(timeout: Duration(seconds: 30));
//     flutterBlue.scanResults.listen((results) async {
//       for (ScanResult r in results) {
//         // print('devicesList2= $devicesList2');
//         if (true
//             //!devicesList2.contains(r.device)
//             ) {
//           devicesList2.add(r.device);

//           // print('1 ${r.device.id}');
//           if (r.device.name == 'HC-08') {
//             r.device..connect();
//             print('object: ${r.device}');
//             print('advertise: ${r.advertisementData.toString()}');

//             r.device.state.listen((state) async {
//               switch (state) {
//                 case BluetoothDeviceState.connected:
//                   print('->connected');
//                   break;
//                 case BluetoothDeviceState.disconnected:
//                   print('--disconnected');
//                   break;
//                 default:
//                   print('-Noconnect');
//                   break;
//               }
//             });

// //00:1C:C2:52:ED:A4

//             r.device.isDiscoveringServices.listen((event) async {
//               print('isDiscoveringServices = ${event}');
//               if (event) {
//                 List<BluetoothService> services =
//                     await r.device.discoverServices();
//                 print('services.length = ${services.length}');
//               }
//             });
//             print('เจอเเล้ว');

//             setState(() {
//               id = r.device.id.toString();
//             });
//             print('$id');
//           }
//         }
//       }
//     });
//     // print(devicesList1);
//     flutterBlue.stopScan();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                              child: Text(
                                context.read<stringitem>().NAMEOFHOSPITAL,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.08,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              'SMART TELEMED STATION',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05),
                          chake == 'chakepassword'
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10, color: Colors.white),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 30, 0, 0),
                                        child: Text(
                                          'กรุณากรอกรหัสบัตรประชาชนเพื่อทำการเข้าสู่ระบบ',
                                          style: TextStyle(
                                              fontSize: (MediaQuery.of(context)
                                                          .size
                                                          .width +
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  0.012,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 170, 170, 170),
                                                  offset: Offset(0, 0),
                                                  blurRadius: 1)
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$passwordslogin",
                                              style: TextStyle(
                                                  color: colortexts == "back"
                                                      ? Colors.black
                                                      : colortexts == "red"
                                                          ? Colors.red
                                                          : Colors.green,
                                                  fontSize: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width +
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height) *
                                                      0.012,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      button == false
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 170, 170, 170),
                                                        offset: Offset(0, 0),
                                                        blurRadius: 2)
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '7';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '7',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '8';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '8',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '9';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '9',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '4';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '4',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '5';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '5',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '6';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '6',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '1';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '1',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '2';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '2',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '3';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '3',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                passwordslogin =
                                                                    passwordslogin +
                                                                        '0';
                                                                chakepasswordslogin();
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  '0',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                colortexts =
                                                                    'back';
                                                                passwordslogin
                                                                    .substring(
                                                                        0, 1);
                                                                int g = passwordslogin
                                                                        .length -
                                                                    1;
                                                                passwordslogin =
                                                                    passwordslogin
                                                                        .substring(
                                                                            0,
                                                                            g);
                                                              });
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.18,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              child: Center(
                                                                child: Text(
                                                                  'ลบ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) *
                                                                              0.012,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.007,
                                      ),
                                      button == false
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      print(passwordslogin);
                                                      sendinformation();

                                                      // Navigator.pushReplacement(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             Menuindexuser()));

                                                      // new Timer(
                                                      //     const Duration(
                                                      //         milliseconds:
                                                      //             1000), () {
                                                      //   setState(() {
                                                      //     Navigator.pushReplacement(
                                                      //         context,
                                                      //         MaterialPageRoute(
                                                      //             builder:
                                                      //                 (context) =>
                                                      //                     Menuindex()));
                                                      //     chake = 'HOME';
                                                      //   });
                                                      // });
                                                    },
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 5,
                                                                color: Colors
                                                                    .blue),
                                                          ],
                                                          color: Color.fromARGB(
                                                              255, 0, 128, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Center(
                                                          child: Text(
                                                        'ยืนยัน',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width +
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height) *
                                                                0.012,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 5,
                                                                color:
                                                                    Colors.red),
                                                          ],
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: Center(
                                                          child: Text(
                                                        'หน้าหลัก',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width +
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height) *
                                                                0.012,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                    ],
                                  ),
                                )
                              : chake == 'QRCODE'
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width /
                                              25,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              color: Colors.white),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 30, 0, 0),
                                            child: Text(
                                              'กรุณาแสกน QR CODEเพื่อทำการเข้าสู่ระบบ',
                                              style: TextStyle(
                                                  fontSize: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height +
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width) *
                                                      0.012,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.005,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 50),
                                            child: Container(
                                                color: Colors.amber,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Image.asset(
                                                  'assets/qr.png',
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                chake = 'chakepassword';
                                                // print('object1/');
                                                // print(MediaQuery.of(context)
                                                //         .size
                                                //         .width /
                                                //     1);
                                                // print('object2/');
                                                // print(MediaQuery.of(context)
                                                //         .size
                                                //         .height /
                                                //     1);
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.red,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 10,
                                                        color: Colors.red)
                                                  ]),
                                              child: Center(
                                                  child: Text(
                                                'ยกเลิก',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.11,
          color: Colors.white,
          //  color: Color.fromARGB(255, 226, 223, 223),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Setting()));
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.9,
                  // color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          //   color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.088,
                          child: Image.asset('assets/icon id card.png')),
                      Text(
                        'ตั่งค่า',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 45,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    chake = 'chakepassword';
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.9,
                  //  color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.088,
                          child: Image.asset('assets/pass.png')),
                      Text(
                        'ยืนยันตัวตนด้วยรหัสผ่าน',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 45,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    chake = 'QRCODE';
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.9,
                  // color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.088,
                          child: Image.asset('assets/qr-code.png')),
                      Text(
                        'สแกน QR CODE',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 45,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
