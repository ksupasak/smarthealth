import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_health/views/pages/pages_setting/functionble/ble.dart';

class scanble extends StatefulWidget {
  const scanble({super.key});

  @override
  State<scanble> createState() => _scanbleState();
}

class _scanbleState extends State<scanble> {
  bool connectionstatus = false;
  void connectdevice(ScanResult r) async {
    setState(() {
      connectionstatus = true;
      r.device.connect();
    });
  }

  void initState() {
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    FlutterBluePlus.instance.stopScan();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.instance
            .startScan(timeout: const Duration(seconds: 4)),
        child: StreamBuilder<List<ScanResult>>(
          stream: FlutterBluePlus.instance.scanResults,
          initialData: const [],
          builder: (c, snapshot) => SafeArea(
            child: ListView(
              children: snapshot.data!
                  .map(
                    (r) => Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(r.device.name),
                              Text(r.device.id.toString()),
                            ],
                          ),
                          ElevatedButton(
                              child: r.advertisementData.connectable == true
                                  ? const Text('Connect')
                                  : const Text('Unable To Connect'),
                              style: ElevatedButton.styleFrom(
                                primary: r.advertisementData.connectable == true
                                    ? Colors.yellow
                                    : Color.fromARGB(0, 255, 17, 0),
                                onPrimary: Colors.white,
                              ),
                              onPressed: r.advertisementData.connectable == true
                                  ? (() {
                                      showModalBottomSheet(
                                          backgroundColor:
                                              Color.fromARGB(0, 255, 255, 255),
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(10))),
                                          context: context,
                                          builder: (context) => Container(
                                                color: Colors.white,
                                                height: _height * 0.5,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(r.device.name),
                                                      StreamBuilder<
                                                          BluetoothDeviceState>(
                                                        stream: r.device.state,
                                                        initialData:
                                                            BluetoothDeviceState
                                                                .disconnected,
                                                        builder: (c, snapshot) {
                                                          if (snapshot.data ==
                                                              BluetoothDeviceState
                                                                  .connected) {
                                                            return ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .green),
                                                              ),
                                                              child: const Text(
                                                                  'CONNECTED'),
                                                              onPressed: () {},
                                                            );
                                                          } else {
                                                            return ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .black),
                                                              ),
                                                              child: const Text(
                                                                  'CONNECT'),
                                                              onPressed: () {
                                                                r.device
                                                                    .connect();
                                                              },
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    })
                                  : null),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
