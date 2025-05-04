// ignore_for_file: unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  registerUser() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
         
    EmailUser() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(credential.user!.uid)
        .set({
          "email": emailController.text,
          "id": credential.user!.uid,
          
        })
        .then((Value) => print("Done"))
        .onError((error, stackTrace) => print("$error"));
          } 

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
              registerUser();
            },
            child: Text("Register"),
          ),
        ],
      ),
    );
  }
}
