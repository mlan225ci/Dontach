import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../services/pin_service.dart';
import '../widgets/pin_pad.dart';

enum _ChangePinStep { verifyCurrent, enterNew, confirmNew }

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final PinService _pinService = PinService();

  _ChangePinStep _step = _ChangePinStep.verifyCurrent;
  String _firstPin = '';
  String _currentPin = '';
  String? _errorText;

  static const _pinLength = 4;

  String _title(AppLocalizations l10n) {
    switch (_step) {
      case _ChangePinStep.verifyCurrent:
        return l10n.changePinCurrent;
      case _ChangePinStep.enterNew:
        return l10n.changePinNew;
      case _ChangePinStep.confirmNew:
        return l10n.confirmCode;
    }
  }

  String _hint(AppLocalizations l10n) {
    switch (_step) {
      case _ChangePinStep.verifyCurrent:
        return l10n.changePinCurrentHint;
      case _ChangePinStep.enterNew:
        return l10n.changePinNewHint;
      case _ChangePinStep.confirmNew:
        return l10n.confirmCodeHint;
    }
  }

  Future<void> _submitPin() async {
    if (_currentPin.length != _pinLength) return;

    switch (_step) {
      case _ChangePinStep.verifyCurrent:
        final valid = await _pinService.verifyPin(_currentPin);
        if (!mounted) return;
        if (!valid) {
          setState(() {
            _errorText = AppLocalizations.of(context)!.incorrectCode;
            _currentPin = '';
          });
          HapticFeedback.heavyImpact();
          return;
        }
        setState(() {
          _step = _ChangePinStep.enterNew;
          _currentPin = '';
          _errorText = null;
        });
      case _ChangePinStep.enterNew:
        setState(() {
          _firstPin = _currentPin;
          _currentPin = '';
          _step = _ChangePinStep.confirmNew;
          _errorText = null;
        });
      case _ChangePinStep.confirmNew:
        if (_currentPin != _firstPin) {
          setState(() {
            _errorText = AppLocalizations.of(context)!.codesDoNotMatch;
            _currentPin = '';
            _step = _ChangePinStep.enterNew;
            _firstPin = '';
          });
          return;
        }
        try {
          await _pinService.setPin(_currentPin);
          if (!mounted) return;
          Navigator.of(context).pop(true);
        } catch (_) {
          if (!mounted) return;
          setState(() {
            _errorText = AppLocalizations.of(context)!.pinSaveError;
            _currentPin = '';
            _step = _ChangePinStep.enterNew;
            _firstPin = '';
          });
        }
    }
  }

  void _onDigit(String digit) {
    if (_currentPin.length >= _pinLength) return;
    setState(() {
      _errorText = null;
      _currentPin += digit;
    });
    if (_currentPin.length == _pinLength) {
      _submitPin();
    }
  }

  void _onBackspace() {
    if (_currentPin.isEmpty) return;
    setState(() => _currentPin = _currentPin.substring(0, _currentPin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(
          l10n.changePin,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_reset_rounded, color: Colors.white, size: 56),
                  const SizedBox(height: 20),
                  Text(
                    _title(l10n),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _hint(l10n),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
                  ),
                  const SizedBox(height: 36),
                  PinPad(
                    pinLength: _pinLength,
                    enteredLength: _currentPin.length,
                    onDigit: _onDigit,
                    onBackspace: _onBackspace,
                    errorText: _errorText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
