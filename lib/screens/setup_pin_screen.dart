import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../services/pin_service.dart';
import '../widgets/pin_pad.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key, required this.onConfigured});

  final VoidCallback onConfigured;

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final PinService _pinService = PinService();

  String _firstPin = '';
  String _currentPin = '';
  bool _confirming = false;
  String? _errorText;

  static const _pinLength = 4;

  Future<void> _submitPin() async {
    if (_currentPin.length != _pinLength) return;

    if (!_confirming) {
      setState(() {
        _firstPin = _currentPin;
        _currentPin = '';
        _confirming = true;
        _errorText = null;
      });
      return;
    }

    if (_currentPin != _firstPin) {
      setState(() {
        _errorText = AppLocalizations.of(context)!.codesDoNotMatch;
        _currentPin = '';
        _confirming = false;
        _firstPin = '';
      });
      return;
    }

    try {
      await _pinService.setPin(_currentPin);
      widget.onConfigured();
    } catch (_) {
      setState(() {
        _errorText = AppLocalizations.of(context)!.pinSaveError;
        _currentPin = '';
        _confirming = false;
        _firstPin = '';
      });
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, color: Colors.white, size: 56),
                  const SizedBox(height: 20),
                  Text(
                    _confirming ? l10n.confirmCode : l10n.dontachCode,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _confirming ? l10n.confirmCodeHint : l10n.setupCodeHint,
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
