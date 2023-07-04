import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:message_app/pages/home/calls.dart';
import 'package:message_app/pages/home/chats.dart';
import 'package:message_app/pages/home/contacts.dart';
import 'package:message_app/pages/home/settings.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

final bool isDarkMode =
    SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;

int currentPageIndex = 0;

final widgets = <Widget>[
  const Chats(),
  const Calls(),
  const Contacts(),
  const Settings()
];

class _NavigationBarPageState extends State<NavigationBarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass)),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await Provider.of<AuthService>(context, listen: false)
                      .signOut();
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
              icon: const FaIcon(FontAwesomeIcons.solidUser)),
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
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: widgets[currentPageIndex],
    );
  }
}
