import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:sound_stream_test/helper/audio/audio.dart';
import 'package:sound_stream_test/helper/audio/audio_player.dart';

class FlutterSoundAudioPlayer extends AudioPlayer {
  FlutterSoundPlayer? _player;
  bool _inited = false;

  FlutterSoundAudioPlayer():
    _player = FlutterSoundPlayer() {
    _player!.openAudioSession().then((value) {_inited = true;});
  }

  bool get isPlaying => _player == null?false:_player!.isPlaying;
  bool get canPlay => _inited && _player != null && !_player!.isPlaying;

  Future<void> play(AudioData data, ) async {
    if(isPlaying) await stop();
    if(_player == null) return;
    if(canPlay) await _player!.startPlayer(
      fromDataBuffer: data.bytes,
      sampleRate: data.sampleRate,
      codec: Codec.pcm16,
      whenFinished: () {});
  }
 
  Future<void> stop() async {
    if(_player != null) { await _player!.stopPlayer(); }
 }
 
  void dispose() {
    stop();
    if(_player != null) _player!.closeAudioSession();
    _player = null;
 }
}