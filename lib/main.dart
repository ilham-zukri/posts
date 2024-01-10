import 'package:flutter/material.dart';
import 'package:posts/pages/login_page.dart';
import 'package:posts/pages/main_page.dart';
import 'package:posts/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool authenticated = false;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString("token");
  if(token != null){
    try {
      authenticated = await Services.validateToken();
    }catch(e){
      await pref.clear();
      authenticated = false;
      debugPrint(e.toString());
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade600
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600
        )
      ),
      home: authenticated ? const MainPage() : const LoginPage(),
    );
  }
}

