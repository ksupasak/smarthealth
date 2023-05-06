import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
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
import 'package:smart_health/app/widgets/media_stream_view.dart';
import 'package:smart_health/background/background.dart';
import 'package:smart_health/background/color/style_color.dart';

import 'package:smart_health/provider/provider.dart';
import 'package:smart_health/views/pages/home.dart';

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

  LocalParticipant? localParticipant;

  @override
  void initState() {
    super.initState();
    initOpenVidu();
    _listenSessionEvents();
    logger.e("finish init");
    _onConnect();
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
        // isInside = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: localParticipant == null
          ? Container()
          : !isInside
              ? ConfigView(
                  participant: localParticipant!,
                  onConnect: _onConnect,
                  userName: 'dew',
                )
              : Column(
                  children: [
                    Expanded(
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
                    Container(
                      //flutter overlay widget example
                      height: 100,
                      width: 100,
                      child: MediaStreamView(
                        borderRadius: BorderRadius.circular(5),
                        participant: localParticipant!,
                      ),
                    ),
                    if (localParticipant != null)
                      SafeArea(
                        top: false,
                        child: ControlsWidget(_openvidu, localParticipant!),
                      ),
                  ],
                ),
    );
  }
}

class Videocall2 extends StatefulWidget {
  Videocall2({
    super.key,
    required this.userName,
    this.data,
  });
  final String userName;
  var data;
  @override
  State<Videocall2> createState() => _Videocall2State();
}

class _Videocall2State extends State<Videocall2> {
  Map<String, RemoteParticipant> remoteParticipants = {};
  MediaDeviceInfo? input;
  bool isInside = true;
  late OpenViduClient _openvidu;

  LocalParticipant? localParticipant;

  @override
  void initState() {
    super.initState();
    initOpenVidu();
    _listenSessionEvents();
    logger.e("finish init");
    _onConnect();
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
        // isInside = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: localParticipant == null
          ? Container()
          : !isInside
              ? ConfigView(
                  participant: localParticipant!,
                  onConnect: _onConnect,
                  userName: 'dew',
                )
              : Column(
                  children: [
                    Expanded(
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
                    Container(
                      //flutter overlay widget example
                      height: 100,
                      width: 100,
                      child: MediaStreamView(
                        borderRadius: BorderRadius.circular(5),
                        participant: localParticipant!,
                      ),
                    ),
                    if (localParticipant != null)
                      SafeArea(
                        top: false,
                        child: ControlsWidget(_openvidu, localParticipant!),
                      ),
                  ],
                ),
    );
  }
}
