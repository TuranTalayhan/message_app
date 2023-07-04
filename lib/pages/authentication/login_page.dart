import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  final email = TextEditingController();

  final password = TextEditingController();

  late bool error;

  bool isLoading = false;

  Future<void> signInUser() async {
    try {
      error = false;
      await Provider.of<AuthService>(context, listen: false)
          .signInWithEmailAndPassword(email.text, password.text);
    } catch (e) {
      error = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Log in to MessageApp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Text(
                "Welcome back! Sign in using your email to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Your email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 70,
                      child: !isLoading
                          ? TextButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await signInUser();
                                setState(() {
                                  isLoading = false;
                                });
                                if (!error && context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Logged in successfully",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green));
                                  Navigator.pop(context);
                                }
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.teal)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Log in",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.teal)),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, "/reset_password"),
                    child: const Text("Forgot password?",
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold)),
                  )
                ],
              )),
            ],
          ),
        ));
  }
}
