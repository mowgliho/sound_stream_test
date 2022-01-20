import 'dart:async';

import 'package:sound_stream_test/helper/audio/audio.dart';
import 'package:sound_stream_test/helper/audio/audio_chunk.dart';
import 'package:sound_stream_test/helper/audio/audio_player.dart';
import 'package:sound_stream_test/helper/constants.dart';
import 'package:sound_stream/sound_stream.dart';

class AndroidAudioPlayer extends AudioPlayer {
  PlayerStream _playerStream = PlayerStream();
  AudioChunk? _audioChunk;

  //callback not called on hot switches
  @override
  Future<void> play(AudioData data) async {
    bool hotSwitch = (_audioChunk != null) && (_audioChunk!.sampleRate == data.sampleRate);
    _audioChunk = data.getChunks(Constants.playbackChunkLength);
    if(hotSwitch) {
    } else {
      _playerStream.initialize(sampleRate: data.sampleRate);//stops recording and other while loop (if exists)
      await _playerStream.start();
      while(_audioChunk != null) {
        await _playerStream.writeChunk(_audioChunk!.bytes);
        _audioChunk = _audioChunk?.next;
      }
      await _playerStream.stop();
    }
  }

  @override
  void stop() {
    _audioChunk = null;
  }
  
  @override
  void dispose() {}
}