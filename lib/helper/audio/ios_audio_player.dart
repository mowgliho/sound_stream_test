import 'dart:async';

import 'package:sound_stream_test/helper/audio/audio.dart';
import 'package:sound_stream_test/helper/audio/audio_player.dart';
import 'package:sound_stream/sound_stream.dart';

class IosAudioPlayer extends AudioPlayer {
  PlayerStream _playerStream = PlayerStream();
  Timer? _timer;
  bool _playing = false;
  AudioData? _next;

  IosAudioPlayer() {
    _playerStream.status.listen((event) {
      _playing = event == SoundStreamStatus.Playing;
      if(event == SoundStreamStatus.Stopped) {
        if(_next != null) _play(_next!);
        _next = null;
      }
    });
  }

  @override
  Future<void> play(AudioData data) async {
    if(!_playing) await _play(data);
    else {
      _next = data;
      stop();
    }
  }

  Future<void> _play(AudioData data) async {
    _timer?.cancel();
    _playerStream.initialize(sampleRate: data.sampleRate);//stops recording and other while loop (if exists)
    await _playerStream.start();
    _playerStream.writeChunk(data.bytes);
    _timer = Timer(
      Duration(milliseconds:(data.lengthInSeconds*1000).round()), 
      stop
    );
  }

  @override
  void stop() {
    _playerStream.stop();
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {}
}