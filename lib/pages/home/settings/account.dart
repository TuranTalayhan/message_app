import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';

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
      body: ListView(
        children: [
          InkWell(
            onTap: () async {
              try {
                await Provider.of<AuthService>(context, listen: false)
                    .signOut();
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
            },
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
    );
  }
}
