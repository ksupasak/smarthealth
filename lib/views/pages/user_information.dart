// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_health/background/background.dart';
// import 'package:smart_health/background/color/style_color.dart';
// import 'package:smart_health/provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:smart_health/provider/provider_function.dart';
// import 'package:smart_health/views/pages/user_information2.dart';
// import 'package:smart_health/views/ui/widgetdew.dart/popup.dart';
// import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

// class UserInformation extends StatefulWidget {
//   const UserInformation({super.key});

//   @override
//   State<UserInformation> createState() => _UserInformationState();
// }

// class _UserInformationState extends State<UserInformation> {
//   var resTojson;
//   var resTojsonQueue;

//   void information() async {
//     var url =
//         Uri.parse('https://emr-life.com/clinic_master/clinic/Api/check_q');
//     var res = await http.post(url, body: {
//       // 'care_unit_id': '63d7a282790f9bc85700000e',
//       'public_id': context.read<DataProvider>().id,
//     });

//     setState(() {
//       resTojson = json.decode(res.body);
//       // print(resTojson['todays'].length.toString());
//       // print("----------->${resTojson}");
//       // print("health_records= ${resTojson['health_records'].length}");
//     });
//   }

//   Future<void> getqueue() async {
//     if (resTojson['health_records'].length == 0) {
//       context.read<DataProvider>().status_getqueue = 'false';
//       Get.toNamed('healthrecord');
//     } else {
//       context.read<DataProvider>().status_getqueue = 'true';
//       var url =
//           Uri.parse('https://emr-life.com/clinic_master/clinic/Api/get_q');
//       var res = await http.post(url, body: {
//         'public_id': context.read<DataProvider>().id,
//       });
//       if (res.statusCode == 200) {
//         setState(() {
//           resTojson = json.decode(res.body);
//         });
//       }
//     }
//   }

//   void checkhealth_records() async {
//     context.read<DataProvider>().resTojson = resTojson;
//     print('ปริ้นคิว');
//     Get.toNamed('printqueue');
//   }

//   void restart() async {
//     if (resTojson != null) {
//       init();
//     } else {
//       information();
//     }
//     while (resTojson == null) {
//       await Future.delayed(Duration(seconds: 1));
//       setState(() {});
//     }
//   }

//   void init() {
//     if (resTojson['queue_number'] == '' &&
//         resTojson['health_records'].length != 0 &&
//         context.read<DataProvider>().status_getqueue == 'false') {
//       getqueue();
//     }
//   }

//   Future<void> check_queue() async {
//     var url = Uri.parse('https://emr-life.com/clinic_master/clinic/Api/list_q');
//     var res = await http.post(url, body: {
//       'care_unit_id': '63d7a282790f9bc85700000e',
//     });

//     setState(() {
//       resTojsonQueue = json.decode(res.body);
//     });
//   }

//   Timer? _timer;
//   bool lop = false;
//   void voidlop() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         lop = true;
//         _timer?.cancel();
//       });
//     });
//   }

