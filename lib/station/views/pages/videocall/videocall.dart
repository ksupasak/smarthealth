import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:openvidu_client/openvidu_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/app/models/connection.dart';
import 'package:smart_health/station/app/utils/extensions.dart';
import 'package:smart_health/station/app/utils/logger.dart';
import 'package:smart_health/station/app/widgets/media_stream_view.dart';
import 'package:smart_health/station/provider/provider.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
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
    dynamic connectstring = context.read<DataProvider>().dataVideoCall;

    if (connectstring != null) {
      logger.i("start on Connect");
      final connection = Connection.fromJson(connectstring);
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: !isInside
            ? Column(
                children: [
                  Text(context.read<DataProvider>().dataVideoCall.toString()),
                  ElevatedButton(
                      onPressed: () {
                        Get.offNamed('user_information');
                      },
                      child: const Text("ออก")),
                  ElevatedButton(
                      onPressed: () {
                        onConnect();
                      },
                      child: const Text("เข้าห้องVideo Call"))
                ],
              )
            : SizedBox(
                child: ListView.builder(
                    itemCount: math.max(0, remoteParticipants.length),
                    itemBuilder: (BuildContext context, int index) {
                      final remote = remoteParticipants.values.elementAt(index);
                      return SizedBox(
                        width: width / math.max(1, remoteParticipants.length),
                        height: height / math.max(1, remoteParticipants.length),
                        child: Expanded(
                          child: MediaStreamView(
                            borderRadius: BorderRadius.circular(5),
                            participant: remote,
                          ),
                        ),
                      );
                    }),
              ));
  }
}
