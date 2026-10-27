import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'view_state.dart';

/// Catatan: Provider ini merupakan warisan modul latihan P05.
/// Untuk tema UTS "Jurnal Absensi", gunakan [JournalProvider].
class NotesProvider extends ChangeNotifier {
  final ViewState _state = ViewState.initial;
  final List<NoteModel> _notes = [];
  final String _errorMessage = '';

  ViewState get state => _state;
  List<NoteModel> get notes => _notes;
  String get errorMessage => _errorMessage;

  void startListening() {}
  Future<void> refreshOnce() async {}
  Future<void> addNote(String title, String content) async {}
  Future<void> updateNote(String id, String title, String content) async {}
  Future<void> deleteNote(String id) async {}
}
