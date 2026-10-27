import 'dart:async';
import 'package:flutter/material.dart';
import '../models/journal_model.dart';
import '../services/firestore_service.dart';
import 'view_state.dart';

class JournalProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  StreamSubscription? _subscription;

  ViewState _state = ViewState.initial;
  List<JournalModel> _journals = [];
  String _errorMessage = '';

  // Filter client-side
  String _searchQuery = '';
  String _statusFilter = 'Semua';

  ViewState get state => _state;
  List<JournalModel> get journals => _journals;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;

  // Filter data di memori klien (tanpa memerlukan composite index di Firestore)
  List<JournalModel> get filteredJournals {
    return _journals.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          item.nim.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.note.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == 'Semua' ||
          item.status.toUpperCase() == _statusFilter.toUpperCase();
      return matchesQuery && matchesStatus;
    }).toList();
  }

  // Statistik kehadiran
  int get totalCount => _journals.length;
  int get hadirCount =>
      _journals.where((j) => j.status.toUpperCase() == 'HADIR').length;
  int get sakitCount =>
      _journals.where((j) => j.status.toUpperCase() == 'SAKIT').length;
  int get izinCount =>
      _journals.where((j) => j.status.toUpperCase() == 'IZIN').length;
  int get alpaCount =>
      _journals.where((j) => j.status.toUpperCase() == 'ALPA').length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  /// Memulai langganan Stream Firestore Realtime (Spesifikasi Async P01 & P05)
  /// Wajib dipanggil di addPostFrameCallback pada initState untuk menghindari konflik saat build.
  void startListening() {
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    _subscription?.cancel();
    _subscription = _service.streamJournals().listen(
      (data) {
        // Aturan P05: Sorting dilakukan di sisi client (Dart)
        // Dilarang menggunakan orderBy pada query Firestore
        final sortedData = List<JournalModel>.from(data);
        sortedData.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        _journals = sortedData;
        _state = sortedData.isEmpty ? ViewState.empty : ViewState.loaded;
        notifyListeners();
      },
      onError: (e) {
        _errorMessage = e.toString();
        _state = ViewState.error;
        notifyListeners();
      },
    );
  }

  /// Single fetch menggunakan Future get() (Spesifikasi Async P01 & P05)
  Future<void> refreshOnce() async {
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await _service.getJournalsOnce();
      final sortedData = List<JournalModel>.from(data);
      sortedData.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _journals = sortedData;
      _state = sortedData.isEmpty ? ViewState.empty : ViewState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  /// Tambah data absensi baru (Create)
  Future<void> addJournal({
    required String nim,
    required String status,
    required String note,
  }) async {
    await _service.addJournal(nim: nim, status: status, note: note);
  }

  /// Ubah data absensi (Update)
  Future<void> updateJournal({
    required String id,
    required String nim,
    required String status,
    required String note,
  }) async {
    await _service.updateJournal(
      id: id,
      nim: nim,
      status: status,
      note: note,
    );
  }

  /// Hapus data absensi (Delete)
  Future<void> deleteJournal(String id) async {
    await _service.deleteJournal(id);
  }

  @override
  void dispose() {
    // Wajib melakukan dispose subscription untuk mencegah memory leak
    _subscription?.cancel();
    super.dispose();
  }
}
