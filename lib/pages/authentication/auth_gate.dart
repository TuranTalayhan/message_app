import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/navigation_bar_page.dart';
import 'auth_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const NavigationBarPage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
