import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hamro_chitchat/Screen/Chat.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final TextEditingController _search = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final fb = FirebaseDatabase.instance.reference().child("users");
  Map<String, dynamic> map;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void getDataforChat(int index) async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("users")
        .where("name", isNotEqualTo: _auth.currentUser.displayName)
        .get()
        .then((value) {
      setState(() {
        map = value.docs[index].data();
      });
    });
  }

  Future getMessagesFuture() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .where("name", isNotEqualTo: _auth.currentUser.displayName)
        .get();
    return querySnapshot;
  }

  Stream getMessagesStream() async* {
    QuerySnapshot querySnapshot2 = await _firestore
        .collection("users")
        .where("name", isNotEqualTo: _auth.currentUser.displayName)
        .get();
    yield querySnapshot2;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 30,
            ),
            Text(
              "Talk With People In Hamro ChitChat",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            Container(
                height: size.height / 1.25,
                width: size.width,
                color: Colors.grey[200],
                child: FutureBuilder(
                    future: getMessagesFuture(),
                    builder: (builder, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (builder, index) {
                              return Card(
                                borderOnForeground: true,
                                color: Colors.white,
                                child: ListTile(
                                  onTap: () {
                                    getDataforChat(index);
                                    String roomId = chatRoomId(
                                        _auth.currentUser.displayName,
                                        map['name']);
                                    isLoading = false;
                                    isLoading
                                        ? CircularProgressIndicator()
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Chat(
                                                      chatRoomId: roomId,
                                                      userMap: map,
                                                    )));
                                  },
                                  leading: Icon(Icons.ac_unit),
                                  title: Text(
                                      snapshot.data.docs[index].data()['name']),
                                  subtitle: Text(snapshot.data.docs[index]
                                      .data()['email']),
                                  trailing: Icon(Icons.chat_bubble_outline),
                                ),
                              );
                            });
                      }
                    })),
          ],
        ),
      ),
    );
  }
}
