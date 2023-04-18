import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/provider/provider.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  var device;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<BluetoothDevice>>(
          stream: Stream.periodic(const Duration(seconds: 2))
              .asyncMap((_) => FlutterBluePlus.instance.connectedDevices),
          builder: (context, snapshot) {
            return Container();
          },
        ),
      ),
    );
  }
}
