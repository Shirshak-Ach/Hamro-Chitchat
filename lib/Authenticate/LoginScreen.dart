import 'package:flutter/material.dart';
import 'package:hamro_chitchat/Authenticate/CreateAccountScreen.dart';
import 'package:hamro_chitchat/Screen/BottomNavigation.dart';
import 'package:hamro_chitchat/UserFunction.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.width / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height / 20),
                  Container(
                    width: size.width / 1.4,
                    height: size.height / 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                    child: Text("Hamro ChitChat",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  SizedBox(height: size.height / 20),
                  Container(
                    width: size.width / 1.3,
                    child: Text(
                      "Sign In ",
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: size.height / 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(
                          size, "email", Icons.account_box_outlined, _email),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "password", Icons.lock, _password),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height / 50,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (_email.text.isEmpty ||
                                    _password.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Enter a Valid Email And Passord Length > 6')));
                                }
                                if (_email.text.isNotEmpty &&
                                    _password.text.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  logIn(_email.text, _password.text)
                                      .then((user) {
                                    if (user != null) {
                                      print("Login Sucess");
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavigation()));
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Your email is not registered with us. Please Create Account to Continue.')));
                                    }
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please Fill the form Correctly.')));
                                }
                              },
                              child: allButtons(
                                  size, "Login", Colors.white, Colors.blue)),
                          SizedBox(
                            height: size.height / 20,
                          ),
                          GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => CreateAccount())),
                              child: allButtons(size, " Create Account ",
                                  Colors.blue, Colors.white)),
                          SizedBox(
                            height: size.height / 15,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Feature Is Not Added. Create an Account then Continue.')));
                                googleSignIn().then((user) {
                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavigation()));
                                  }
                                });
                              },
                              child: Text(
                                "Google SignIn",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget allButtons(Size size, String text, Color txtColor, Color boxColor) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: boxColor,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: txtColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget field(Size size, String hintText, IconData iconData,
      TextEditingController controller) {
    return Container(
        height: size.height / 12,
        width: size.width / 1.3,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: Icon(iconData),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ));
  }
}
