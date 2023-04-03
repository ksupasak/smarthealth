import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/device/hc08.dart';
import 'package:smart_health/provider/Provider.dart';

class scan extends StatefulWidget {
  const scan({super.key});

  @override
  State<scan> createState() => _scanState();
}

class _scanState extends State<scan> {
  void resdscan() {
    print('object1');
    FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.instance.connectedDevices.then((connectedDs) async {
      print('connectedDevices1 : ${connectedDs}');
      for (BluetoothDevice device in connectedDs) {
        if (device.id.toString() == 'B0:B1:13:76:0F:23') {
          setState(() {
            context.read<stringitem>().deviceidprovider == device;
          });
          print('เชื่อต่ออยู่เเล้ว');
        }
      }
    });
    FlutterBluePlus.instance.scanResults.listen((results) async {
      for (ScanResult r in results) {
        print('id = ${r.device.id} ${r.device.name}');
        if (r.device.id.toString() == "B0:B1:13:76:0F:23") {
          FlutterBluePlus.instance.connectedDevices.then((connectedDs) async {
            if (!connectedDs.contains(r.device)) {
              setState(() {
                context.read<stringitem>().deviceidprovider == r.device;
              });

              print('เชื่อมต่อ....');
              print('id = ${r.device.id} ${r.device.name}');
              await r.device.connect();
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    // resdscan();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBluePlus.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          return healtcheckservice();
        } else {
          FlutterBluePlus.instance.turnOn();
          return loading();
        }
      },
    );
  }
}

class loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.5,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class healtcheckservice extends StatefulWidget {
  const healtcheckservice({super.key});

  @override
  State<healtcheckservice> createState() => _healtcheckserviceState();
}

class _healtcheckserviceState extends State<healtcheckservice> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.5,
            color: Colors.amber,
            child: StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.instance.scanResults,
                initialData: const [],
                builder: (context, snapshot) {
                  return Text('');
                }),
          )
        ],
      ),
    );
  }
}
