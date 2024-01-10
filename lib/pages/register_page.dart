import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextField(
              label: "Name",
              controller: _nameController,
            ),
            const SizedBox(
              height: 16,
            ),
            customTextField(
              label: "Nim",
              controller: _nimController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            customTextField(
              label: "Password",
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  sendRegistration();
                },
                child: const Text("Register"),
              )
            ),
          ]
        )
      )
    );
  }
  Future<void> sendRegistration() async {
    setState(() {
      isLoading = true;
    });
    String name = _nameController.text.trim();
    String nim = _nimController.text.trim();
    String password = _passwordController.text;
    try {
      Response? response = await Services.register(
        name: name,
        nim: nim,
        password: password,
      );
      setState(() {
        isLoading = false;
      });
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.blue,
                content: Text(
                  response!.data['message'],
                )
            )
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              e.toString(),
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        );
      }
    }
  }
}
