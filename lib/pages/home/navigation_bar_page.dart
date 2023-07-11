import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import 'calls.dart';
import 'chats.dart';
import 'contacts.dart';
import 'settings.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentPageIndex = 0;
  final _contactUid = TextEditingController();

  final _widgets = <Widget>[
    const Chats(),
    const Calls(),
    const Contacts(),
    const Settings()
  ];

  @override
  void dispose() {
    _contactUid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          if (_currentPageIndex == 2)
            IconButton(
                onPressed: () {
                  _showDialog();
                },
                icon: const Icon(Icons.person_add_alt_1_outlined))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message_outlined,
                size: 30,
              ),
              label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.phone_in_talk_outlined,
                size: 30,
              ),
              label: "Calls"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
              label: "Contacts"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                size: 30,
              ),
              label: "Settings")
        ],
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
      body: _widgets[_currentPageIndex],
    );
  }

  Future<void> _addContact(String? contactUid) async {
    await context.read<DatabaseService>().addContact(contactUid);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: const Text("Add contact"),
              content: TextField(
                controller: _contactUid,
                decoration:
                    const InputDecoration(hintText: "Enter friend code"),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                        await _addContact(_contactUid.text.isNotEmpty
                            ? _contactUid.text
                            : null);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Added to contacts successfully",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green));
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
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Submit"))
              ],
            ));
  }
}
