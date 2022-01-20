import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_sound/public/util/flutter_sound_helper.dart';

import 'audio_chunk.dart';


/// class for functions and stuff that I wish there was a library for
/// may break when endianness changes
class Audio {
  static Future<AudioData> loadAudioData(String filename) async {
    Uint8List rawData;
    rawData = (await rootBundle.load(filename)).buffer.asUint8List();
    int sampleRate = rawData.sublist(24, 28).buffer.asInt32List().elementAt(0);
    int bitDepth = rawData.sublist(34, 36).buffer.asInt16List().elementAt(0);
    Uint8List data = flutterSoundHelper.waveToPCMBuffer(inputBuffer: rawData);
    return bitDepth == 8? AudioData._fromPcm8(sampleRate, data): AudioData._fromPcm16Bytes(sampleRate, data);
  }

  static AudioData syntheticAudio(double frequency, int sampleRate, Duration duration) {
    double phase = 0;
    List<double> ys = List<double>.generate(
      (duration.inMilliseconds/1000 * sampleRate).ceil(),
      (i) {
        phase += 1/sampleRate * 2 * pi * frequency;
        return sin((i+1)*phase) * exp(-2);//exp(-2) is for scaling
      }
    );
    return AudioData._fromPcm16Doubles(sampleRate, ys);
  }
}

//always as PCM16
class AudioData {
  static final int _eightBitMidpoint = 128;
  static final double _sixteenBitRange = 32767.5;

  final int sampleRate;
  final Int16List _data;//signed PCM16 data

  AudioData.fromPcm16(this.sampleRate, this._data);

  AudioData._fromPcm16Bytes(this.sampleRate, Uint8List bytes):
    this._data = Int16List.view(bytes.buffer);

  AudioData._fromPcm8(this.sampleRate, Uint8List uint8Data):
    _data = Int16List.fromList(List<int>.from(uint8Data).map((e) => (e.toInt() - _eightBitMidpoint) << 8).toList());

  AudioData._fromPcm16Doubles(this.sampleRate, List<double> doubleData):
    _data = Int16List.fromList(doubleData.map<int>((y) => (y*_sixteenBitRange).round()).toList());

  Uint8List get bytes => Uint8List.view(_data.buffer);

  double get lengthInSeconds => _data.length/sampleRate;

  //in seconds
  //returns first Audio chunk (which is connected to others)
  AudioChunk getChunks(double chunkLength) {
    int numChunks = (_data.length/sampleRate/chunkLength).ceil();
    assert(chunkLength > 1/sampleRate && numChunks > 0);
    AudioChunk chunk = AudioChunk(
      _data.sublist(((numChunks - 1)*chunkLength*sampleRate).floor()), 
      null,
      sampleRate
    );
    for(int i = numChunks - 2; i >= 0; i--) {
      chunk = AudioChunk(
        _data.sublist((i*chunkLength*sampleRate).floor(), ((i+1)*chunkLength*sampleRate).floor()), 
        chunk,
        sampleRate
      );
    }
    return chunk;
  }
}