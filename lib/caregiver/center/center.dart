import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/caregiver/format_list/format_list.dart';
import 'package:smart_health/caregiver/center/esm_cardread/esm_idcard.dart';
import 'package:smart_health/caregiver/home/homeapp.dart';
import 'package:smart_health/caregiver/login/login.dart';
import 'package:smart_health/myapp/action/playsound.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/setting/setting.dart';

import 'package:dart_ping/dart_ping.dart';

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
  Timer? timer_internet;
  bool? false_internet = false;
  double? internet;
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
          print(splitted);
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
    keypad_sound();
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

  Future<void> _runPing() async {
    final ping = Ping('google.com', count: 5);
    ping.stream.listen((event) {
      if (event.response?.time!.inMicroseconds.toString() != null) {
        String originalString =
            '${event.response?.time!.inMicroseconds.toString()}';
        double convertedNumber = double.parse(originalString) / 1000;
        String resultString = convertedNumber.toStringAsFixed(1);
        internet = double.parse(resultString); //resultString ;
        // print(resultString);
      } else {
        internet = 0;
      }
    });
  }

  void start_runPing() async {
    timer_internet = Timer.periodic(Duration(seconds: 2), (t) {
      _runPing();
      if (internet == 0 && false_internet == false) {
        setState(() {
          false_internet = true;
          context.read<DataProvider>().status_internet = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'Internet Offline',
                )))));
      } else if (internet != 0 && false_internet == true) {
        setState(() {
          false_internet = false;
          context.read<DataProvider>().status_internet = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'Internet Online',
                )))));
      }
    });
  }

  @override
  void initState() {
    start_runPing();
    startReader();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    reading?.cancel();
    timer_internet?.cancel();
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
            keypad_sound();
            if (index != 3) {
              context.read<DataProvider>().id = '';
              index_bottomNavigationBar = index;
            } else {
              {
                if (index_bottomNavigationBar != 3) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: Container(
                          height: _height * 0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Column(children: [
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
                                  fontFamily:
                                      context.read<DataProvider>().family,
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
                        ),
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
