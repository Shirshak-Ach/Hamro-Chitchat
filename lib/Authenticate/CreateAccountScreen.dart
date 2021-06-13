import 'package:flutter/material.dart';
import 'package:hamro_chitchat/Authenticate/LoginScreen.dart';
import 'package:hamro_chitchat/Screen/BottomNavigation.dart';
import 'package:hamro_chitchat/UserFunction.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
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
                    child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height / 20),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          width: size.width / 8,
                          child: IconButton(
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage())),
                              icon: Icon(Icons.arrow_back)),
                        ),
                        SizedBox(width: size.width / 25),
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
                      ],
                    ),
                    SizedBox(height: size.height / 40),
                    Container(
                      width: size.width / 1.3,
                      child: Text(
                        "SignUp",
                        style: TextStyle(fontSize: 25, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: size.height / 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: size.width,
                              alignment: Alignment.center,
                              child: field(size, "Name", Icons.person, _name),
                            ),
                            SizedBox(height: size.height / 50),
                            Container(
                              width: size.width,
                              alignment: Alignment.center,
                              child: field(size, "email",
                                  Icons.account_box_outlined, _email),
                            ),
                            SizedBox(
                              height: size.height / 50,
                            ),
                            Container(
                              width: size.width,
                              alignment: Alignment.center,
                              child: field(
                                  size, "password", Icons.lock, _password),
                            ),
                          ],
                        ),
                      ),
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
                                  if (_name.text.isEmpty ||
                                      _email.text.isEmpty ||
                                      _password.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please Enter a Valid Name, Email & Passord Length > 6')));
                                  }
                                  if (_name.text.isNotEmpty &&
                                      _email.text.isNotEmpty &&
                                      _password.text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    createAccount(_name.text, _email.text,
                                            _password.text)
                                        .then((user) {
                                      if (user != null) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavigation()));
                                        print("Account Created SucessFully");
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Enter a Name , Valid Email And Passord Length > 6')));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateAccount()));
                                      }
                                    });
                                  }
                                },
                                child: allButtons(size, "Create Account",
                                    Colors.white, Colors.blue)),
                            SizedBox(
                              height: size.height / 50,
                            ),
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: allButtons(
                                    size,
                                    "Already Have an Account",
                                    Colors.blue,
                                    Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
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
        height: size.height / 15,
        width: size.width / 1.3,
        child: TextFormField(
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
