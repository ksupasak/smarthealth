import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_health/local/classlocal.dart';
import 'package:smart_health/local/local.dart';
import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class Initsetting extends StatefulWidget {
  const Initsetting({super.key});

  @override
  State<Initsetting> createState() => _InitsettingState();
}

class _InitsettingState extends State<Initsetting> {
  TextEditingController name_hospital = TextEditingController();
  TextEditingController platfromURL = TextEditingController();
  TextEditingController checkqueueURL = TextEditingController();
  TextEditingController care_unit_id = TextEditingController();
  TextEditingController passwordsetting = TextEditingController();
  late List<RecordSnapshot<int, Map<String, Object?>>> nameHospital;
  Future<void> printDatabase() async {
    var knownDevice;

    nameHospital = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in nameHospital) {
      name_hospital.text = record['name_hospital'].toString();
      platfromURL.text = record['platfromURL'].toString();
      checkqueueURL.text = record['checkqueueURL'].toString();
      care_unit_id.text = record['care_unit_id'].toString();
      passwordsetting.text = record['passwordsetting'].toString();
      knownDevice = record['knownDevice'];
      print(name_hospital.text);
      print(platfromURL.text);
      print(checkqueueURL.text);
      print(care_unit_id.text);
      print(passwordsetting.text);
      for (var knownDevices in knownDevice) {
        print(knownDevices);
      }
    }
  }

  @override
  void initState() {
    printDatabase();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text('name_hospital'),
          TextField(controller: name_hospital),
          Text('platfromURL'),
          TextField(controller: platfromURL),
          Text('checkqueueURL'),
          TextField(controller: checkqueueURL),
          Text('care_unit_id'),
          TextField(controller: care_unit_id),
          Text('passwordsetting'),
          TextField(controller: passwordsetting),
          GestureDetector(
              onTap: () {
                setState(() {
                  addDataInfoToDatabase(context.read<DataProvider>());
                });
              },
              child: BoxWidetdew(
                  text: 'บันทึก',
                  height: 0.2,
                  width: 0.8,
                  color: Color.fromARGB(255, 54, 200, 244))),
        ],
      ),
    );
  }
}
