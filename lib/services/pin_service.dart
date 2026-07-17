import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  PinService._();

  static final PinService instance = PinService._();

  static const _hashKey = 'dontach_pin_hash';
  static const _saltKey = 'dontach_pin_salt';
  static const _backupHashKey = 'dontach_pin_hash_backup';
  static const _backupSaltKey = 'dontach_pin_salt_backup';

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<bool> hasPin() async {
    final hash = await _readHash();
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    _validatePin(pin);
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _secureStorage.write(key: _hashKey, value: hash);
    await _secureStorage.write(key: _saltKey, value: salt);
    await _writeBackup(hash: hash, salt: salt);
  }

  Future<bool> verifyPin(String pin) async {
    if (!_validatePinFormat(pin)) return false;

    final hash = await _readHash();
    final salt = await _readSalt();
    if (hash == null || salt == null || hash.isEmpty || salt.isEmpty) {
      return false;
    }

    final candidate = _hashPin(pin, salt);
    final valid = _constantTimeEquals(hash, candidate);
    if (!valid) {
      debugPrint('PinService.verifyPin: incorrect code');
    }
    return valid;
  }

  Future<String?> _readHash() async {
    final secure = await _secureStorage.read(key: _hashKey);
    if (secure != null && secure.isNotEmpty) return secure;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_backupHashKey);
  }

  Future<String?> _readSalt() async {
    final secure = await _secureStorage.read(key: _saltKey);
    if (secure != null && secure.isNotEmpty) return secure;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_backupSaltKey);
  }

  Future<void> _writeBackup({required String hash, required String salt}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backupHashKey, hash);
    await prefs.setString(_backupSaltKey, salt);
  }

  void _validatePin(String pin) {
    if (!_validatePinFormat(pin)) {
      throw ArgumentError('invalid_pin');
    }
  }

  bool _validatePinFormat(String pin) {
    return RegExp(r'^\d{4}$').hasMatch(pin);
  }

  String _generateSalt() {
    final random = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    return sha256.convert(utf8.encode(random)).toString();
  }

  String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }

  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
