import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'providers/journal_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan options platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Penanganan emulator debug jika diperlukan (Sesuai Materi P04)
  if (kDebugMode) {
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );
  }

  final authProvider = AuthProvider();

  // Listener Stream Auth State (Spesifikasi Async P01 & Auth P04)
  FirebaseAuth.instance.authStateChanges().listen(authProvider.setUser);

  runApp(
    MultiProvider(
      providers: [
        // 1. AuthProvider (P04)
        ChangeNotifierProvider.value(value: authProvider),
        // 2. JournalProvider - Firestore Domain Provider (P05 & P06)
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        // 3. DataProvider - Dio REST API Provider (P02 & P03)
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jurnal Absensi Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Navigasi Reaktif berbasis status autentikasi (Auth Gating P04)
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
