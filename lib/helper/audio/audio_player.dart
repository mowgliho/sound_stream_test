import 'dart:async';

import 'package:sound_stream_test/helper/audio/audio.dart';

abstract class AudioPlayer {
  //callback not called on hot switches
  Future<void> play(AudioData data);

  void stop();

  void dispose();
}