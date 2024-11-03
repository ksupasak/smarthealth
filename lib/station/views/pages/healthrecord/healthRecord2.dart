import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/views/pages/healthrecord/heightAndWidth.dart';
import 'package:smart_health/station/views/pages/healthrecord/pulseAndSysAndDia.dart';
import 'package:smart_health/station/views/pages/healthrecord/spo2.dart';
import 'package:smart_health/station/views/pages/healthrecord/sum.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class HealthRecord2 extends StatefulWidget {
  const HealthRecord2({super.key});

  @override
  State<HealthRecord2> createState() => _HealthRecord2State();
}

class _HealthRecord2State extends State<HealthRecord2> {
  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = context.watch<DataProvider>();
    return Scaffold(
      body: Stack(
        children: [
          const backgrund(),
          SizedBox(
            child: Column(
              children: [
                BoxTime(),
                BoxDecorate(
                    child: InformationCard(
                        dataidcard: context.read<DataProvider>().dataidcard)),
                SizedBox(
                  child: dataProvider.viewhealthrecord == "pulseAndSysAndDia"
                      ? const PulseAndSysAndDia()
                      : dataProvider.viewhealthrecord == "spo2"
                          ? const Spo2Healthrecord()
                          : dataProvider.viewhealthrecord == "sum"
                              ? const SumHealthrecord()
                              : const HeightAndWidth(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
