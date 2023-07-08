import 'package:flutter/material.dart';
import 'package:message_app/pages/home/profile_view/profile_view_arguments.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfileViewArguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(child: Text(args.uid)),
    );
  }
}
