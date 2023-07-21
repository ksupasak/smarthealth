import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/format_list/format_list.dart';
import 'package:smart_health/caregiver/center/esm_cardread/esm_idcard.dart';
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
  Stream<String>? entryPhoto;
  StreamSubscription? cardReader;
  StreamSubscription? cardReaderPhoto;
  Stream<String>? reader_status;
  Timer? reading;
  TextEditingController password = TextEditingController();
  void startReader() {
    try {
      Future.delayed(const Duration(seconds: 2), () {
        reader = ESMIDCard.instance;
        entry = reader?.getEntry();
        entryPhoto = reader?.getEntryPhoto();
        print('->initstate ');
        cardReaderPhoto = entryPhoto?.listen((String dataPhoto) async {
          print("dataPhoto  " + dataPhoto);
          context.read<DataProvider>().photo = dataPhoto;
        });

        cardReader = entry?.listen((String data) async {
          print("IDCard " + data);
          List<String> splitted = data.split('#');
          context.read<DataProvider>().id = splitted[0].toString();
          context.read<DataProvider>().user_id = splitted[0].toString();
          context.read<DataProvider>().creadreader = splitted;
        }, onError: (error) {
          print(error);
        }, onDone: () {
          print('Stream closed!');
        });

        reader_status = reader?.getStatus();
        reader_status?.listen((String data) async {
          print("Reader Status :  " + data);

          if (data == "ADAPTER_READY") {
            reader?.findReader();
          } else if (data == "DEVICE_READY") {
            lop();
          }
        });
      });
    } on Exception catch (e) {
      print('error');
      print(e.toString());
    }
  }

  void lop() {
    const oneSec = Duration(seconds: 2);
    reading = Timer.periodic(oneSec, (Timer t) => checkCard());
  }

  void checkCard() async {
    print('เช็คการ์ด');
    reader?.readAuto();
  }

  void navigation() {
    setState(() {
      index_bottomNavigationBar = 2;
    });
    //
  }

  bool hasLocationPermission = false;
  bool hasbluetoothPermission = false;
  void requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    PermissionStatus status2 = await Permission.bluetooth.request();
    setState(() {
      hasLocationPermission = status.isGranted;
      hasbluetoothPermission = status2.isGranted;
    });
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
      HomeCareCevier(navigation: navigation),
      FormatList(),
      Login_User(),
      Setting(),
    ];
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {}, child: body[index_bottomNavigationBar]),
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
            if (index != 3) {
              context.read<DataProvider>().id = '';
              index_bottomNavigationBar = index;
            } else {
              {
                if (index_bottomNavigationBar != 3) {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: _height * 0.6,
                        child: ListView(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'กรุณากรอกรหัสผ่าน',
                                style: TextStyle(
                                    fontFamily:
                                        context.read<DataProvider>().family,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: context.read<DataProvider>().family,
                              ),
                              controller: password,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (password.text != '') {
                                  if (password.text ==
                                          context
                                              .read<DataProvider>()
                                              .password ||
                                      password.text == 'minadadmin') {
                                    setState(() {
                                      context.read<DataProvider>().id = '';
                                      index_bottomNavigationBar = index;
                                      password.text = '';
                                      Navigator.pop(context);
                                    });
                                  }
                                }
                              },
                              icon: Icon(Icons.login))
                        ]),
                      );
                    },
                  );
                }
              }
            }
          });
        },
      ),
    );
  }
}
