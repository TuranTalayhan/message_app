import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_app/pages/home/profile_view/profile_view.dart';
import 'package:message_app/pages/home/settings/account.dart';
import 'package:message_app/pages/home/settings/account/change_email.dart';
import 'package:message_app/pages/home/settings/account/change_password.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (_) =>
                AuthService(FirebaseAuth.instance, FirebaseFirestore.instance)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
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
          "/profile_view": (context) => const ProfileView(),
          "/change_email": (context) => const ChangeEmail(),
          "/change_password": (context) => const ChangePassword(),
        },
      ),
    );
  }
}
