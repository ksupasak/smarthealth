import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/format_list/format_list.dart';
import 'package:smart_health/caregiver/home/esm_cardread/esm_idcard.dart';
import 'package:smart_health/caregiver/home/homeapp.dart';
import 'package:smart_health/caregiver/login/login.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/setting.dart';

class Center_Caregiver extends StatefulWidget {
  const Center_Caregiver({super.key});

  @override
  State<Center_Caregiver> createState() => _Center_CaregiverState();
}

class _Center_CaregiverState extends State<Center_Caregiver> {
  int index_bottomNavigationBar = 0;
  ESMIDCard? reader;
  Stream<String>? entry;
  StreamSubscription? cardReader;
  Stream<String>? reader_status;
  Timer? reading;
  void startReader() {
    try {
      Future.delayed(const Duration(seconds: 2), () {
        reader = ESMIDCard.instance;

        // reader?.findReader();

        entry = reader?.getEntry();

        print('->initstate ');
        if (entry != null) {
          print('entry!=null');
          // if (cardReader == null) {
          if (true) {
            cardReader = entry?.listen((String data) async {
              print("IDCard " + data);
              List<String> splitted = data.split('#');
              setState(() {});
              print(
                  "${context.read<DataProvider>().id} / ${splitted[0].toString()}");
              context.read<DataProvider>().id = splitted[0].toString();
              context.read<DataProvider>().user_id = splitted[0].toString();
              // idcard.setValue(splitted[0]);

              if (context.read<DataProvider>().id == splitted[0].toString()) {
              } else {}
            }, onError: (error) {
              print(error);
            }, onDone: () {
              print('Stream closed!');
            });
          }
        } else {
          print('entry ==null');
        }

        reader_status = reader?.getStatus();
        reader_status?.listen((String data) async {
          print("Reader Status :  " + data);

          if (data == "ADAPTER_READY") {
            reader?.findReader();
          } else if (data == "DEVICE_READY") {
            const oneSec = Duration(seconds: 2);
            reading = Timer.periodic(oneSec, (Timer t) => checkCard());
          }
        });
      });
    } on Exception catch (e) {
      print('error');
      print(e.toString());
    }
  }

  void checkCard() async {
    print('เช็คการ์ด');
    reader?.readAuto();
  }

  @override
  void initState() {
     startReader();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    reading?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [
      HomeCareCevier(),
      FormatList(),
      Login_User(),
      Setting(),
    ];
    return Scaffold(
      body: body[index_bottomNavigationBar],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff48B5AA),
        unselectedItemColor: Color(0x50000000),
        currentIndex: index_bottomNavigationBar,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: "รายการตรวจ", icon: Icon(Icons.format_list_numbered)),
          BottomNavigationBarItem(label: "User", icon: Icon(Icons.person)),
          BottomNavigationBarItem(
              label: "Settings", icon: Icon(Icons.settings)),
        ],
        onTap: (index) {
          setState(() {
            context.read<DataProvider>().id = '';
            index_bottomNavigationBar = index;
          });
        },
      ),
    );
  }
}