//   @override
//   void initState() {
//     restart();
//     check_queue();
//     voidlop();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             backgrund(),
//             lop == true
//                 ? resTojson != null || resTojsonQueue != null
//                     ? Positioned(
//                         child: ListView(
//                         children: [
//                           SizedBox(height: _height * 0.02),
//                           BoxDecorate(
//                               color: Color.fromARGB(255, 43, 179, 161),
//                               child: InformationCard(
//                                   dataidcard:
//                                       context.read<DataProvider>().dataidcard)),
//                           SizedBox(height: _height * 0.02),
//                           Column(
//                             children: resTojson['todays'].length != 0
//                                 ? resTojson['message'] == 'completed'
//                                     ? [
//                                         Container(
//                                           height: _height * 0.1,
//                                           width: _width * 0.5,
//                                           child:
//                                               Image.asset('assets/nurse.png'),
//                                         ),
//                                         Text(
//                                           'กรุณาติดต่อพยาบาล',
//                                           style: TextStyle(
//                                               color: Colors.green,
//                                               fontSize: _width * 0.06),
//                                         ),
//                                         SizedBox(height: _height * 0.02)
//                                       ]
//                                     : resTojson['message'] == 'finished'
//                                         ? [
//                                             Text(
//                                               'การทำรายการเสร็จสมบูรณ์',
//                                               style: TextStyle(
//                                                   color: Colors.green,
//                                                   fontSize: _width * 0.06),
//                                             ),
//                                             SizedBox(height: _height * 0.02)
//                                           ]
//                                         : [
//                                             Column(
//                                               children: resTojson[
//                                                           'queue_number'] !=
//                                                       ''
//                                                   ? [
//                                                       resTojsonQueue['queue_number']
//                                                                   .toString() !=
//                                                               resTojson[
//                                                                       'queue_number']
//                                                                   .toString()
//                                                           ? Container(
//                                                               height:
//                                                                   _height * 0.1,
//                                                               width:
//                                                                   _width * 0.5,
//                                                               child: Image.asset(
//                                                                   'assets/queue.png'),
//                                                             )
//                                                           : Container(
//                                                               height:
//                                                                   _height * 0.1,
//                                                               width:
//                                                                   _width * 0.5,
//                                                               child: Image.asset(
//                                                                   'assets/doctor.png'),
//                                                             ),
//                                                       resTojsonQueue[
//                                                                       'queue_number']
//                                                                   .toString() !=
//                                                               resTojson[
//                                                                       'queue_number']
//                                                                   .toString()
//                                                           ? Text(
//                                                               'กรุณารอเรียกคิว... ',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .blue,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w700,
//                                                                   fontSize:
//                                                                       _width *
//                                                                           0.06))
//                                                           : Text(
//                                                               'เข้าตรวจ',
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .green,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w700,
//                                                                   fontSize:
//                                                                       _width *
//                                                                           0.06)),
//                                                     ]
//                                                   : [
//                                                       Container(
//                                                         height: _height * 0.15,
//                                                         width: _width * 0.5,
//                                                         child: Image.asset(
//                                                             'assets/date.png'),
//                                                       ),
//                                                       Text(
//                                                           'มีกำหนดการนัดหมายวันนี้',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.green,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w700,
//                                                               fontSize: _width *
//                                                                   0.06)),
//                                                     ],
//                                             ),
//                                             SizedBox(height: _height * 0.02),
//                                             resTojson['queue_number'] != ''
//                                                 ? resTojsonQueue['queue_number']
//                                                             .toString() !=
//                                                         resTojson[
//                                                                 'queue_number']
//                                                             .toString()
//                                                     ? BoxQueue(
//                                                         // queue:
//                                                         //     '${resTojson['queue_number']}'
//                                                         )
//                                                     : BoxButtonVideoCall()
//                                                 : GestureDetector(
//                                                     onTap: () {
//                                                       context
//                                                           .read<Datafunction>()
//                                                           .playsound();

//                                                       getqueue();
//                                                     },
//                                                     child: BoxWidetdew(
//                                                       height: 0.06,
//                                                       width: 0.7,
//                                                       text: 'รับคิว',
//                                                       textcolor: Colors.white,
//                                                       color: Color.fromARGB(
//                                                           100, 42, 208, 20),
//                                                       radius: 0.0,
//                                                     ),
//                                                   ),
//                                             SizedBox(height: _height * 0.01),
//                                             resTojson['queue_number'] != ''
//                                                 ? resTojson['message'] !=
//                                                         'completed'
//                                                     ? resTojsonQueue[
//                                                                     'queue_number']
//                                                                 .toString() !=
//                                                             resTojson[
//                                                                     'queue_number']
//                                                                 .toString()
//                                                         ? resTojson['message'] ==
//                                                                 'finished'
//                                                             ? Container()
//                                                             : GestureDetector(
//                                                                 onTap: () {
//                                                                   context
//                                                                       .read<
//                                                                           Datafunction>()
//                                                                       .playsound();
//                                                                   setState(() {
//                                                                     context
//                                                                         .read<
//                                                                             DataProvider>()
//                                                                         .resTojson = resTojson;
//                                                                   });
//                                                                   Get.toNamed(
//                                                                       'printqueue');
//                                                                 },
//                                                                 child: Container(
//                                                                     width: _width,
//                                                                     child: Center(
//                                                                         child: BoxWidetdew(
//                                                                       height:
//                                                                           0.06,
//                                                                       width:
//                                                                           0.35,
//                                                                       color: Colors
//                                                                           .blue,
//                                                                       radius:
//                                                                           5.0,
//                                                                       text:
//                                                                           'ปริ้นคิว',
//                                                                       textcolor:
//                                                                           Colors
//                                                                               .white,
//                                                                     ))),
//                                                               )
//                                                         : Container()
//                                                     : Container()
//                                                 : Container(),
//                                             SizedBox(height: _height * 0.01),
//                                             resTojson['appointments'].length !=
//                                                     0
//                                                 ? Column(
//                                                     children: [
//                                                       HeadBoxAppointments(),
//                                                       BoxAppointments(
//                                                           // list_appointments:
//                                                           //     resTojson[
//                                                           //         'appointments']
//                                                           ),
//                                                     ],
//                                                   )
//                                                 : SizedBox(),
//                                             SizedBox(height: _height * 0.02),
//                                             Container(
//                                                 child:
//                                                     resTojson['health_records']
//                                                                 .length !=
//                                                             0
//                                                         ? Column(
//                                                             children: [
//                                                               BoxShoHealth_Records(),
//                                                               SizedBox(
//                                                                   height:
//                                                                       _height *
//                                                                           0.01),
//                                                             ],
//                                                           )
//                                                         : Container(
//                                                             child:
//                                                                 GestureDetector(
//                                                               onTap: () {
//                                                                 context
//                                                                     .read<
//                                                                         Datafunction>()
//                                                                     .playsound();

