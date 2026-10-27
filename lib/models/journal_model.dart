import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JournalModel {
  final String id;
  final String nim;
  final String status;
  final String note;
  final DateTime createdAt;

  JournalModel({
    required this.id,
    required this.nim,
    required this.status,
    required this.note,
    required this.createdAt,
  });

  /// Factory constructor dengan defensive parsing Timestamp sesuai Pertemuan 5 & 6
  factory JournalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawTimestamp = data['createdAt'];

    DateTime createdAt;
    if (rawTimestamp is Timestamp) {
      createdAt = rawTimestamp.toDate();
    } else {
      createdAt = DateTime.now(); // Fallback untuk data lama atau timestamp null
    }

    return JournalModel(
      id: doc.id,
      nim: data['nim']?.toString() ?? '',
      status: data['status']?.toString() ?? 'Hadir',
      note: data['note']?.toString() ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nim': nim,
      'status': status,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Format tanggal seragam: '2 Nov 2026, 10:30' (Sesuai Referensi UI)
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final day = createdAt.day;
    final month = months[createdAt.month - 1];
    final year = createdAt.year;
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  }

  /// Warna badge status sesuai referensi UI
  Color get badgeBgColor {
    switch (status.toUpperCase()) {
      case 'HADIR':
        return AppTheme.hadirBg;
      case 'SAKIT':
        return AppTheme.sakitBg;
      case 'IZIN':
        return AppTheme.izinBg;
      case 'ALPA':
        return AppTheme.alpaBg;
      default:
        return Colors.grey.shade200;
    }
  }

  Color get badgeTextColor {
    switch (status.toUpperCase()) {
      case 'HADIR':
        return AppTheme.hadirText;
      case 'SAKIT':
        return AppTheme.sakitText;
      case 'IZIN':
        return AppTheme.izinText;
      case 'ALPA':
        return AppTheme.alpaText;
      default:
        return Colors.black87;
    }
  }
}
