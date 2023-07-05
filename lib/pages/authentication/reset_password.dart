import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final bool _isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  final _email = TextEditingController();

  late bool _error;

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    try {
      _error = false;
      await Provider.of<AuthService>(context, listen: false)
          .sendPasswordResetEmail(_email.text);
    } catch (e) {
      _error = true;
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
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const SizedBox(
            height: 140,
          ),
          const Text(
            "Enter your email adress",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            "Enter your email adress to receive a password reset email",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.grey[700],
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 50),
          TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                  labelText: "Your email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.teal))),
          const SizedBox(height: 60),
          SizedBox(
            width: MediaQuery.of(context).size.width - 70,
            child: !_isLoading
                ? TextButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _resetPassword();
                      setState(() {
                        _isLoading = false;
                      });
                      if (!_error && context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Password reset email has been sent",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reset Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal)),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
