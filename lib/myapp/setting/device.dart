import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/local.dart';
import 'package:smart_health/myapp/setting/scan_ble.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  List<dynamic> item = [];
  List<MapEntry<String, Object?>> deviceList = [];
  Map<String, String> imagesdevice = {
    'FT_F5F30C4C52DE': '',
    'Yuwell HT-YHW': 'LINE_ALBUM_yuwell_230620.jpg',
    'Yuwell BP-YE680A': 'LINE_ALBUM_yuwell_230618.jpg',
    'Yuwell BO-YX110-FDC7': 'LINE_ALBUM_yuwell_230619.jpg',
    'MIBFS': '',
  };
  Map<String, String> namedevice = {
    'FT_F5F30C4C52DE': 'เครื่องอ่านบัตรประชน',
    'Yuwell HT-YHW': 'เครื่องวัดอุณหภูมิ',
    'Yuwell BP-YE680A': 'เครื่องวัดความดัน',
    'Yuwell BO-YX110-FDC7': 'เครื่องวัดspo2',
    'MIBFS': 'เครื่องชั่งน้ำหนัก',
  };
  Future<void> redipDatabase() async {
    print('กำลังโหลดDevice');
    init = await getdevice();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      context.read<DataProvider>().mapdevices = record['mapdevices'];
    }
    List<MapEntry<String, Object?>> deviceList =
        context.read<DataProvider>().mapdevices.entries.toList();
    print(context.read<DataProvider>().mapdevices);
    print(deviceList);

    print('โหลดเสร็จเเล้ว');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {});
        });
      });
    });
  }

  void deleteDiver(String name) async {
    print('กำลังลบdevice');
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

    mapdevices[name] = null;
    final key = await store.update(db, {
      'mapdevices': mapdevices,
    });
    setState(() {
      redipDatabase();
      print('ลบเสร็จเเล้ว');
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'ลบเสร็จเเล้ว',
                  )))));
        });
      });
    });

    await db.close();
  }

  // Future<void> update() async {
  //   final db = await openDatabasedevice();
  //   final store = intMapStoreFactory.store('smart_healt_device');
  //   var records = await store.find(db);

  //   final key = await store.update(db, {
  //     'mapdevices': context.read<DataProvider>().mapdevices,
  //   });

  //   await db.close();
  // }

  Future<void> addmapdevices() async {
    final db = await openDatabasedevice();
    final store = intMapStoreFactory.store('smart_healt_device');
    var records = await store.find(db);
    print(records);

    if ((records.length == 0)) {
      Map<String, Object?> mapdevices = {};
      final key = await store.add(db, {'mapdevices': mapdevices});
    }
    redipDatabase();
    await db.close();
  }

  @override
  void initState() {
    print('เข้าหน้าDevice');
    addmapdevices();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    BoxDecoration boxDecoration = BoxDecoration(border: Border.all());
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
///////////

            Container(
              height: _height * 0.5,
              child: ListView.builder(
                itemCount: deviceList.length,
                itemBuilder: (context, index) {
                  final entry = deviceList[index];
                  final key = entry.key;
                  final value = entry.value;

                  return ListTile(
                    title: Text(key),
                    subtitle: Text(value.toString()),
                  );
                },
              ),
            ),

            // Column(
            //   children: deviceList
            //       .map((d) => Dismissible(
            //             key: ValueKey(d),
            //             child: Container(
            //               height: 50,
            //               width: _width,
            //               color: Colors.green,
            //               child: Column(
            //                 children: [
            //                   Text("---"),
            //                 ],
            //               ),
            //             ),
            //             onDismissed: (direction) {
            //               setState(() {});
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                   SnackBar(content: Text('ลบอุปกรณ์ $d')));
            //             },
            //             confirmDismiss: (direction) async {
            //               return await showDialog(
            //                 context: context,
            //                 builder: (BuildContext context) {
            //                   return AlertDialog(
            //                     title: const Text("Confirm"),
            //                     content: const Text("ยกเลิกการเชื่อมต่อ"),
            //                     actions: <Widget>[
            //                       TextButton(
            //                           onPressed: () =>
            //                               Navigator.of(context).pop(false),
            //                           child: const Text("CANCEL")),
            //                       TextButton(
            //                           onPressed: () =>
            //                               Navigator.of(context).pop(true),
            //                           child: const Text("DELETE"))
            //                     ],
            //                   );
            //                 },
            //               );
            //             },
            //             background: Container(color: Colors.red),
            //           ))
            //       .toList(),
            // ),

