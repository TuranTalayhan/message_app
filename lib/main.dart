import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_app/pages/home/settings/account.dart';
import 'package:message_app/pages/home/settings/qr_code_page.dart';
import 'package:message_app/pages/home/settings/scanning_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/authentication/auth_gate.dart';
import 'pages/authentication/auth_page.dart';
import 'pages/authentication/login_page.dart';
import 'pages/authentication/reset_password.dart';
import 'pages/authentication/sign_up.dart';
import 'pages/home/settings/profile.dart';
import 'services/auth_service.dart';
import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (context) => AuthService(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: Themes.light,
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: "/auth_gate",
      routes: {
        "/auth_gate": (context) => const AuthGate(),
        "/auth_page": (context) => const AuthPage(),
        "/login_page": (context) => const LoginPage(),
        "/sign_up_page": (context) => const SignUpPage(),
        "/reset_password": (context) => const ResetPassword(),
        "/profile": (context) => const Profile(),
        "/qr_code": (context) => const QrCodePage(),
        "/scanning_page": (context) => const ScanningPage(),
        "/account": (context) => const Account(),
      },
    );
  }
}
