import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class HeightAndWidth extends StatefulWidget {
  const HeightAndWidth({super.key});

  @override
  State<HeightAndWidth> createState() => _HeightAndWidthState();
}

class _HeightAndWidthState extends State<HeightAndWidth> {
  TextEditingController heightHealthrecord = TextEditingController();
  TextEditingController weightHealthrecord = TextEditingController();
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
                    image: 'assets/shr.png',
                    texthead: 'HEIGHT',
                    keyvavlue: heightHealthrecord),
                BoxRecord(
                    image: 'assets/srhnate.png',
                    texthead: 'WEIGHT',
                    keyvavlue: weightHealthrecord),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
                onPressed: () {
                  //   dataProvider.updateViewHome("information");
                  debugPrint(
                      context.read<DataProvider>().viewhealthrecord.toString());
                },
                child: const Text("ย้อนกลับ")),
            ElevatedButton(
                onPressed: () {
                  dataProvider.updateviewhealthrecord("pulseAndSysAndDia");

                  context.read<DataProvider>().weight = weightHealthrecord.text;

                  debugPrint(
                      context.read<DataProvider>().viewhealthrecord.toString());
                },
                child: const Text("ถัดไป"))
          ])
        ]));
  }
}
