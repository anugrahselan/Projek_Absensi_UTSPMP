import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;

  bool get isAuthenticated => _user != null;
  String? get token => null;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _user = cred.user;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _pesanError(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _user = cred.user;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _pesanError(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _pesanError(String code) {
    if (code == 'user-not-found' || code == 'invalid-credential') {
      return 'Email atau password salah.';
    }
    if (code == 'email-already-in-use') return 'Email sudah dipakai.';
    if (code == 'weak-password') return 'Password min 6 karakter.';
    if (code == 'invalid-email') return 'Format email salah.';
    if (code == 'configuration-not-found') {
      return 'Auth belum aktif di Console: enable Email/Password dulu.';
    }
    if (code == 'network-request-failed') {
      return 'Tidak ada koneksi internet';
    }
    return 'Gagal ($code)';
  }
}
