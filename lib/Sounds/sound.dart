import 'package:audioplayers/audioplayers.dart';

class Sound {
  late AudioPlayer player;
  Sound() {
    player = AudioPlayer();
  }
  void playBeepSucces() async {
    await player.play(AssetSource("sounds/tb.mp3"));
  }

  void playBeepError() async {
    await player.play(AssetSource("sounds/error.mp3"));
  }

  void playBeepWarning() async {
    await player.play(AssetSource("sounds/warning.mp3"));
  }
}
