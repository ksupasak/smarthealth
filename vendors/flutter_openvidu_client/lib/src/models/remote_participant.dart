import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../utils/constants.dart';
import '../utils/logger.dart';
import 'local_participant.dart';
import 'openvidu_events.dart';
import 'participant.dart';

class RemoteParticipant extends Participant {
  RemoteParticipant(super.id, super.token, super.rpc, super.metadata);

  Future<void> subscribeStream(
    MediaStream localStream,
    EventDispatcher dispatchEvent,
    bool video,
    bool audio,
    bool speakerphone,
  ) async {
    try {
      final connection = await peerConnection;
      connection.onRenegotiationNeeded = () => _createOffer(connection);

      logger.i("b1");

      connection.onAddStream = (stream) {
        logger.i("b2");
        this.stream = stream;
        audioActive = audio;
        videoActive = video;

        dispatchEvent(OpenViduEvent.addStream,
            {"id": id, "stream": stream, "metadata": metadata});
      };

      connection.onRemoveStream = (stream) {
        this.stream = stream;
        logger.i("b3");
        dispatchEvent(OpenViduEvent.removeStream,
            {"id": id, "stream": stream, "metadata": metadata});
      };

      logger.i("b4");
      logger.i(connection);
      logger.i(localStream);

      // await connection.addStream(localStream);

      localStream.getTracks().forEach((track) {
        connection.addTrack(track, localStream);
      });

      logger.i("b5");
    } catch (e) {
      logger.e(e);
    }
  }

  _createOffer(RTCPeerConnection connection) async {
    final offer = await connection.createOffer({
      'mandatory': {
        'OfferToReceiveAudio': !(runtimeType == LocalParticipant),
        'OfferToReceiveVideo': !(runtimeType == LocalParticipant),
      },
      "optional": [
        {"DtlsSrtpKeyAgreement": true},
      ],
    });

    logger.i("a1");

    await connection.setLocalDescription(offer);

    logger.i("a2");

    var result = await rpc.send(
      Methods.receiveVideoFrom,
      params: {'sender': id, 'sdpOffer': offer.sdp},
      hasResult: true,
    );

    logger.d(result);

    final answer = RTCSessionDescription(result['sdpAnswer'], 'answer');
    await connection.setRemoteDescription(answer);
  }

  @override
  Future<void> close() {
    stream?.getTracks().forEach((track) async {
      await track.stop();
      logger.i(track.toString());
    });
    stream?.dispose();
    return super.close();
  }
}
