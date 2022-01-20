import 'dart:io';

import 'package:sound_stream_test/helper/audio/android_audio_player.dart';
import 'package:sound_stream_test/helper/audio/audio_player.dart';
import 'package:sound_stream_test/helper/audio/flutter_sound_audio_player.dart';
import 'package:sound_stream_test/helper/audio/ios_audio_player.dart';

class PlatformSettings {
  // static AudioPlayer getAudioPlayer() => Platform.isIOS? IosAudioPlayer():AndroidAudioPlayer();
  //for using the fluttersound player
  static AudioPlayer getAudioPlayer() => FlutterSoundAudioPlayer();

  static bool isIOS() => Platform.isIOS;
}