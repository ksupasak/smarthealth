import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/local.dart';

class ScanBLE extends StatefulWidget {
  const ScanBLE({super.key});

  @override
  State<ScanBLE> createState() => _ScanBLEState();
}

class _ScanBLEState extends State<ScanBLE> {
  bool button = false;
  List<String> namescan = DataProvider().namescan;
  List<ScanResult> listscan = [];
  List<BluetoothDevice> connected = [];
  Map<String, String> listadddevice = {};
  StreamSubscription? _functionscanconnected;
  void scan() {
    setState(() {
      button = true;
    });
    Future.delayed(const Duration(seconds: 12), () {
      setState(() {
        button = false;
        scanconnected();
      });
    });
    print('กำลังเเสกน');
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 10));
    FlutterBluePlus.instance.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;
        if (namescan.contains(r.device.name.toString())) {
          print('เจอdeviceที่กำหนด');
          print("name= ${r.device.name} id= ${r.device.id}");
          if (!listscan.contains(r)) {
            listscan.add(r);
          }
        }
      }
    });
  }

  Future<void> scanconnected() async {
    setState(() {
      button = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        button = false;
      });
    });
    print('กำลังเเสกนdeviceที่เคยconnect');

    // _functionscanconnected = Stream.periodic(Duration(seconds: 4))
    //     .asyncMap((_) => FlutterBluePlus.instance.connectedDevices)
    //     .listen((connectedDevices) {
    //   print(connectedDevices);
    // });

    List<BluetoothDevice> devices =
        await FlutterBluePlus.instance.connectedDevices;

    setState(() {
      print(devices.length);
      devices.forEach((device) {
        print(device.id);
        connected.add(device);
      });
    });
  }

  Future<void> adddevice(String name, String id) async {
    final db = await openDatabasedevice();
    final store = intMapStoreFactory.store('smart_healt_device');
    var records = await store.find(db);

    Map<String, Object?> mapdevices = {};

    for (RecordSnapshot<int, Map<String, Object?>> record in records) {
      var getmapd = record['mapdevices'];
      if (getmapd != null) {
        mapdevices = Map.fromEntries((getmapd as Map<String, Object?>).entries);
      }
    }

    mapdevices[name] = id;
    final key = await store.update(db, {
      'mapdevices': mapdevices,
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'เพิ่ม $name $id เเล้ว',
                )))));
      });
    });
    await db.close();
  }

  @override
  void initState() {
    print('เข้าหน้าเเสกน');
    scan();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(children: [
        Column(
          children: [
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listscan.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        child: listscan[index].device.name ==
                                                'Yuwell HT-YHW'
                                            ? Text('เครื่องวัดอุณหภูมิ')
                                            : listscan[index].device.name ==
                                                    'Yuwell BO-YX110-FDC7'
                                                ? Text('เครื่องspo')
                                                : listscan[index].device.name ==
                                                        'Yuwell BP-YE680A'
                                                    ? Text('เครื่องวัดความดัน')
                                                    : listscan[index]
                                                                .device
                                                                .name ==
                                                            'MIBFS'
                                                        ? Text(
                                                            'เครื่องชั่งน้ำหนัก')
                                                        : listscan[index]
                                                                    .device
                                                                    .name ==
                                                                'FT_F5F30C4C52DE'
                                                            ? Text(
                                                                'เครื่องอ่านบัตร')
                                                            : Text('--')),
                                  ],
                                ),
                                Text(
                                    "ยี่ห้อ ${listscan[index].device.name} id ${listscan[index].device.id}"),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          adddevice(listscan[index].device.name,
                              listscan[index].device.id.toString());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: connected.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        child: connected[index].name ==
                                                'Yuwell HT-YHW'
                                            ? Text('เครื่องวัดอุณหภูมิ')
                                            : connected[index].name ==
                                                    'Yuwell BO-YX110-FDC7'
                                                ? Text('เครื่องspo')
                                                : connected[index].name ==
                                                        'Yuwell BP-YE680A'
                                                    ? Text('เครื่องวัดความดัน')
                                                    : connected[index].name ==
                                                            'MIBFS'
                                                        ? Text(
                                                            'เครื่องชั่งน้ำหนัก')
                                                        : Text('--')),
                                  ],
                                ),
                                Text(
                                    "ยี่ห้อ ${connected[index].name} id ${connected[index].id} เคยเชื่อมต่อ"),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          adddevice(connected[index].name,
                              connected[index].id.toString());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        button == false
            ? GestureDetector(
                onTap: scan,
                child: Container(
                  child: Center(
                    child: Container(
                        height: 50,
                        width: _width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow()],
                            border: Border.all(
                                color: Color.fromARGB(255, 0, 85, 71),
                                width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            'เเสกน',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 85, 71),
                                fontSize: _width * 0.05),
                          ),
                        )),
                  ),
                ),
              )
            : Container(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.width * 0.05,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
      ]),
    );
  }
}
