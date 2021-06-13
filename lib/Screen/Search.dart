import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hamro_chitchat/Screen/Chat.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic> userMap;
  bool isLoading = false;

  final TextEditingController _search = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("users")
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });

    print(userMap);
  }

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
            : Column(children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height / 10,
                            width: size.width / 1.23,
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _search,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20),
                                hintText: "Search",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(
                                  Icons.image_search_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width / 90,
                          ),
                          GestureDetector(
                            onTap: onSearch,
                            child: Container(
                              height: size.height / 11,
                              width: size.width / 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue[100]),
                              child: Icon(Icons.search, size: 43),
                            ),
                          ),
                        ])),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoomId(
                              _auth.currentUser.displayName, userMap['name']);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Chat(
                                chatRoomId: roomId,
                                userMap: userMap,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.account_box, color: Colors.blue),
                        title: Text(
                          userMap['name'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(userMap['email']),
                        trailing: Icon(
                          Icons.chat,
                          color: Colors.blue,
                        ),
                      )
                    : Container(),
              ]));
  }
}
