import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:sound_stream_test/helper/audio/audio.dart';
import 'package:sound_stream_test/helper/constants.dart';
import 'package:sound_stream_test/helper/permission_handler.dart';

//adds to a stream, reports back when done
//usage: initialize with timeout and callback, check for permissions, if permissions then record, stop on stop
class StreamRecorder {

  BytesBuilder _bytesBuilder = BytesBuilder();
  RecorderStream _recorderStream = RecorderStream();

  StreamSubscription<Uint8List>? _audioStream;
  bool _recording = false;

  final int _numSamples;
  final void Function(AudioData)? _callback;//careful to check for disposed if used in a widget

  //called on initstate
  StreamRecorder(Duration timeoutDuration, this._callback): _numSamples = (timeoutDuration.inMilliseconds/1000*Constants.sampleRate).ceil();

  //returns a stream that we can listen to, which tells updates us in sts on getting new data
  Future<void> record() async {
    //add to bytebuilder when gettin new data
    _recording = true;
    _audioStream = _recorderStream.audioStream.listen((data) {
      _bytesBuilder.add(data);
      if(_bytesBuilder.length/2 > _numSamples) clean();//divide by two because PCM16 and bytes
    });
    await _recorderStream.initialize(sampleRate: Constants.sampleRate);
    await _recorderStream.start();
  }

  Future<bool> permissions(BuildContext context) async {
    return await PermissionHandler.request(context);
  }

  //called on dispose
  Future<void> clean() async {
    if(_callback != null && _bytesBuilder.isNotEmpty) {
      Int16List data = Int16List.view(_bytesBuilder.toBytes().buffer);
      _callback!(AudioData.fromPcm16(Constants.sampleRate,data));
    }
    if(_recording) await _recorderStream.stop();
    _recording = false;
    _audioStream?.cancel();
    _bytesBuilder.clear();
  }
}