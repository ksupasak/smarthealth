import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_health/blue2.dart';

class blue extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<blue> {
  StreamSubscription? _scanSubscription;
  List<ScanResult> _scanResults = [];

  Future<void> _startScan() async {
    // ลบผลการสแกนที่มีอยู่แล้ว
    //_scanResults.clear();

    // เริ่มสแกนหาอุปกรณ์ Bluetooth
    _scanSubscription = FlutterBluePlus.instance.scan().listen((scanResult) {
      setState(() {
        _scanResults.add(scanResult);
      });
    });
  }

  Future<void> _stopScan() async {
    // หยุดการสแกนหาอุปกรณ์ Bluetooth
    _scanResults.clear();
    await _scanSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();

    _startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan devices'),
      ),
      body: Column(
        children: [
          // StreamBuilder<List<int>>(
          //   builder: (c, snapshot) {
          //     final value = snapshot.data;

          //     return ExpansionTile(
          //       backgroundColor: Colors.amber,
          //       title: ListTile(
          //         title: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             const Text('CharacteristicEIEI'),
          //             Text('${c}'),
          //             Text('${snapshot.data}'), //ตรงนี้
          //           ],
          //         ),
          //         subtitle: Column(
          //           children: [
          //             Text(value.toString()),
          //             Text(value.toString()),
          //           ],
          //         ),
          //         contentPadding: const EdgeInsets.all(0.0),
          //       ),
          //     );
          //   },
          // ),
          ElevatedButton(
            onPressed: _startScan,
            child: Text('Start Scan'),
          ),
          ElevatedButton(
            onPressed: _stopScan,
            child: Text('Stop Scan'),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                final device = _scanResults[index].device;
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อ ' + device.name),
                      // Text('${device.canSendWriteWithoutResponse}'),
                      Text('${device.id}'),
                      //  Text('${device.isDiscoveringServices}'),
                      // Text("${device.services}")
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(device.id.toString()),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage2(
                          device: device,
                          value: '$device',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
