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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => FlutterBluePlus.instance
              .startScan(timeout: const Duration(seconds: 4)),
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
                          .listdevices
                          .contains(d)) {
                        context.read<DataProvider>().listdevices.add(d);
                      }
                      return ListTile(
                        title: Text(d.name),
                        trailing: StreamBuilder<BluetoothDeviceState>(
                          stream: d.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            if (snapshot.data ==
                                BluetoothDeviceState.connected) {
                              return ElevatedButton(
                                child: const Text('OPEN'),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeviceScreen(device: d))),
                              );
                            }
                            return Text(snapshot.data.toString());
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(const Duration(seconds: 2)).asyncMap(
                      (_) => FlutterBluePlus.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: context
                        .read<DataProvider>()
                        .listdevices
                        .map((d) => Container(
                              height: 50,
                              color: Colors.amber,
                              child: Column(
                                children: [
                                  Text(d.id.toString()),
                                  Text(d.name.toString()),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          height: 50,
          child: Center(
              child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => scanble())));
            },
            child: Container(
                height: 50,
                width: 100,
                color: Colors.green,
                child: Center(child: Text('สลับหน้า'))),
          ))),
    );
  }
}
