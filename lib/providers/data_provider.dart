import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'view_state.dart';

class DataProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ViewState _state = ViewState.initial;
  List<UserModel> _users = [];
  String _errorMessage = '';

  ViewState get state => _state;
  List<UserModel> get users => _users;
  String get errorMessage => _errorMessage;

  /// Memuat daftar pengguna / mahasiswa dari Reqres API (P02 & P03)
  /// Menggunakan Future dan pola ViewState
  Future<void> loadUsers({String? token}) async {
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _apiService.fetchUsers(token: token);
      if (result.isEmpty) {
        _state = ViewState.empty;
      } else {
        _users = result;
        _state = ViewState.loaded;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ViewState.error;
    }
    notifyListeners();
  }

  /// Memuat ulang data API
  Future<void> refreshUsers() async {
    await loadUsers();
  }
}
