import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hamro_chitchat/Authenticate/LoginScreen.dart';

Future<User> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    User user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Account Created Sucessfully");

      user.updateProfile(displayName: name);

      await _firestore.collection('users').doc(_auth.currentUser.uid).set({
        "name": name,
        "email": email,
        "password": password,
        "status": "Offline",
        "uid": _auth.currentUser.uid,
      });
      return user;
    } else {
      print("Account Creation failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Login Sucessful");
      return user;
    } else {
      print("Account Creation failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    ///SignOut with username and password
    await _auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
    ////Signing out through google SignIn
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();

    ///-------////
  } catch (e) {
    print("An unexpected Error Occured");
  }
}

Future googleSignIn() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();

  if (_googleSignInAccount != null) {
    var _authentication = await _googleSignInAccount.authentication;

    var _credential = GoogleAuthProvider.credential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken);
    UserCredential userCredential =
        await _auth.signInWithCredential(_credential);

    return userCredential.user;
  } else {
    throw FirebaseAuthException(
      message: "Sign in aborded by user",
      code: "ERROR_ABORDER_BY_USER",
    );
  }
}
