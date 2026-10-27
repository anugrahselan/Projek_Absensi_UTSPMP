import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journal_model.dart';
import '../models/user_model.dart';
import '../providers/journal_provider.dart';
import '../theme/app_theme.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  void _showAddJournalDialog(BuildContext context) {
    final noteController = TextEditingController();
    String selectedStatus = 'Hadir';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.playlist_add_check_rounded, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Absensi: ${user.firstName}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NIM: ${user.simulatedNim}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 12),
                const Text('Pilih Status:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: ['Hadir', 'Sakit', 'Izin', 'Alpa'].map((status) {
                    final isSelected = selectedStatus.toUpperCase() == status.toUpperCase();
                    return ChoiceChip(
                      label: Text(
                        status,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: _statusColor(status),
                      onSelected: (selected) {
                        if (selected) {
                          setDialogState(() {
                            selectedStatus = status;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                    hintText: 'Misal: Tepat waktu atau surat dokter',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Keterangan wajib diisi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final provider = Provider.of<JournalProvider>(context, listen: false);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                Navigator.pop(ctx);
                try {
                  await provider.addJournal(
                    nim: user.simulatedNim,
                    status: selectedStatus,
                    note: noteController.text.trim(),
                  );
                  if (context.mounted) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Absensi untuk ${user.fullName} berhasil disimpan!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan: $e')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
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
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Detail Mahasiswa (API)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil Utama Mahasiswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar Mahasiswa
                  Hero(
                    tag: 'avatar_${user.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x332962FF),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: NetworkImage(user.avatar),
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: user.avatar.isEmpty
                            ? const Icon(Icons.person, size: 46)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Nama Lengkap
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // NIM
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'NIM: ${user.simulatedNim}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Divider(),
                  const SizedBox(height: 12),

                  // Metadata Info
                  _infoRow(Icons.email_outlined, 'Email', user.email),
                  const SizedBox(height: 8),
                  _infoRow(Icons.numbers_outlined, 'API Reqres ID', '#${user.id}'),
                  const SizedBox(height: 8),
                  _infoRow(Icons.school_outlined, 'Institusi', 'ISB Atma Luhur Pangkalpinang'),

                  const SizedBox(height: 20),

                  // Tombol Cepat Catat Absensi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddJournalDialog(context),
                      icon: const Icon(Icons.add_task_rounded),
                      label: const Text('Catat Absensi Mahasiswa Ini'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Riwayat Absensi Terkait Mahasiswa Ini di Firestore
            Consumer<JournalProvider>(
              builder: (context, journalProvider, _) {
                final studentRecords = journalProvider.journals
                    .where((j) => j.nim == user.simulatedNim)
                    .toList();

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Riwayat Kehadiran (Firestore)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${studentRecords.length} Catatan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (studentRecords.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              'Belum ada riwayat absensi untuk mahasiswa ini.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: studentRecords.length,
                          separatorBuilder: (context, index) => const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final record = studentRecords[index];
                            return _buildRecordItem(record);
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordItem(JournalModel record) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: record.badgeBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            record.status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: record.badgeTextColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.note,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                record.formattedDate,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
