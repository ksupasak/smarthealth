import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class PulseAndSysAndDia extends StatefulWidget {
  const PulseAndSysAndDia({super.key});

  @override
  State<PulseAndSysAndDia> createState() => _PulseAndSysAndDiaState();
}

class _PulseAndSysAndDiaState extends State<PulseAndSysAndDia> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
        height: height * 0.7,
        width: width,
        child: ListView(children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/jhv.png',
                    texthead: 'SYS',
                    keyvavlue: context.read<DataProvider>().sysHealthrecord),
                BoxRecord(
                    image: 'assets/jhvkb.png',
                    texthead: 'DIA',
                    keyvavlue: context.read<DataProvider>().diaHealthrecord),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        dataProvider.updateviewhealthrecord("heightAndWidth");
                      },
                      child: const Text("ย้อนกลับ")),
                  ElevatedButton(
                      onPressed: () {
                        dataProvider.updateviewhealthrecord("spo2");
                      },
                      child: const Text("ถัดไป"))
                ]),
          )
        ]));
  }
}
