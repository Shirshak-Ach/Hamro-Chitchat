import 'package:firebase_auth/firebase_auth.dart';
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
      ),
      endDrawer: MyDrawer(),
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

class MyDrawer extends StatelessWidget {
  final Function onTap;
  FirebaseAuth _auth = FirebaseAuth.instance;
  MyDrawer({this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[300]),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            'https://www.naps.com.au/media/1060/user-icon-placeholder-1.png?width=360&height=400&anchor=center&mode=crop'),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      _auth.currentUser.displayName,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _auth.currentUser.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Ink(
              color: Colors.grey[200],
              child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                title: Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Divider(
              height: 5,
            ),
            Ink(
              color: Colors.grey[200],
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                title: Text('Settings'),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Divider(
              height: 5,
            ),
            Ink(
              color: Colors.grey[200],
              child: ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                ),
                onTap: () => logOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

