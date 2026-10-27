import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal_model.dart';

class FirestoreService {
  // Collection 'journals' sesuai spesifikasi tugas UTS PMP (Tema 6: Jurnal Absensi)
  final CollectionReference _journals = FirebaseFirestore.instance.collection('journals');

  /// Stream realtime menggunakan snapshots() (Spesifikasi Async P01 & P05)
  /// CATATAN: Dilarang menggunakan orderBy() di sisi Firestore untuk mencegah error Composite Index.
  /// Pengurutan data dilakukan di sisi client (Dart Provider).
  Stream<List<JournalModel>> streamJournals() {
    return _journals.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => JournalModel.fromFirestore(doc)).toList(),
    );
  }

  /// Single fetch menggunakan Future get() (Spesifikasi Async P01 & P05)
  Future<List<JournalModel>> getJournalsOnce() async {
    final snapshot = await _journals.get();
    return snapshot.docs.map((doc) => JournalModel.fromFirestore(doc)).toList();
  }

  /// Operasi Create / Add
  Future<void> addJournal({
    required String nim,
    required String status,
    required String note,
  }) {
    return _journals.add({
      'nim': nim.trim(),
      'status': status.trim(),
      'note': note.trim(),
      'createdAt': Timestamp.now(),
    });
  }

  /// Operasi Update
  Future<void> updateJournal({
    required String id,
    required String nim,
    required String status,
    required String note,
  }) {
    return _journals.doc(id).update({
      'nim': nim.trim(),
      'status': status.trim(),
      'note': note.trim(),
    });
  }

  /// Operasi Delete
  Future<void> deleteJournal(String id) {
    return _journals.doc(id).delete();
  }
}
