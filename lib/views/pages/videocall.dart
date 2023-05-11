import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openvidu_client/openvidu_client.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_health/app/models/connection.dart';
import 'package:smart_health/app/utils/extensions.dart';
import 'package:smart_health/app/utils/logger.dart';
import 'package:smart_health/app/widgets/config_view.dart';
import 'package:smart_health/app/widgets/controls.dart';
import 'package:smart_health/app/widgets/drop_down.dart';
import 'package:smart_health/app/widgets/media_stream_view.dart';
import 'package:smart_health/app/widgets/text_field.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';

import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/pages/home.dart';
import 'package:smart_health/views/ui/widgetdew.dart/widgetdew.dart';

class PrePareVideo extends StatefulWidget {
  const PrePareVideo({super.key});

  @override
  State<PrePareVideo> createState() => _PrePareVideoState();
}

class _PrePareVideoState extends State<PrePareVideo> {
  var data;
  var resTojson;
  Timer? _timer;
  String? status;
  late OpenViduClient _openvidu;
  Future<void> get_path_video() async {
    var url =
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/get_video');
    var res = await http
        .post(url, body: {'public_id': context.read<DataProvider>().id});
    resTojson = json.decode(res.body);
    setState(() {
      data = resTojson['data'];
    });
  }

  @override
  void initState() {
    get_path_video();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return resTojson != null
        ? resTojson['data'][0] == null
            ? Container(
                height: _height * 0.7,
                child: Center(
                  child: RoomPage(
                    userName: ' UserName ',
                    data: data,
                  ),
                ),
              )
            : Container()
        : Scaffold(
            body: Stack(
              children: [
                backgrund(),
                Positioned(
                  child: Container(
                      width: _width,
                      child: Center(
                          child: BoxWidetdew(
                              height: 0.06,
                              width: _width,
                              color: Color.fromARGB(0, 255, 255, 255),
                              radius: 5.0,
                              fontSize: 0.05,
                              fontWeight: FontWeight.w500,
                              text: 'กำลังเชื่อมต่อVideo',
                              textcolor: Color.fromARGB(255, 9, 106, 0)))),
                ),
              ],
            ),
          );
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
  LocalParticipant? localParticipant;

  Timer? _timer;

  void initState() {
    //  lop();
    super.initState();
    initOpenVidu();
    _listenSessionEvents();
    logger.e("finish init");
    _onConnect();
    lop();
  }

  void _listenSessionEvents() {
    _openvidu.on(OpenViduEvent.userJoined, (params) async {
      await _openvidu.subscribeRemoteStream(params["id"]);
    });
    _openvidu.on(OpenViduEvent.userPublished, (params) {
      logger.e("userPublished");

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

  Future<void> initOpenVidu() async {
    _openvidu = OpenViduClient('https://pcm-life.com:4443/openvidu');
    localParticipant =
        await _openvidu.startLocalPreview(context, StreamMode.frontCamera);
    setState(() {});
  }

  Future<void> _onConnect() async {
    logger.e("start on Connect");
    dynamic connectstring = widget.data;

    if (true) {
      final connection = Connection.fromJson(connectstring);
      logger.i(connection.token!);
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
      nav.pop();
    }
  }

  Future<void> status_video() async {
    var url = Uri.parse(
        'https://emr-life.com/clinic_master/clinic/Api/get_video_status');
    var res = await http
        .post(url, body: {'public_id': context.read<DataProvider>().id});
    resTojson2 = json.decode(res.body);
    if (resTojson2 != null) {
      status = resTojson2['message'];
      if (status == 'completed' || status == 'finished' || status == 'end') {
        print('คุยเสร็จเเล้ว');
        _timer?.cancel();
        await _openvidu.disconnect();
        Get.offAllNamed('user_information');
      } else {
        print('คุยยังไม่เสร็จ');
        print(status);
      }
    }
  }

  void lop() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      print('เช็คstatus');
      status_video();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      backgrund(),
      Positioned(
        child: localParticipant == null
            ? Container()
            : !isInside
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoxWidetdew(
                          height: 0.06,
                          width: _width,
                          color: Color.fromARGB(0, 255, 255, 255),
                          radius: 5.0,
                          fontSize: 0.05,
                          fontWeight: FontWeight.w500,
                          text: 'เตรียมความพร้อม',
                          textcolor: Color.fromARGB(255, 9, 106, 0)),
                      Center(
                        child: ConfigView(
                          participant: localParticipant!,
                          onConnect: _onConnect,
                        ),
                      ),
                    ],
                  )
                : Container(
                    child: Stack(children: [
                      Positioned(
                        child: Container(
                          child: ListView.builder(
                              //  scrollDirection: Axis.horizontal,
                              itemCount: math.max(0, remoteParticipants.length),
                              itemBuilder: (BuildContext context, int index) {
                                final remote =
                                    remoteParticipants.values.elementAt(index);
                                return Container(
                                  width: _width /
                                      math.max(1, remoteParticipants.length),
                                  height: _height /
                                      math.max(1, remoteParticipants.length),
                                  child: Expanded(
                                    child: MediaStreamView(
                                      borderRadius: BorderRadius.circular(5),
                                      participant: remote,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 50,
                        child: Container(
                          height: _height * 0.15,
                          width: _width * 0.15,
                          child: MediaStreamView(
                            borderRadius: BorderRadius.circular(5),
                            participant: localParticipant!,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 10,
                      //   right: 10,
                      //   child: localParticipant != null
                      //       ? SafeArea(
                      //           top: false,
                      //           child: Container(
                      //             color: Colors.white,
                      //             height: _height * 0.03,
                      //             child: Center(
                      //               child: ControlsWidget(
                      //                   _openvidu, localParticipant!),
                      //             ),
                      //           ),
                      //         )
                      //       : Container(),
                      // ),

                      Positioned(
                        bottom: -10,
                        right: 1,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _onTapDisconnect();
                              },
                              child: Container(
                                  width: _width,
                                  child: Center(
                                      child: BoxWidetdew(
                                    height: 0.04,
                                    width: 0.3,
                                    color: Colors.red,
                                    radius: 5.0,
                                    fontSize: 0.04,
                                    text: 'ออก',
                                    textcolor: Colors.white,
                                  ))),
                            ),
                            SizedBox(height: _height * 0.01),
                            GestureDetector(
                              onTap: () {
                                // _onTapDisconnect();
                                showModalBottomSheet(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10))),
                                    context: context,
                                    builder: (context) => ControlsWidget(
                                        _openvidu, localParticipant!));
                              },
                              child: Container(
                                  width: _width,
                                  child: Center(
                                      child: BoxWidetdew(
                                    height: 0.016,
                                    width: 0.2,
                                    color: Colors.white,
                                    radius: 5.0,
                                    fontSize: 0.04,
                                    textcolor: Colors.white,
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    // child: Column(
                    //   children: [
                    //     Expanded(
                    //       child: ListView.builder(
                    //           //  scrollDirection: Axis.horizontal,
                    //           itemCount: math.max(0, remoteParticipants.length),
                    //           itemBuilder: (BuildContext context, int index) {
                    //             final remote =
                    //                 remoteParticipants.values.elementAt(index);
                    //             return Container(
                    //               width: _width /
                    //                   math.max(1, remoteParticipants.length),
                    //               height: _height /
                    //                   math.max(1, remoteParticipants.length),
                    //               child: Expanded(
                    //                 child: MediaStreamView(
                    //                   borderRadius: BorderRadius.circular(5),
                    //                   participant: remote,
                    //                 ),
                    //               ),
                    //             );
                    //           }),
                    //     ),
                    //     Container(
                    //       height: 100,
                    //       width: 100,
                    //       child: MediaStreamView(
                    //         borderRadius: BorderRadius.circular(5),
                    //         participant: localParticipant!,
                    //       ),
                    //     ),
                    //     if (localParticipant != null)
                    //       SafeArea(
                    //         top: false,
                    //         child: ControlsWidget(_openvidu, localParticipant!),
                    //       ),
                    //   ],
                    // ),
                  ),
      )
    ]));
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
        Uri.parse('https://emr-life.com/clinic_master/clinic/Api/get_video');
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
        Positioned(
            child: BackGroundSmart_Health(
          BackGroundColor: [
            StyleColor.backgroundbegin,
            StyleColor.backgroundend
          ],
        )),
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
