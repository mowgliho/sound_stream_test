import 'package:flutter/material.dart';
import 'package:sound_stream_test/helper/assets.dart';
import 'package:sound_stream_test/helper/audio/audio.dart';
import 'package:sound_stream_test/helper/audio/audio_player.dart';
import 'package:sound_stream_test/helper/audio/stream_recorder.dart';
import 'package:sound_stream_test/helper/constants.dart';
import 'package:sound_stream_test/helper/platform_settings.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late StreamRecorder _streamRecorder;
  _RecordingState _recordingState = _RecordingState.ready;

  AudioData? _recordedData;

  @override
  void initState() {
    super.initState();
    _streamRecorder = StreamRecorder(
      Duration(seconds: 1), 
      (AudioData data) {
        setState(() {_recordingState = _RecordingState.ready;});
        _recordingState = _RecordingState.ready;_recordedData = data;
      }
    );

  }

  final AudioPlayer _audioPlayer = PlatformSettings.getAudioPlayer();

  @override
  Widget build(BuildContext context) {
    bool isRecording = _recordingState == _RecordingState.recording;
    return Scaffold(
      appBar: AppBar(title: Text('sound stream test')),
      body: Column(children: [
        ElevatedButton(
          child: Text('Play Example'), 
          onPressed: isRecording? null: () async {_audioPlayer.play(await Audio.loadAudioData(Assets.getPath('si1.wav')));}),
        ElevatedButton(
          child: Text('Play Puretone'), 
          onPressed: isRecording? null: () {_audioPlayer.play(Audio.syntheticAudio(300, Constants.sampleRate, Duration(seconds:3)));}),
        ElevatedButton(
          child: Text('Play Recorded'), 
          onPressed: (isRecording || _recordedData == null)? null: () {_audioPlayer.play(_recordedData!);}),
        ElevatedButton(
          child: Text('Record'), 
          onPressed: () {
            setState(() {_recordingState = _RecordingState.recording;});
            _streamRecorder.record();})
      ])
    );
  }
}

enum _RecordingState {
  ready,recording
}