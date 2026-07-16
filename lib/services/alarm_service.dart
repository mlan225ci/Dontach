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
  int _operationId = 0;

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
    final operationId = ++_operationId;
    _isPlaying = false;

    for (var attempt = 0; attempt < 2; attempt++) {
      if (operationId != _operationId) return;

      try {
        await _ensureSessionActive();
        if (operationId != _operationId) return;

        await _player.stop();
        await _player.setLoopMode(LoopMode.one);
        await _player.setVolume(1.0);
        await _player.setAsset('assets/sounds/warning_alarm.mp3');
        await _player.seek(Duration.zero);
        await _player.play();

        await Future<void>.delayed(const Duration(milliseconds: 250));
        if (operationId != _operationId) {
          await _player.stop();
          return;
        }

        if (_player.playing) {
          _isPlaying = true;
          await _startVibration(operationId);
          return;
        }
      } catch (error, stackTrace) {
        debugPrint('AlarmService.play attempt ${attempt + 1} failed: $error');
        debugPrint('$stackTrace');
      }
    }

    if (operationId == _operationId) {
      _isPlaying = false;
    }
    debugPrint('AlarmService.play: unable to start alarm after retries.');
  }

  Future<void> _startVibration(int operationId) async {
    if (operationId != _operationId) return;
    if (!await Vibration.hasVibrator()) return;

    await Vibration.cancel();
    if (operationId != _operationId) return;

    // repeat: -1 = jouer le pattern une seule fois (pas de boucle infinie).
    await Vibration.vibrate(
      pattern: [0, 700, 250, 700, 250, 700],
      repeat: -1,
    );
  }

  Future<void> stop() async {
    final operationId = ++_operationId;
    _isPlaying = false;

    try {
      await Vibration.cancel();
      await _player.setVolume(0);
      await _player.pause();
      await _player.setLoopMode(LoopMode.off);
      await _player.stop();
      await _player.seek(Duration.zero);

      if (_configured) {
        final session = await AudioSession.instance;
        await session.setActive(false);
      }
    } catch (error) {
      debugPrint('AlarmService.stop failed: $error');
    }

    if (operationId == _operationId) {
      _isPlaying = false;
    }
  }

  void stopImmediate() {
    _operationId++;
    _isPlaying = false;
    unawaited(Vibration.cancel());
    unawaited(_silencePlayer());
  }

  Future<void> _silencePlayer() async {
    try {
      await _player.setVolume(0);
      await _player.pause();
      await _player.setLoopMode(LoopMode.off);
      await _player.stop();
    } catch (error) {
      debugPrint('AlarmService._silencePlayer failed: $error');
    }
  }
}
