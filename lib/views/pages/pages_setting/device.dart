import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/local/classlocal.dart';
import 'package:smart_health/local/local.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/pages/pages_setting/functionble/ble.dart';
import 'package:smart_health/views/pages/pages_setting/functionble/scan.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  var device;
  List<BluetoothDevice> j = [];
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(const Duration(seconds: 2)).asyncMap(
                      (_) => FlutterBluePlus.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!.map((d) {
                      if (!context
                          .read<DataProvider>()
                          .knownDevice
                          .contains(d.name)) {
                        context.read<DataProvider>().knownDevice.add(d.name);
                      }
                      return ListTile(
                        title: Text(d.name),
                        trailing: StreamBuilder<BluetoothDeviceState>(
                          stream: d.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            if (snapshot.data ==
                                BluetoothDeviceState.connected) {
                              return Text(snapshot.data.toString());
                            }
                            return Text(snapshot.data.toString());
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  children: context
                      .read<DataProvider>()
                      .knownDevice
                      .map((d) => Dismissible(
                            key: ValueKey(d),
                            child: Container(
                              height: 50,
                              width: _width,
                              color: Colors.amber,
                              child: Column(
                                children: [
                                  Text(d),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() async {
                                //
                                List<BluetoothDevice> connectedDevices = [];
                                List<BluetoothDevice> devices =
                                    await FlutterBluePlus
                                        .instance.connectedDevices;
                                connectedDevices = devices;
                                print('Connected devices: ${devices.length}');
                                for (BluetoothDevice device in devices) {
                                  if (device.name == d) {
                                    device.disconnect();
                                  }
                                }
                                //
                                context
                                    .read<DataProvider>()
                                    .knownDevice
                                    .remove(d);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$d dismissed')));
                            },
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text(
                                        "เปิดอุปกรณ์เพื่อยกเลิกการเชื่อมต่อ"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("CANCEL")),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("DELETE"))
                                    ],
                                  );
                                },
                              );
                            },
                            background: Container(color: Colors.red),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            height: 50,
            child: Row(children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => scanble())));
                  },
                  child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.green,
                      child: Center(child: Text('สลับหน้า')))),
              GestureDetector(
                  onTap: () {
                    print(context.read<DataProvider>().knownDevice);
                  },
                  child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.red,
                      child: Center(child: Text('P')))),
              GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.pink,
                      child: Center(child: Text('r')))),
            ])),
      ),
    );
  }
}
