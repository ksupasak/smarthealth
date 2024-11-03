import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class Spo2Healthrecord extends StatefulWidget {
  const Spo2Healthrecord({super.key});

  @override
  State<Spo2Healthrecord> createState() => _Spo2HealthrecordState();
}

class _Spo2HealthrecordState extends State<Spo2Healthrecord> {
  TextEditingController spo2Healthrecord = TextEditingController();
  List availablePorts = [];
  void initPorts() {
    try {
      //    setState(() => availablePorts = SerialPort.availablePorts);
      debugPrint('Available ports: ${availablePorts.length}');
    } catch (e) {
      debugPrint('Error retrieving ports: $e');
      setState(() => availablePorts = []);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
        height: height,
        width: width,
        child: ListView(children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/kauo.png',
                    texthead: 'SPO2',
                    keyvavlue: spo2Healthrecord),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
                onPressed: () {
                  dataProvider.updateviewhealthrecord("pulseAndSysAndDia");
                  debugPrint(
                      context.read<DataProvider>().viewhealthrecord.toString());
                },
                child: const Text("ย้อนกลับ")),
            ElevatedButton(
                onPressed: () {
                  dataProvider.updateviewhealthrecord("sum");
                },
                child: const Text("ถัดไป"))
          ])
        ]));
  }
}
