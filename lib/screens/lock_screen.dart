import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../services/protection_coordinator.dart';
import '../services/pin_service.dart';
import '../widgets/pin_pad.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final PinService _pinService = PinService();
  final ProtectionCoordinator _coordinator = ProtectionCoordinator.instance;

  String _currentPin = '';
  String? _errorText;
  bool _isVerifying = false;

  static const _pinLength = 4;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _coordinator.addListener(_onCoordinatorChanged);
  }

  void _onCoordinatorChanged() {
    if (mounted && !_coordinator.requiresUnlock) {
      setState(() {
        _isVerifying = false;
        _currentPin = '';
        _errorText = null;
      });
    }
  }

  Future<void> _verifyPin() async {
    if (_currentPin.length != _pinLength || _isVerifying) return;

    final enteredPin = _currentPin;

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    _coordinator.stopAlarmImmediately();

    try {
      final valid = await _pinService.verifyPin(enteredPin).timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );
      if (!mounted) return;

      if (valid) {
        await _coordinator.completeUnlock();
        if (!mounted) return;
        setState(() {
          _isVerifying = false;
          _currentPin = '';
        });
        return;
      }

      await _coordinator.resumeAlarmIfLocked();
      if (!mounted) return;

      setState(() {
        _isVerifying = false;
        _currentPin = '';
        _errorText = AppLocalizations.of(context)!.incorrectCode;
      });
      HapticFeedback.heavyImpact();
    } catch (_) {
      await _coordinator.resumeAlarmIfLocked();
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _currentPin = '';
        _errorText = AppLocalizations.of(context)!.incorrectCode;
      });
    }
  }

  void _onDigit(String digit) {
    if (_isVerifying || _currentPin.length >= _pinLength) return;
    setState(() {
      _errorText = null;
      _currentPin += digit;
    });
    if (_currentPin.length == _pinLength) {
      _verifyPin();
    }
  }

  void _onBackspace() {
    if (_isVerifying || _currentPin.isEmpty) return;
    setState(() => _currentPin = _currentPin.substring(0, _currentPin.length - 1));
  }

  @override
  void dispose() {
    _coordinator.removeListener(_onCoordinatorChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.enterYourCode,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_isVerifying)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    else
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
      ),
    );
  }
}
