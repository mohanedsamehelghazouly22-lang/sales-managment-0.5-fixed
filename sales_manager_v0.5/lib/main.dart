import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'screens/app_shell.dart';
import 'screens/login.dart';
import 'screens/business_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const SalesManagerApp());
}

class SalesManagerApp extends StatelessWidget {
  const SalesManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sales Manager',
      theme: AppTheme.dark(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final client = SupabaseService.client!;
    return StreamBuilder(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (client.auth.currentSession == null) return const LoginPage();
        return const BusinessGate();
      },
    );
  }
}
