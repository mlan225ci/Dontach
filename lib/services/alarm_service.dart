import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class AlarmService {
  AlarmService._();

  static final AlarmService instance = AlarmService._();

  final AudioPlayer _player = AudioPlayer(
    handleInterruptions: false,
  );

  bool _configured = false;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> _ensureSessionActive() async {
    final session = await AudioSession.instance;

    if (!_configured) {
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.duckOthers,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.sonification,
            usage: AndroidAudioUsage.alarm,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        ),
      );

      await _player.setAndroidAudioAttributes(
        const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.alarm,
        ),
      );

      _configured = true;
    }

    await session.setActive(true);
  }

  Future<void> play() async {
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        await _ensureSessionActive();

        if (_player.processingState == ProcessingState.ready && _isPlaying) {
          return;
        }

        await _player.stop();
        await _player.setAsset('assets/sounds/warning_alarm.mp3');
        await _player.setLoopMode(LoopMode.one);
        await _player.setVolume(1.0);
        await _player.seek(Duration.zero);
        await _player.play();

        await Future<void>.delayed(const Duration(milliseconds: 250));
        if (_player.playing) {
          _isPlaying = true;
          await _startVibration();
          return;
        }
      } catch (error, stackTrace) {
        debugPrint('AlarmService.play attempt ${attempt + 1} failed: $error');
        debugPrint('$stackTrace');
      }
    }

    debugPrint('AlarmService.play: unable to start alarm after retries.');
  }

  Future<void> _startVibration() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(pattern: [0, 700, 250, 700], repeat: 0);
    }
  }

  Future<void> stop() async {
    stopImmediate();
    try {
      await _player.stop();
      await _player.setVolume(1.0);
    } catch (error) {
      debugPrint('AlarmService.stop failed: $error');
    }
  }

  void stopImmediate() {
    _isPlaying = false;
    unawaited(_player.setVolume(0));
    unawaited(_player.pause());
    unawaited(_player.stop());
    unawaited(Vibration.cancel());
  }
}
