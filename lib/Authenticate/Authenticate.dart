import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamro_chitchat/Authenticate/LoginScreen.dart';
import 'package:hamro_chitchat/Screen/BottomNavigation.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null)
      return BottomNavigation();
    else
      return LoginPage();
  }
}
