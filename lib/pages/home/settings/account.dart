import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/database_service.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, "/change_email"),
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal[50]!.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(Icons.email_outlined)),
                ),
                title: const Text("Change email"),
                subtitle: const Text("Change your email address"),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => Navigator.pushNamed(context, "/change_password"),
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal[50]!.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(Icons.password_outlined)),
                ),
                title: const Text("Change password"),
                subtitle: const Text("Change your password"),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _logout(),
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal[50]!.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(Icons.logout_outlined)),
                ),
                title: const Text("Logout"),
                subtitle: const Text("Logout from your account"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _logout() async {
    try {
      await context.read<DatabaseService>().signOut();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }
}