//                                                                 Get.toNamed(
//                                                                     'healthrecord');
//                                                               },
//                                                               child: Container(
//                                                                   width: _width,
//                                                                   child: Center(
//                                                                       child: BoxWidetdew(
//                                                                           height:
//                                                                               0.055,
//                                                                           width:
//                                                                               0.35,
//                                                                           color: Color.fromARGB(
//                                                                               100,
//                                                                               42,
//                                                                               208,
//                                                                               20),
//                                                                           radius:
//                                                                               5.0,
//                                                                           text:
//                                                                               'ตรวจสุขภาพ',
//                                                                           textcolor: Color.fromARGB(
//                                                                               255,
//                                                                               255,
//                                                                               255,
//                                                                               255)))),
//                                                             ),
//                                                           )),
//                                             resTojsonQueue['queue_number']
//                                                         .toString() ==
//                                                     resTojson['queue_number']
//                                                         .toString()
//                                                 ? SizedBox()
//                                                 : GestureDetector(
//                                                     onTap: () {
//                                                       context
//                                                           .read<Datafunction>()
//                                                           .playsound();

//                                                       Get.toNamed(
//                                                           'healthrecord');
//                                                     },
//                                                     child: Container(
//                                                         width: _width,
//                                                         child: Center(
//                                                             child: resTojson[
//                                                                             'health_records']
//                                                                         .length !=
//                                                                     0
//                                                                 ? BoxWidetdew(
//                                                                     height:
//                                                                         0.055,
//                                                                     width: 0.35,
//                                                                     color: Colors
//                                                                         .blue,
//                                                                     radius: 5.0,
//                                                                     text:
//                                                                         'เเก้ใขสุขภาพ',
//                                                                     textcolor:
//                                                                         Colors
//                                                                             .white)
//                                                                 : SizedBox())),
//                                                   ),
//                                             SizedBox(height: _height * 0.005),
//                                           ]
//                                 : [
//                                     Text(
//                                       'คุณไม่มีนัดหมายในวันนี้',
//                                       style: TextStyle(
//                                           color: Colors.red,
//                                           fontSize: _width * 0.05),
//                                     ),
//                                   ],
//                           ),

//                           //    BoxButtonVideoCall()

//                           ///
//                           ///
//                           GestureDetector(
//                             onTap: () {
//                               context.read<Datafunction>().playsound();
//                               Get.offNamed('home');
//                             },
//                             child: Container(
//                                 width: _width,
//                                 child: Center(
//                                     child: BoxWidetdew(
//                                   height: 0.06,
//                                   width: 0.35,
//                                   color: Colors.red,
//                                   radius: 5.0,
//                                   text: 'ออก',
//                                   textcolor: Colors.white,
//                                 ))),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               context.read<Datafunction>().playsound();
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           UserInformation2()));
//                             },
//                             child: Container(
//                                 width: _width,
//                                 child: Center(
//                                     child: BoxWidetdew(
//                                   height: 0.06,
//                                   width: 0.35,
//                                   color: Color.fromARGB(255, 147, 147, 147),
//                                   radius: 5.0,
//                                   text: 'test',
//                                   textcolor: Colors.white,
//                                 ))),
//                           ),
//                         ],
//                       ))
//                     : Container(
//                         width: MediaQuery.of(context).size.width * 0.07,
//                         height: MediaQuery.of(context).size.width * 0.07,
//                         child: CircularProgressIndicator(),
//                       )
//                 : CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }
