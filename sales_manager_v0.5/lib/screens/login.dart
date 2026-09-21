import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  String? error;

  Future<void> login() async {
    setState(() { busy = true; error = null; });
    try {
      await SupabaseService.signIn(
        email: email.text.trim(),
        password: password.text,
      );
    } catch (e) {
      setState(() => error = 'تعذر تسجيل الدخول. تأكد من البريد وكلمة المرور.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: AppTheme.card(radius: 28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 64, height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                  ),
                ),
                child: const Icon(Icons.bar_chart_rounded, size: 32),
              ),
              const SizedBox(height: 18),
              const Text('Sales Manager',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text('تسجيل الدخول إلى لوحة الإدارة',
                  style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 25),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'البريد الإلكتروني',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: true,
                onSubmitted: (_) => login(),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'كلمة المرور',
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity, height: 52,
                child: FilledButton(
                  onPressed: busy ? null : login,
                  child: busy
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('دخول'),
                ),
              ),
            ]),
          ),
        ),
      ),
    ),
  );
}
