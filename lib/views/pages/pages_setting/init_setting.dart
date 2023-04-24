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
  void safe() async {
    context.read<DataProvider>().name_hospital = name_hospital.text;
    context.read<DataProvider>().platfromURL = platfromURL.text;
    context.read<DataProvider>().checkqueueURL = checkqueueURL.text;
    context.read<DataProvider>().care_unit_id = care_unit_id.text;
    context.read<DataProvider>().passwordsetting = passwordsetting.text;
    setState(() {
      addDataInfoToDatabase(context.read<DataProvider>());
      Navigator.pop(context);
    });
  }

  Future<void> printDatabase() async {
    var knownDevice;

    nameHospital = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in nameHospital) {
      name_hospital.text = record['name_hospital'].toString();
      platfromURL.text = record['platfromURL'].toString();
      checkqueueURL.text = record['checkqueueURL'].toString();
      care_unit_id.text = record['care_unit_id'].toString();
      passwordsetting.text = record['passwordsetting'].toString();
      knownDevice = record['device'];
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
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              height: _height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('name_hospital',
                      style: TextStyle(fontSize: _width * 0.05)),
                  TextField(
                      controller: name_hospital,
                      style: TextStyle(fontSize: _width * 0.05)),
                  Text('platfromURL',
                      style: TextStyle(fontSize: _width * 0.05)),
                  TextField(
                      controller: platfromURL,
                      style: TextStyle(fontSize: _width * 0.05)),
                  Text('checkqueueURL',
                      style: TextStyle(fontSize: _width * 0.05)),
                  TextField(
                      controller: checkqueueURL,
                      style: TextStyle(fontSize: _width * 0.05)),
                  Text('care_unit_id',
                      style: TextStyle(fontSize: _width * 0.05)),
                  TextField(
                      controller: care_unit_id,
                      style: TextStyle(fontSize: _width * 0.05)),
                  Text('passwordsetting',
                      style: TextStyle(fontSize: _width * 0.05)),
                  TextField(
                      controller: passwordsetting,
                      style: TextStyle(fontSize: _width * 0.05)),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Container(
                    child: Center(
                      child: GestureDetector(
                          onTap: () {
                            safe();
                          },
                          child: BoxWidetdew(
                              text: 'บันทึก',
                              height: 0.15,
                              width: 0.6,
                              textcolor: Colors.white,
                              fontSize: 0.05,
                              color: Color.fromARGB(255, 54, 200, 244))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
