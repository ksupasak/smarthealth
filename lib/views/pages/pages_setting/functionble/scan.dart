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
  void initState() {
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    FlutterBluePlus.instance.stopScan();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              child: const Text('CONNECT'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                              ),
                              onPressed: (() {
                                // showModalBottomSheet(
                                //     backgroundColor:
                                //         Color.fromARGB(0, 255, 255, 255),
                                //     isScrollControlled: true,
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.vertical(
                                //             top: Radius.circular(10))),
                                //     context: context,
                                //     builder: (context) => Container());
                                r.advertisementData.connectable;
                              })),
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
