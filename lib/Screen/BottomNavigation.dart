import 'package:flutter/material.dart';
import 'package:hamro_chitchat/Screen/HomeScreen.dart';
import 'package:hamro_chitchat/Screen/Search.dart';
import 'package:hamro_chitchat/UserFunction.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final tabs = [
    HomeScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            tooltip: 'HomePage',
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => super.widget));
            },
            icon: Icon(Icons.home)),
        title: Text("Hamro ChitChat"),
        actions: [
          IconButton(
              onPressed: () => logOut(context),
              tooltip: 'LogOut',
              icon: Icon(Icons.logout)),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        selectedFontSize: 11,
        unselectedFontSize: 9,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
