import 'dart:typed_data';

class AudioChunk {
  final Int16List data;
  final Uint8List bytes;
  final AudioChunk? next;
  final int sampleRate;

  AudioChunk(this.data, this.next, this.sampleRate):
    bytes = Uint8List.view(data.buffer);
}