import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:openvidu_client/openvidu_client.dart';
import 'package:openvidu_client_example/app/models/connection.dart';
import 'package:openvidu_client_example/app/utils/extensions.dart';
import 'package:openvidu_client_example/app/utils/logger.dart';
import 'package:openvidu_client_example/app/widgets/config_view.dart';
import 'package:openvidu_client_example/app/widgets/controls.dart';
import 'package:openvidu_client_example/app/widgets/media_stream_view.dart';

class TestVideo extends StatefulWidget {
  const TestVideo({super.key});

  @override
  State<TestVideo> createState() => _TestVideoState();
}

class _TestVideoState extends State<TestVideo> {
  late OpenViduClient _openvidu;
  Map<String, RemoteParticipant> remoteParticipants = {};
  LocalParticipant? localParticipant;
  bool isInside = false;
  @override
  void initState() {
    initOpenVidu();

    super.initState();
  }

  Future<void> initOpenVidu() async {
    _openvidu = OpenViduClient('https://openvidu.pcm-life.com');
    localParticipant =
        await _openvidu.startLocalPreview(context, StreamMode.frontCamera);
    listenSessionEvents();
    setState(() {});
  }

  void listenSessionEvents() {
    logger.i("finish init");
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

  Future<void> onConnect() async {
    // dynamic connectstring = context.read<DataProvider>().dataVideoCall;
    Map<String, dynamic> data = {
      "id": "con_DIVSv6cm13",
      "object": "connection",
      "status": "pending",
      "connectionId": "con_DIVSv6cm13",
      "sessionId": "672dbcbf790f9b4aef00002d",
      "createdAt": 1731053675028,
      "type": "WEBRTC",
      "record": true,
      "role": "PUBLISHER",
      "kurentoOptions": null,
      "customIceServers": [],
      "rtspUri": null,
      "adaptativeBitrate": null,
      "onlyPlayWithSubscribers": null,
      "networkCache": null,
      "serverData": "",
      "token":
          "wss://openvidu.pcm-life.com?sessionId=672dbcbf790f9b4aef00002d\u0026token=tok_YcA2Od36VnzlCN6w",
      "activeAt": null,
      "location": null,
      "ip": null,
      "platform": null,
      "clientData": null,
      "publishers": null,
      "subscribers": null
    };
    if (true) {
      logger.i("start on Connect");
      final connection = Connection.fromJson(data);
      logger.i(connection.token!);
      localParticipant = await _openvidu.publishLocalStream(
          token: connection.token!, userName: "userName");
      setState(() {
        isInside = true;
      });
    }
  }

  @override
  void dispose() async {
    await _openvidu.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localParticipant == null
          ? Container()
          : !isInside
              ? ConfigView(
                  participant: localParticipant!,
                  onConnect: onConnect,
                  userName: '',
                )
              : Column(
                  children: [
                    Expanded(
                      child: MediaStreamView(
                        borderRadius: BorderRadius.circular(5),
                        participant: localParticipant!,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: math.max(0, remoteParticipants.length),
                          itemBuilder: (BuildContext context, int index) {
                            final remote =
                                remoteParticipants.values.elementAt(index);
                            return SizedBox(
                              width: 100,
                              height: 100,
                              child: MediaStreamView(
                                borderRadius: BorderRadius.circular(5),
                                participant: remote,
                              ),
                            );
                          }),
                    ),
                    if (localParticipant != null)
                      SafeArea(
                        top: false,
                        child: ControlsWidget(_openvidu, localParticipant!),
                      ),
                    const Text("data")
                  ],
                ),
    );
  }
}
