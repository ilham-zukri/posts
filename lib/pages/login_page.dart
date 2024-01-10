import 'package:flutter/material.dart';
import 'package:posts/pages/register_page.dart';
import 'package:posts/widgets/custom_text_field.dart';

import '../services.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextField(
              label: "Nim",
              controller: nimController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            customTextField(
              label: "Password",
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    sendLogin();
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage()
                      )
                    );
                  },
                  child: const Text("Register"),
                ),
                const SizedBox(
                  width: 16,
                )
              ]
            )
          ],
        ),
      ),
    );
  }
  Future<void> sendLogin() async {
    setState(() {
      isLoading = true;
    });
    String nim = nimController.text.trim();
    String password = passwordController.text;
    try {
      Map? response = await Services.login(
          nim: nim, password: password);
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response!["message"]),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
        debugPrint(e.toString());
      }
    }
  }
}
