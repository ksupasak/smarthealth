import 'package:just_audio/just_audio.dart';
import 'package:smart_health/myapp/provider/provider.dart';

void playsound() async {
  late AudioPlayer _audioPlayer;
  String audio = DataProvider().audio;
  _audioPlayer = AudioPlayer()..setAsset('assets/sounds/$audio');
  await _audioPlayer.play();
}
