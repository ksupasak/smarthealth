import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openvidu_client/openvidu_client.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_health/carecever/videocall/app/models/connection.dart';
import 'package:smart_health/carecever/videocall/app/utils/extensions.dart';
import 'package:smart_health/carecever/videocall/app/widgets/config_view.dart';
import 'package:smart_health/carecever/videocall/app/widgets/controls.dart';
import 'package:smart_health/carecever/videocall/app/widgets/media_stream_view.dart';
import 'package:smart_health/carecever/widget/informationCard.dart';
import 'package:smart_health/myapp/provider/provider.dart';
import 'package:smart_health/myapp/widgetdew.dart';

class PrePareVideo extends StatefulWidget {
  const PrePareVideo({super.key});

  @override
  State<PrePareVideo> createState() => _PrePareVideoState();
}

class _PrePareVideoState extends State<PrePareVideo> {
  var data;
  var resTojson;

  String? status;
  Timer? timer;
  late OpenViduClient _openvidu;

  Future<void> get_path_video() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/get_video');
    var res = await http
        .post(url, body: {'public_id': context.read<DataProvider>().id});
    resTojson = json.decode(res.body);
    setState(() {
      data = resTojson['data'];
      print(" data resTojson = $data");
    });
  }

  void check_statusconnectvideo() async {
    await get_path_video();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (resTojson['data'][0] == null && resTojson['data'].isNotEmpty) {
        timer!.cancel();
      } else {
        get_path_video();
      }
    });
  }

  void getqueue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id
    });

    if (res.statusCode == 200) {
      var messagejson = json.decode(res.body);
      print(messagejson);
      check_statusconnectvideo();
    }
  }

  @override
  void initState() {
    getqueue();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return resTojson != null
        ? resTojson['data'][0] == null && resTojson['data'].isNotEmpty
            ? Scaffold(
                body: Center(
                  child: RoomPage(
                    userName: ' UserName ',
                    data: data,
                  ),
                ),
              )
            : Scaffold(
                body: Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'กำลังรอหมอ',
                          style: TextStyle(
                            fontSize: _width * 0.06,
                            fontWeight: FontWeight.w400,
                            fontFamily: context.read<DataProvider>().family,
                            color: Color(0xff00A3FF),
                            shadows: [
                              Shadow(
                                color: Colors.grey,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 139, 130),
                        ),
                      ),
                      // Text(
                      //     'ไม่มี ข้อมูลการเชื่อมต่อvideo resTojson["data"]={}'),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text('กลับ'),
                      //   ),
                      // ),
                    ],
                  )),
                ),
              )
        : Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: _width,
                      height: _height,
                      child: SvgPicture.asset(
                        'assets/splash/backlogo2.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: _width,
                      height: _width,
                      child: Center(
                        child: Container(
                          width: _height * 0.8,
                          height: _height * 0.8,
                          child: SvgPicture.asset('assets/splash/logo.svg'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: _height,
                      width: _width,
                      child: Center(
                        child: Container(
                          height: _height,
                          width: _width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'กำลังเชื่อมต่อวีดีโอ',
                                  style: TextStyle(
                                    fontSize: _width * 0.06,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        context.read<DataProvider>().family,
                                    color: Color(0xff00A3FF),
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 0, 139, 130),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );

    //  Scaffold(
    //     body: Stack(
    //       children: [
    //         Positioned(
    //             child: Container(
    //           height: _height,
    //           width: _width,
    //           child: SvgPicture.asset(
    //             'assets/login.svg',
    //             fit: BoxFit.fill,
    //           ),
    //         )),
    //         Positioned(
    //           child: Container(
    //             height: _height,
    //             width: _width,
    //             child: Center(
    //               child: Container(
    //                 height: _height * 0.06,
    //                 width: _width,
    //                 child: Center(
    //                   child: Text(
    //                     'กำลังเชื่อมต่อวีดีโอ',
    //                     style: TextStyle(
    //                       fontSize: _width * 0.05,
    //                       fontWeight: FontWeight.w500,
    //                       fontFamily: context.read<DataProvider>().family,
    //                       color: Color(0xff00A3FF),
    //                       shadows: [
    //                         Shadow(
    //                           color: Colors.grey,
    //                           offset: Offset(2, 2),
    //                           blurRadius: 4,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   );
  }
}

class RoomPage extends StatefulWidget {
  final String userName;
  var data;
  RoomPage({
    super.key,
    required this.userName,
    this.data,
  });
  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  Map<String, RemoteParticipant> remoteParticipants = {};
  MediaDeviceInfo? input;
  bool isInside = false;
  late OpenViduClient _openvidu;
  var resTojson;
  var resTojson2;
  String? status;
  Offset position = Offset(5, 5);
  LocalParticipant? localParticipant;

  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    _openvidu.disconnect();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    Logger().d("finish init");

    initOpenVidu();
    _listenSessionEvents();
    _onConnect();
    // TODO: implement initState
    super.initState();
  }

  Future<void> initOpenVidu() async {
    _openvidu = OpenViduClient('https://pcm-life.com:4443/openvidu');
    localParticipant =
        await _openvidu.startLocalPreview(context, StreamMode.frontCamera);
    setState(() {});
  }

  void _listenSessionEvents() {
    _openvidu.on(OpenViduEvent.userJoined, (params) async {
      await _openvidu.subscribeRemoteStream(params["id"]);
    });
    _openvidu.on(OpenViduEvent.userPublished, (params) {
      Logger().e("userPublished");

      _openvidu.subscribeRemoteStream(params["id"],
          video: params["videoActive"], audio: params["audioActive"]);
    });

    _openvidu.on(OpenViduEvent.addStream, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });

    _openvidu.on(OpenViduEvent.removeStream, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });

    _openvidu.on(OpenViduEvent.publishVideo, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });
    _openvidu.on(OpenViduEvent.publishAudio, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });
    _openvidu.on(OpenViduEvent.updatedLocal, (params) {
      localParticipant = params['localParticipant'];
      setState(() {});
    });
    _openvidu.on(OpenViduEvent.reciveMessage, (params) {
      context.showMessageRecivedDialog(params["data"] ?? '');
    });
    _openvidu.on(OpenViduEvent.userUnpublished, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });

    _openvidu.on(OpenViduEvent.error, (params) {
      context.showErrorDialog(params["error"]);
    });
  }

  Future<void> _onConnect() async {
    Logger().e("start on Connect");
    dynamic connectstring = widget.data;
    print("connectstring เชื่อมต่อ  $connectstring");
    if (true) {
      final connection = Connection.fromJson(connectstring);
      Logger().i(connection.token!);
      localParticipant = await _openvidu.publishLocalStream(
          token: connection.token!, userName: widget.userName);
      setState(() {
        isInside = true;
      });
    }
  }

  void _onTapDisconnect() async {
    final nav = Navigator.of(context);
    final result = await context.showDisconnectDialog();
    if (result == true) {
      await _openvidu.disconnect();
    }
    Navigator.pop(context);
  }

  // Future<void> status_video() async {
  //   var url = Uri.parse(
  //       '${context.read<DataProvider>().platfromURL}/get_video_status');
  //   var res = await http
  //       .post(url, body: {'public_id': context.read<DataProvider>().id});
  //   resTojson2 = json.decode(res.body);
  //   if (resTojson2 != null) {
  //     status = resTojson2['message'];
  //     if (status == 'completed' || status == 'finished' || status == 'end') {
  //       print('คุยเสร็จเเล้ว');
  //       _timer?.cancel();
  //       _openvidu.disconnect();
  //       Get.offNamed('user_information');
  //     } else {
  //       print('คุยยังไม่เสร็จ');
  //       print(status);
  //     }
  //   }
  // }
  // void lop() {
  //   _timer = Timer.periodic(Duration(seconds: 2), (timer) {
  //     print('เช็คstatus');
  //     status_video();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          backgrund(),
          Positioned(
            child: localParticipant == null
                ? Container(
                    width: _width,
                    height: _height,
                  )
                : !isInside
                    ? Container(
                        height: _height,
                        child: ListView(children: [
                          Container(height: _height * 0.08),
                          Center(
                            child: Container(
                                width: _width * 0.9,
                                height: _height * 0.14,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                        color: Color(0xff48B5AA),
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                                child: Center(
                                    child: InformationCard(
                                  dataidcard:
                                      context.read<DataProvider>().resTojson,
                                ))),
                          ),
                          Container(
                            height: _height * 0.06,
                            width: _width,
                            child: Center(
                              child: Text(
                                'เตรียมความพร้อม',
                                style: TextStyle(
                                    fontSize: _width * 0.05,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        context.read<DataProvider>().family,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                          ),
                          Container(
                              child: ConfigView(
                                  participant: localParticipant!,
                                  onConnect: _onConnect)),
                          // Container(height: _height * 0.02),
                          // GestureDetector(
                          //   onTap: _onConnect,
                          //   child: Container(
                          //     child: Center(
                          //       child: Container(
                          //         width: _width * 0.7,
                          //         height: _height * 0.08,
                          //         decoration: BoxDecoration(
                          //             boxShadow: [
                          //               BoxShadow(
                          //                   color: Colors.grey,
                          //                   offset: Offset(0, 2),
                          //                   blurRadius: 2,
                          //                   spreadRadius: 1)
                          //             ],
                          //             color: Color(0xff31D6AA),
                          //             borderRadius: BorderRadius.circular(10)),
                          //         child: Center(
                          //             child: Text(
                          //           'ยืนยันการวีดีโอคอล',
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: _width * 0.06,
                          //               fontFamily: context
                          //                   .read<DataProvider>()
                          //                   .family),
                          //         )),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ]))
                    : Container(
                        child: Stack(children: [
                          Positioned(
                            child: Container(
                              child: ListView.builder(
                                  itemCount:
                                      math.max(0, remoteParticipants.length),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final remote = remoteParticipants.values
                                        .elementAt(index);
                                    return Container(
                                      width: _width /
                                          math.max(
                                              1, remoteParticipants.length),
                                      height: _height /
                                          math.max(
                                              1, remoteParticipants.length),
                                      child: Expanded(
                                        child: MediaStreamView(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          participant: remote,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              height: _height,
                              width: _width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: _width,
                                    height: _height * 0.1,
                                    child: Center(
                                      child: Container(
                                        height: _height * 0.07,
                                        width: _width * 0.6,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                50, 182, 182, 182),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  child: Image.asset(
                                                      'assets/eihj1.png'),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  child: Image.asset(
                                                      'assets/hjrtk2.png'),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  child: Image.asset(
                                                      'assets/3shsh3.png'),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _onTapDisconnect();
                                                },
                                                child: Container(
                                                  child: Image.asset(
                                                      'assets/gbrjkl4.png'), //
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              255, 255, 255),
                                                      isScrollControlled: true,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10))),
                                                      context: context,
                                                      builder: (context) =>
                                                          ControlsWidget(
                                                              _openvidu,
                                                              localParticipant!));
                                                },
                                                child: Container(
                                                  height: _height * 0.05,
                                                  child: Image.asset(
                                                      'assets/gjdz.png'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 5,
                          //   left: 5,
                          //   child: Container(
                          //     height: _height * 0.15,
                          //     width: _width * 0.2,
                          //     child: MediaStreamView(
                          //       borderRadius: BorderRadius.circular(5),
                          //       participant: localParticipant!,
                          //     ),
                          //   ),
                          // ),
                          Positioned(
                            left: position.dx,
                            top: position.dy,
                            child: Draggable(
                              feedback: Container(
                                height: _height * 0.15,
                                width: _width * 0.2,
                                child: MediaStreamView(
                                  borderRadius: BorderRadius.circular(5),
                                  participant: localParticipant!,
                                ),
                              ),
                              child: Container(
                                height: _height * 0.15,
                                width: _width * 0.2,
                                child: MediaStreamView(
                                  borderRadius: BorderRadius.circular(5),
                                  participant: localParticipant!,
                                ),
                              ),
                              onDraggableCanceled: (velocity, offset) {
                                setState(() {
                                  position = offset;
                                });
                              },
                            ),
                          ),
                        ]),
                      ),
          )
        ]),
      ),
    );
  }
}

class ConnectPage extends StatefulWidget {
  ConnectPage({
    super.key,
  });

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final bool _busy = false;
  var data;
  final TextEditingController _textUserNameController = TextEditingController();

  final Dio _dio = Dio();

  _connect(BuildContext ctx) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RoomPage(
                  userName: _textUserNameController.text,
                  data: data,
                )));
  }

  Future<void> get_path_video() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/get_video');
    var res = await http
        .post(url, body: {'public_id': context.read<DataProvider>().id});
    var resTojson = json.decode(res.body);
    data = resTojson['data'];
    if (data != null) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          _connect(context);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _textUserNameController.text = 'Participante${Random().nextInt(1000)}';
    get_path_video();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        // Positioned(
        //     child: BackGroundSmart_Health(
        //   BackGroundColor: [
        //     StyleColor.backgroundbegin,
        //     StyleColor.backgroundend
        //   ],
        // )),
        Positioned(
          child: Container(
            width: _width,
            height: _height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('กำลังโหลด'),
                  Container(
                      width: _width * 0.2,
                      height: _width * 0.2,
                      child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
