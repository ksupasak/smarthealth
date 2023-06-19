// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// import 'package:http/http.dart' as http;
// import 'package:sembast/sembast.dart';
// import 'package:sembast/sembast_io.dart';
// import 'package:smarthealth/carecever/health_record/device/ad_ua651ble.dart';
// import 'package:smarthealth/carecever/health_record/device/hc08.dart';
// import 'package:smarthealth/carecever/health_record/device/hj_narigmed.dart';
// import 'package:smarthealth/carecever/health_record/device/mibfs.dart';
// import 'package:smarthealth/carecever/home/homeapp.dart';
// import 'package:smarthealth/myapp/provider/provider.dart';
// import 'package:smarthealth/myapp/setting/local.dart';

// import 'package:smarthealth/myapp/widgetdew.dart';

// class HealthRecord extends StatefulWidget {
//   const HealthRecord({super.key});

//   @override
//   State<HealthRecord> createState() => _HealthRecordState();
// }

// class _HealthRecordState extends State<HealthRecord> {
//   Timer? timer;
//   bool prevent = false;
//   bool ble = true;
//   List<dynamic>? convertedListdevice;

//   late List<RecordSnapshot<int, Map<String, Object?>>> init;
//   StreamSubscription? _streamSubscription;
//   StreamSubscription? _functionSubscription;
//   StreamSubscription? _functionDisconnect;
//   TextEditingController temp = TextEditingController();
//   TextEditingController weight = TextEditingController();
//   TextEditingController sys = TextEditingController();
//   TextEditingController dia = TextEditingController();
//   TextEditingController pulse = TextEditingController();
//   TextEditingController pr = TextEditingController();
//   TextEditingController spo2 = TextEditingController();
//   TextEditingController fbs = TextEditingController();
//   TextEditingController si = TextEditingController();
//   TextEditingController uric = TextEditingController();
//   TextEditingController height = TextEditingController();
//   void restartdata() {
//     timer = Timer.periodic(const Duration(seconds: 2), (_) {
//       //  test();
//       setState(() {
//         temp.text = context.read<DataProvider>().temp;
//         weight.text = context.read<DataProvider>().weight;
//         sys.text = context.read<DataProvider>().sys;
//         dia.text = context.read<DataProvider>().dia;
//         spo2.text = context.read<DataProvider>().spo2;
//         pr.text = context.read<DataProvider>().pr;
//         pulse.text = context.read<DataProvider>().pul;
//         fbs.text = context.read<DataProvider>().fbs;
//         si.text = context.read<DataProvider>().si;
//         uric.text = context.read<DataProvider>().uric;
//       });
//     });
//   }

//   void test() {}

//   @override
//   void dispose() {
//     _streamSubscription?.cancel();
//     _functionSubscription?.cancel();
//     _functionDisconnect?.cancel();
//     super.dispose();
//   }

//   void stop() {
//     setState(() {
//       timer?.cancel();
//       _functionDisconnect?.cancel();
//       _streamSubscription?.cancel();
//       _functionSubscription?.cancel();
//     });
//   }

//   void stop2() {
//     setState(() {
//       timer?.cancel();
//       _streamSubscription?.cancel();
//       _functionSubscription?.cancel();
//     });
//     ;
//   }

//   void chackrecorddata() async {
//     if (temp.text == '' ||
//         weight.text == '' ||
//         sys.text == '' ||
//         dia.text == '' ||
//         spo2.text == '' ||
//         pulse == '') {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Popup(
//               texthead: 'ข้อมูลไม่ครบ',
//               textbody: 'ต้องการส่งข้อมูลหรือไม่',
//               fontSize: 0.05,
//               pathicon: 'assets/warning.png',
//               buttonbar: [
//                 GestureDetector(
//                     onTap: () {
//                       //    context.read<Datafunction>().playsound();
//                       Navigator.pop(context);
//                     },
//                     child: MarkCheck(
//                         pathicon: 'assets/close.png',
//                         height: 0.05,
//                         width: 0.05)),
//                 SizedBox(width: 50),
//                 GestureDetector(
//                     onTap: () {
//                       recorddata();

//                       //   context.read<Datafunction>().playsound();
//                     },
//                     child: MarkCheck(
//                         pathicon: 'assets/check.png',
//                         height: 0.08,
//                         width: 0.08)),
//                 SizedBox(width: 50),
//               ],
//             );
//           });
//     } else {
//       print('value!=null');
//       recorddata();
//     }
//   }

//   void recorddata() async {
//     setState(() {
//       prevent = true;
//     });
//     var url = Uri.parse('${context.read<DataProvider>().platfromURL}/add_hr');
//     var res = await http.post(url, body: {
//       "public_id": context.read<DataProvider>().id,
//       "care_unit_id": context.read<DataProvider>().care_unit_id,
//       "temp": "${temp.text}",
//       "weight": "${weight.text}",
//       "bp_sys": "${sys.text}",
//       "bp_dia": "${dia.text}",
//       "pulse_rate": "${pulse.text}",
//       "spo2": "${spo2.text}",
//       "fbs": "${fbs.text}",
//       "height": "${height.text}",
//       "bmi": "",
//       "bp": "${sys.text}/${dia.text}",
//       "rr": "",
//     });
//     var resTojson = json.decode(res.body);

//     if (res.statusCode == 200) {
//       setState(() {
//         if (resTojson[' '] == "success") {
//           setState(() {
//             prevent = false;

//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return Popup(
//                       fontSize: 0.05,
//                       texthead: 'สำเร็จ',
//                       pathicon: 'assets/correct.png');
//                 });

//             Timer(Duration(seconds: 1), () {
//               stop();
//               Get.offNamed('user_information');
//             });
//           });
//         } else {
//           setState(() {
//             prevent = false;
//             setState(() {
//               prevent = false;
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Popup(
//                         texthead: 'ไม่สำเร็จ',
//                         textbody: 'message unsuccessful',
//                         pathicon: 'assets/warning (1).png');
//                   });
//             });
//           });
//         }
//       });
//     } else {
//       setState(() {
//         prevent = false;
//         setState(() {
//           prevent = false;
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return Popup(
//                     texthead: 'ไม่สำเร็จ',
//                     textbody: 'statusCode 404',
//                     pathicon: 'assets/warning (1).png');
//               });
//         });
//       });
//     }
//   }

//   void clearprovider() {
//     setState(() {
//       context.read<DataProvider>().temp = '';
//       context.read<DataProvider>().weight = '';
//       context.read<DataProvider>().sys = '';
//       context.read<DataProvider>().dia = '';
//       context.read<DataProvider>().spo2 = '';
//       context.read<DataProvider>().pr = '';
//       context.read<DataProvider>().pul = '';
//       context.read<DataProvider>().fbs = '';
//       context.read<DataProvider>().si = '';
//       context.read<DataProvider>().uric = '';
//     });
//   }

//   void bleScan() {
//     List<String> namescan;
//     var iddevice;
//     FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//     final Map<String, String> online_devices = HashMap();
//     namescan = DataProvider().namescan;
//     iddevice = DataProvider().iddevice;
//     StreamController<Map<String, String>> datas =
//         StreamController<Map<String, String>>();
//     restartdata();
//     print('กำลังหา device ID $convertedListdevice');
//     FlutterBluePlus.instance.scanResults.listen((results) {
//       // if (results.length > 0) {
//       //   ScanResult r = results.last;

//       //   if (namescan.contains(r.device.name.toString())) {
//       //     r.device.connect(); //Yuwell HT-YHW
//       //   }
//       // }
//       if (results.length > 0) {
//         ScanResult r = results.last;
//         // print(r.device.name);
//         if (namescan.contains(r.device.name.toString())) {
//           if (convertedListdevice!.contains(r.device.id.toString())) {
//             r.device.connect();
//             print('กำลังเชื่อมต่อ${r.device.name} id ${r.device.id}');
//           }
//         }
//       }

//       // if (results.length > 0) {
//       //   ScanResult r = results.last;
//       //   if (iddevice.contains(r.device.id)) {
//       //     print('จุดที่1 กำลังconnect ${r.device.id}');
//       //     r.device.connect();
//       //   }
//       // }
//     });

//     _streamSubscription = Stream.periodic(Duration(seconds: 5)).listen((_) {
//       FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
//       FlutterBluePlus.instance.scanResults.listen((results) {
//         if (results.length > 0) {
//           ScanResult r = results.last;
//           // print(r.device.name);
//           if (namescan.contains(r.device.name.toString())) {
//             if (convertedListdevice!.contains(r.device.id.toString())) {
//               r.device.connect();
//             }
//           }
//         }
//         // if (results.length > 0) {
//         //   ScanResult r = results.last;
//         //   if (iddevice.contains(r.device.id)) {
//         //     print('จุดที่2 กำลังconnect ${r.device.id}');
//         //     r.device.connect();
//         //   }
//         // }
//       });
//     });
//     _functionSubscription = Stream.periodic(Duration(seconds: 4))
//         .asyncMap((_) => flutterBlue.connectedDevices)
//         .listen((connectedDevices) {
//       connectedDevices.forEach((device) {
//         if (!convertedListdevice!.contains(device.id.toString())) {
//           device.disconnect();
//           print('กำลังยกเลิกเชื่อมต่อ${device.name} id ${device.id}');
//         }
//       });
//     });

//     _functionSubscription = Stream.periodic(Duration(seconds: 4))
//         .asyncMap((_) => flutterBlue.connectedDevices)
//         .listen((connectedDevices) {
//       connectedDevices.forEach((device) {
//         if (online_devices.containsKey(device.id.toString()) == false) {
//           online_devices[device.id.toString()] = device.name;
//           if (device.name == 'Yuwell HT-YHW') {
//             print('functionstreamtimeกำลังทำงาน ${device.name}');
//             //  HC-08
//             //  print("${device.id}");
//             //  if (device.id.toString().contains(iddevice)) {}  //ทำต่อ
//             Hc08 hc08 = Hc08(device: device);
//             hc08.parse().listen((temp) {
//               if (temp != null && temp != '') {
//                 Map<String, String> val = HashMap();
//                 val['temp'] = temp;
//                 datas.add(val);
//                 setState(() {
//                   context.read<DataProvider>().temp = temp;
//                 });
//               }
//             });
//           } else if (device.name == 'Yuwell BO-YX110-FDC7') {
//             print('functionstreamtimeกำลังทำงาน ${device.name}');
//             HjNarigmed hjNarigmed = HjNarigmed(device: device);
//             hjNarigmed.parse().listen((mVal) {
//               Map<String, String> val = HashMap();
//               val['spo2'] = mVal['spo2'];
//               val['pr'] = mVal['pr'];
//               datas.add(val);
//               setState(() {
//                 context.read<DataProvider>().spo2 = mVal['spo2'];
//                 context.read<DataProvider>().pr = mVal['pr'];
//               });
//             });
//           } else if (device.name == 'Yuwell BP-YE680A') {
//             print('functionstreamtimeกำลังทำงาน ${device.name}');
//             AdUa651ble adUa651ble = AdUa651ble(device: device);
//             adUa651ble.parse().listen((nVal) {
//               Map<String, String> val = HashMap();
//               val['sys'] = nVal['sys'];
//               val['dia'] = nVal['dia'];
//               val['pul'] = nVal['pul'];
//               datas.add(val);
//               setState(() {
//                 context.read<DataProvider>().sys = nVal['sys'];
//                 context.read<DataProvider>().dia = nVal['dia'];
//                 context.read<DataProvider>().pul = nVal['pul'];
//               });
//             });
//           } else if (device.name == 'MIBFS') {
//             print('functionstreamtimeกำลังทำงาน ${device.name}');
//             Mibfs mibfs = Mibfs(device: device);
//             mibfs.parse().listen((weight) {
//               Map<String, String> val = HashMap();
//               val['weight'] = weight;
//               datas.add(val);
//               setState(() {
//                 print(weight);
//                 context.read<DataProvider>().weight = weight;
//               });
//             });
//           }
//         }
//       });
//     });
//   }

//   Future<void> redipDatabase() async {
//     print('กำลังโหลดDevice');
//     init = await getdevice();
//     for (RecordSnapshot<int, Map<String, Object?>> record in init) {
//       context.read<DataProvider>().mapdevices = record['mapdevices'];
//     }
//     print(context.read<DataProvider>().mapdevices);
//     // print('splittedค่า');
//     // final splitted =
//     //     context.read<DataProvider>().mapdevices.toString().split(',');
//     // item = splitted;
//     // print(splitted);
//     print('โหลดเสร็จเเล้ว');
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         Future.delayed(const Duration(seconds: 1), () {
//           setState(() {
//             convertedListdevice = context
//                 .read<DataProvider>()
//                 .mapdevices
//                 .values
//                 .toList()
//                 .map((value) => value.toString())
//                 .toList(); //เเปลงmapเป็นList string

//             bleScan();
//           });
//         });
//       });
//     });
//   }

//   @override
//   void initState() {
//     clearprovider();
//     //  restartdata();
//     //   scanTimer();
//     redipDatabase();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     double heightsizedbox = _height * 0.02;
//     double heightline = _height * 0.03;
//     Color teamcolor = Color.fromARGB(255, 47, 174, 164);

//     return SafeArea(
//       child: Scaffold(
//         body: Stack(children: [
//           backgrund(),
//           Positioned(
//               child: ListView(children: [
//             Container(height: _height * 0.05),
//             BoxDecorate2(
//                 color: Color.fromARGB(255, 43, 179, 161),
//                 child: InformationCard(
//                     dataidcard: context.read<DataProvider>().resTojson)),
//             SizedBox(height: heightsizedbox),
//             BoxDecorate2(
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                   BoxRecord(
//                       image: 'assets/shr.png',
//                       texthead: 'HEIGHT',
//                       keyvavlue: height),
//                   Line(height: heightline, color: teamcolor),
//                   BoxRecord(
//                       image: 'assets/srhnate.png',
//                       texthead: 'WEIGHT',
//                       keyvavlue: weight),
//                 ])),
//             SizedBox(height: heightsizedbox),
//             BoxDecorate2(
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                   BoxRecord(
//                       image: 'assets/jhv.png', texthead: 'SYS', keyvavlue: sys),
//                   Line(height: heightline, color: teamcolor),
//                   BoxRecord(
//                       image: 'assets/jhvkb.png',
//                       texthead: 'DIA',
//                       keyvavlue: dia),
//                   Line(height: heightline, color: teamcolor),
//                   BoxRecord(
//                       image: 'assets/jhbjk;.png',
//                       texthead: 'PULSE',
//                       keyvavlue: pulse)
//                 ])),
//             SizedBox(height: heightsizedbox),
//             BoxDecorate2(
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                   BoxRecord(
//                       image: 'assets/jhgh.png',
//                       texthead: 'TEMP',
//                       keyvavlue: temp),
//                   Line(height: heightline, color: teamcolor),
//                   BoxRecord(
//                       image: 'assets/kauo.png',
//                       texthead: 'SPO2',
//                       keyvavlue: spo2),
//                 ])),
//             SizedBox(height: heightsizedbox),
//             Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                       height: _height * 0.2,
//                       child: Image.asset('assets/hraej.png')),
//                   SizedBox(height: _height * 0.01),
//                   Container(
//                     child: prevent == false
//                         ? GestureDetector(
//                             onTap: () {
//                               //    context.read<Datafunction>().playsound();

//                               chackrecorddata();
//                             },
//                             child: BoxWidetdew(
//                                 height: 0.06,
//                                 width: 0.3,
//                                 text: 'บันทึก',
//                                 fontSize: 0.05,
//                                 radius: 15.0,
//                                 color: Color(0xff31D6AA),
//                                 textcolor: Colors.white),
//                           )
//                         : Container(
//                             width: MediaQuery.of(context).size.width * 0.07,
//                             height: MediaQuery.of(context).size.width * 0.07,
//                             child: CircularProgressIndicator(),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ]))
//         ]),
//       ),
//     );
//   }
// }
