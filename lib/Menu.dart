import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/Homeaapp.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/provider/Provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_health/searchbluetooth.dart';
import 'package:smart_health/widgets.dart';
//import 'package:smart_health/searchbluetooth.dart';

class Menuindexuser extends StatefulWidget {
  @override
  State<Menuindexuser> createState() {
    return _MenuindexuserState();
  }
}

class _MenuindexuserState extends State<Menuindexuser> {
  TextEditingController care_unit_id = TextEditingController();

  TextEditingController temp = TextEditingController();
  TextEditingController pulse_rate = TextEditingController();
  TextEditingController rr = TextEditingController();
  TextEditingController bp = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController bmi = TextEditingController();
  TextEditingController fbs = TextEditingController();
  //
  TextEditingController Spo2 = TextEditingController();
  TextEditingController DIA = TextEditingController();
  TextEditingController SYS = TextEditingController();
  TextEditingController URIC = TextEditingController();
  TextEditingController SI = TextEditingController();
  List<BluetoothDevice> devicesList2 = [];
  List<BluetoothService> desiredServices = [];
  BluetoothDevice? ListBluetoothDevice;
  AdvertisementData? ListBluetoothadvertisementData;

  String? id;
  bool indexsend = true;

  void send() async {
    var url = Uri.parse(
        '${context.read<stringitem>().PlatfromURL}add_hr'); //${context.read<stringitem>().uri}
    var res = await http.post(url, body: {
      "public_id": context.read<stringitem>().id,
      "care_unit_id": '63d79d61790f9bc857000006',
      "temp": "${temp.text}",
      "pulse_rate": "${pulse_rate.text}",
      "rr": "${rr.text}",
      "bp": "${bp.text}",
      "weight": "${weight.text}",
      "height": "${height.text}",
      "bmi": "${bmi.text}",
      "fbs": "${fbs.text}",
    });
    var resTojson = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        indexsend = true;
        if (resTojson['message'] == "success") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Homeapp()));
        }
      });
    }
  }

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  void readDevices(BluetoothDevice device) {
    device.discoverServices().then((services) async {
      if (services.isNotEmpty) {
        for (BluetoothService service in services) {
          print('Service found:-----> ${service.uuid}');
          for (BluetoothService service in services) {
            if (service.uuid.toString() ==
                '0000ffe0-0000-1000-8000-00805f9b34fb') {
              desiredServices.add(service);
              print("****************-----${service}");

              for (BluetoothCharacteristic char in service.characteristics) {
                print('char: ${char.uuid}');
                await char.read().then((c) {
                  print('read : ${c}');
                  print('last list: ${char.lastValue}');
                  print('last temp: ${Hc08.parse(char.lastValue)}');
                  char.value.listen((c) async {
                    print('value list: ${c}');
                    print('value temp: ${Hc08.parse(c)}');
                  });
                });
              }
            }
          }
        }
      } else {
        print('No services found');
      }
    });
  }

  void scanDevices() async {
    setState(() {
      devicesList2 = [];
    });
    print('เข้า');
    FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.instance.connectedDevices.then((connectedDs) async {
      print('connectedDevices1 : ${connectedDs}');
      for (BluetoothDevice device in connectedDs) {
        if (device.id.toString() == 'B0:B1:13:76:0F:23') {
          readDevices(device);
        }
      }
    });
    FlutterBluePlus.instance.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (true) {
          devicesList2.add(r.device);

          if (r.device.id.toString() == 'B0:B1:13:76:0F:23') {
            print('เจอเเล้ว');
            FlutterBluePlus.instance.connectedDevices.then((connectedDs) async {
              print('connectedDevices2 : ${connectedDs}');
              if (!connectedDs.contains(r.device)) {
                await r.device.connect();
                readDevices(r.device);
              }
            });

            print('object: ${r.device}');

            print('advertise: ${r.advertisementData.toString()}');
          }
        }
      }
    });

    FlutterBluePlus.instance.stopScan();
  }

  void scan() {
    BluetoothDevice device = devicesList2
        .firstWhere((element) => element.id.id == 'B0:B1:13:76:0F:23');

    if (device != null) {
      print('Name: ${device.name}');
      print('MAC address: ${device.id.id}');
    } else {
      print('Device not found');
    }
  }

  void connectToDevice() async {
    List<BluetoothService> services;
    BluetoothDevice connectedDevice =
        await BluetoothDevice.fromId('B0:B1:13:76:0F:23');

    if (connectedDevice.id.toString() == 'B0:B1:13:76:0F:23') {
      StreamBuilder<List<BluetoothService>>(
        stream: connectedDevice.services,
        initialData: const [],
        builder: (c, snapshot) {
          return Container(
            child: Text('1'),
          );
        },
      );
      print('connect hc-08');
      print(connectedDevice.id.toString());
    } else {
      print('No connect= ');
    }
  }

  @override
  void initState() {
    if (FlutterBluePlus.instance.state != BluetoothState.on) {
      setState(() {
        FlutterBluePlus.instance.turnOn();
        scanDevices();
      });
    } else if (FlutterBluePlus.instance.state == BluetoothState.on) {
      setState(() {
        scanDevices();
      });
    }

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
            // Positioned(
            //   top: 100,
            //   child: Image.network(
            //     'http://www.w3.org/2000/svg',
            //     fit: BoxFit.fill,
            //   ),
            // ),
            Positioned(
              child: RefreshIndicator(
                onRefresh: () => FlutterBluePlus.instance
                    .startScan(timeout: const Duration(seconds: 5)),
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
                                        MediaQuery.of(context).size.width *
                                            0.06,
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
                            Container(
                              height: MediaQuery.of(context).size.height *
                                  0.02, //  width: MediaQuery.of(context).size.width * 0.85,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.height * 0.13,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        color:
                                            Color.fromARGB(255, 67, 179, 153)),
                                  ],
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 48, 133, 144),
                                        Color.fromARGB(255, 70, 180, 170),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.03,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Colors.white),
                                          ],
                                        ),
                                        child:
                                            context.read<stringitem>().image !=
                                                    ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                    ),
                                                    child: Image.network(
                                                      '${context.read<stringitem>().image}',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : Icon(Icons.person)),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                context
                                                        .read<stringitem>()
                                                        .first_name +
                                                    '  ' +
                                                    context
                                                        .read<stringitem>()
                                                        .last_name,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.white,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                              Text(
                                                "Number : " +
                                                    context
                                                        .read<stringitem>()
                                                        .tel,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.white,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'การวัดค่า',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          // color: Colors.amber,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10, color: Colors.white),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // color: Colors.amber,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Height",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                              color: Color.fromARGB(
                                                  255, 12, 114, 105),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              //     color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: height,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.002,
                                      color: Color.fromARGB(255, 70, 180, 170),
                                    ),
                                    Container(
                                      // color: Colors.amber,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Weight",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                              color: Color.fromARGB(
                                                  255, 12, 114, 105),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              //     color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: weight,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10, color: Colors.white),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      //  color: Colors.amber,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "SYS",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                              color: Color.fromARGB(
                                                  255, 12, 114, 105),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              //     color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: SYS,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.002,
                                      color: Color.fromARGB(255, 70, 180, 170),
                                    ),
                                    Container(
                                      //   color: Color.fromARGB(255, 114, 99, 56),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "DIA",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                              color: Color.fromARGB(
                                                  255, 12, 114, 105),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              //     color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: DIA,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.002,
                                      color: Color.fromARGB(255, 70, 180, 170),
                                    ),
                                    Container(
                                      //  color: Color.fromARGB(255, 1, 211, 113),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "PULSE",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                              color: Color.fromARGB(
                                                  255, 12, 114, 105),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              //     color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: pulse_rate,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10, color: Colors.white),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // color: Colors.amber,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // StreamBuilder<List<int>>(
                                          //   stream: characteristic.value,
                                          //   initialData:
                                          //       characteristic.lastValue,
                                          //   builder: (c, snapshot) {
                                          //     final value = snapshot.data;

                                          //     return ExpansionTile(
                                          //       backgroundColor: Colors.amber,
                                          //       title: ListTile(
                                          //         title: Column(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment
                                          //                   .center,
                                          //           crossAxisAlignment:
                                          //               CrossAxisAlignment
                                          //                   .start,
                                          //           children: <Widget>[
                                          //             Text(
                                          //                 'Temperature ${snapshot.data} '),
                                          //             Text(characteristic.uuid
                                          //                 .toString()
                                          //                 .toUpperCase()
                                          //                 .substring(4, 8)),
                                          //             Text(
                                          //                 '0x${characteristic.uuid.toString().toUpperCase().substring(10)}',
                                          //                 style: Theme.of(
                                          //                         context)
                                          //                     .textTheme
                                          //                     .bodyText1
                                          //                     ?.copyWith(
                                          //                         color: Theme.of(
                                          //                                 context)
                                          //                             .textTheme
                                          //                             .caption
                                          //                             ?.color)),
                                          //           ],
                                          //         ),
                                          //         subtitle: Column(
                                          //           children: [
                                          //             Text(value.toString()),
                                          //           ],
                                          //         ),
                                          //         contentPadding:
                                          //             const EdgeInsets.all(0.0),
                                          //       ),
                                          //     );
                                          //   },
                                          // )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.002,
                                      color: Color.fromARGB(255, 70, 180, 170),
                                    ),
                                    Container(
                                      // color: Colors.amber,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Spo2",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                              color: Color.fromARGB(
                                                  255, 12, 114, 105),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              //     color: Colors.green,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: Spo2,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.0),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10, color: Colors.white),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                        ),
                                        Text(
                                          "ค่าน้ำตาลในเลือด",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                            color: Color.fromARGB(
                                                255, 12, 114, 105),
                                            shadows: [
                                              Shadow(
                                                color: Colors.white,
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // color: Colors.amber,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          child: Center(
                                            child: Center(
                                              child: Text(
                                                "ก่อนอาหาร",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  color: Color.fromARGB(
                                                      255, 12, 114, 105),
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
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.045,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.002,
                                          color:
                                              Color.fromARGB(255, 70, 180, 170),
                                        ),
                                        Container(
                                          // color: Colors.amber,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          child: Center(
                                            child: Text(
                                              "หลังอาหาร",
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025,
                                                color: Color.fromARGB(
                                                    255, 12, 114, 105),
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
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          //color: Colors.amber,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "FBS",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  color: Color.fromARGB(
                                                      255, 12, 114, 105),
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.white,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  //     color: Colors.green,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: fbs,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                    ),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                  )),
                                              Text('mg/dL')
                                            ],
                                          ),
                                        ),
                                        Container(
                                          //color: Colors.amber,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "SI",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  color: Color.fromARGB(
                                                      255, 12, 114, 105),
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.white,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  //     color: Colors.green,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: SI,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                    ),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                  )),
                                              Text('mmol/L')
                                            ],
                                          ),
                                        ),
                                        Container(
                                          //color: Colors.amber,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "URIC",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  color: Color.fromARGB(
                                                      255, 12, 114, 105),
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.white,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  //     color: Colors.green,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: URIC,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                    ),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                  )),
                                              Text('umol/L')
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              indexsend == true
                                  ? GestureDetector(
                                      onTap: () {
                                        //  indexsend = false;
                                        //  send();
                                        scanDevices();
                                      },
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 10,
                                                    color: Color.fromARGB(
                                                        255, 67, 179, 153)),
                                              ],
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 48, 133, 144),
                                                    Color.fromARGB(
                                                        255, 70, 180, 170),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              )),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          child: Center(
                                            child: Text('ทดสอบส่ง'),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                            ],
                          )),
                      // SingleChildScrollView(
                      //   child: Column(
                      //     children: <Widget>[
                      //       StreamBuilder<List<BluetoothDevice>>(
                      //         stream:
                      //             Stream.periodic(const Duration(seconds: 2))
                      //                 .asyncMap((_) => FlutterBluePlus
                      //                     .instance.connectedDevices),
                      //         initialData: const [],
                      //         builder: (c, snapshot) => Column(
                      //           children: snapshot.data!
                      //               .map((d) => ListTile(
                      //                     title: Text('d.name'),
                      //                     subtitle: Text(d.id.toString()),
                      //                     trailing: StreamBuilder<
                      //                         BluetoothDeviceState>(
                      //                       stream: d.state,
                      //                       initialData: BluetoothDeviceState
                      //                           .disconnected,
                      //                       builder: (c, snapshot) {
                      //                         if (snapshot.data ==
                      //                             BluetoothDeviceState
                      //                                 .connected) {
                      //                           return GestureDetector(
                      //                             onTap: () => Navigator.of(
                      //                                     context)
                      //                                 .push(MaterialPageRoute(
                      //                                     builder: (context) =>
                      //                                         DeviceScreen(
                      //                                             device: d))),
                      //                             child: Container(
                      //                               height:
                      //                                   MediaQuery.of(context)
                      //                                           .size
                      //                                           .height *
                      //                                       0.045,
                      //                               width:
                      //                                   MediaQuery.of(context)
                      //                                           .size
                      //                                           .width *
                      //                                       0.4,
                      //                               decoration: BoxDecoration(
                      //                                   borderRadius:
                      //                                       BorderRadius
                      //                                           .circular(
                      //                                     MediaQuery.of(context)
                      //                                             .size
                      //                                             .width *
                      //                                         0.05,
                      //                                   ),
                      //                                   color: Colors.green),
                      //                               child: Center(
                      //                                   child: Text(
                      //                                       'Connected Successfully / Open')),
                      //                             ),
                      //                           );
                      //                         }
                      //                         return Text(
                      //                             snapshot.data.toString());
                      //                       },
                      //                     ),
                      //                   ))
                      //               .toList(),
                      //         ),
                      //       ),
                      //       // StreamBuilder<List<ScanResult>>(
                      //       //   stream: FlutterBluePlus.instance.scanResults,
                      //       //   initialData: const [],
                      //       //   builder: (c, snapshot) => Column(
                      //       //     children: snapshot.data!
                      //       //         .map(
                      //       //           (r) => ScanResultTile(
                      //       //             result: r,
                      //       //             onTap: () => Navigator.of(context).push(
                      //       //                 MaterialPageRoute(
                      //       //                     builder: (context) {
                      //       //               r.device.connect();
                      //       //               return DeviceScreen(device: r.device);
                      //       //             })),
                      //       //           ),
                      //       //         )
                      //       //         .toList(),
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
