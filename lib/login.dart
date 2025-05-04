
import 'package:firebase2/home.dart';
import 'package:firebase2/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool islogin = false;

  login() async {
    try {
      islogin = true;
      setState(() {});
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      islogin = false;
      setState(() {});
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: emailController),
          SizedBox(height: 11),
          TextField(controller: passwordController),
          SizedBox(height: 11),
          ElevatedButton(
            onPressed: () {
              login();
            },
            child: Text("Login"),
          ),
          SizedBox(height: 11),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: Text("Alredy have an account?"),
          ),
          SizedBox(height: 12),
          Visibility(visible: islogin, child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