////////
            Column(
              children: context.read<DataProvider>().mapdevices == null
                  ? []
                  : [
                      Container(
                          child: context
                                      .read<DataProvider>()
                                      .mapdevices['FT_F5F30C4C52DE'] ==
                                  null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDiver('FT_F5F30C4C52DE');
                                    },
                                    child: Container(
                                      height: _height * 0.05,
                                      decoration: boxDecoration,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('เครื่องอ่านบัตร'),
                                            Text(
                                                'FT_F5F30C4C52DE ${context.read<DataProvider>().mapdevices['FT_F5F30C4C52DE']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      Container(
                          child: context
                                      .read<DataProvider>()
                                      .mapdevices['Yuwell HT-YHW'] ==
                                  null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDiver('Yuwell HT-YHW');
                                    },
                                    child: Container(
                                      height: _height * 0.05,
                                      decoration: boxDecoration,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('เครื่องวัดอุณหภูมิ'),
                                            Text(
                                                'Yuwell HT-YHW ${context.read<DataProvider>().mapdevices['Yuwell HT-YHW']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      Container(
                          child: context
                                      .read<DataProvider>()
                                      .mapdevices['Yuwell BP-YE680A'] ==
                                  null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDiver('Yuwell BP-YE680A');
                                    },
                                    child: Container(
                                      height: _height * 0.05,
                                      decoration: boxDecoration,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('เครื่องวัดความดัน'),
                                            Text(
                                                'Yuwell BP-YE680A ${context.read<DataProvider>().mapdevices['Yuwell BP-YE680A']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      Container(
                          child: context
                                      .read<DataProvider>()
                                      .mapdevices['Yuwell BO-YX110-FDC7'] ==
                                  null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDiver('Yuwell BO-YX110-FDC7');
                                    },
                                    child: Container(
                                      height: _height * 0.05,
                                      decoration: boxDecoration,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('เครื่องspo2'),
                                            Text(
                                                'Yuwell BO-YX110-FDC7 ${context.read<DataProvider>().mapdevices['Yuwell BO-YX110-FDC7']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      Container(
                          child: context
                                      .read<DataProvider>()
                                      .mapdevices['MIBFS'] ==
                                  null
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteDiver('MIBFS');
                                    },
                                    child: Container(
                                      height: _height * 0.05,
                                      decoration: boxDecoration,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text('เครื่องชั่งน้ำหนัก'),
                                            Text(
                                                'MIBFS ${context.read<DataProvider>().mapdevices['MIBFS']}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                    ],
            ),

            SizedBox(height: _height * 0.02),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanBLE()));
              },
              child: Container(
                child: Center(
                  child: Container(
                      height: _height * 0.07,
                      width: _width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow()],
                          border: Border.all(
                              color: Color.fromARGB(255, 0, 85, 71), width: 2),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 85, 71),
                              fontSize: _width * 0.05),
                        ),
                      )),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                addmapdevices();
              },
              child: Container(
                child: Center(
                  child: Container(
                      height: _height * 0.07,
                      width: _width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow()],
                          border: Border.all(
                              color: Color.fromARGB(255, 0, 85, 71), width: 2),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          'reface',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 85, 71),
                              fontSize: _width * 0.05),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxTextFieldSetting extends StatefulWidget {
  BoxTextFieldSetting(
      {super.key,
      this.keyvavlue,
      this.texthead,
      this.textinputtype,
      this.lengthlimitingtextinputformatter});
  var keyvavlue;
  String? texthead;
  String? textinputtype;
  int? lengthlimitingtextinputformatter;
  @override
  State<BoxTextFieldSetting> createState() => _BoxTextFieldSettingState();
}

class _BoxTextFieldSettingState extends State<BoxTextFieldSetting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 19, 100, 92));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 0, 0, 0));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.texthead == null
                  ? Text('')
                  : Text(widget.texthead.toString(), style: style1),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow()],
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 85, 71), width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  width: _width * 0.9,
                  height: _height * 0.05,
                  child: widget.textinputtype == 'null' ||
                          widget.textinputtype == null
                      ? Text('')
                      : Text('${widget.textinputtype}')),
            ]),
      ),
    );
  }
}
