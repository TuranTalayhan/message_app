import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _getDisplayname() {
    try {
      return Provider.of<AuthService>(context, listen: false).displayName;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/profile");
              },
              child: ListTile(
                title: Text(_getDisplayname()),
                subtitle: const Text("status"),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.teal,
                      size: 30,
                    )),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.person))),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Account"),
                subtitle: const Text("Privacy, security, change number"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(MdiIcons.keyOutline))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Chat"),
                subtitle: const Text("Chat history,theme,wallpapers"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.message_outlined))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Notifications"),
                subtitle: const Text("Messages, group and others"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                        child: Icon(Icons.notifications_outlined))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Help"),
                subtitle: const Text("Help center,contact us, privacy policy"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.help_outline))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Storage and data"),
                subtitle: const Text("Network usage, stogare usage"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.swap_vert_outlined))),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text("Invite a friend"),
                leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal[50]!.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.person_outline))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
