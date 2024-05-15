/*
* /*
* import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Chatlisst extends StatefulWidget {
  @override
  _ChatlisstState createState() => _ChatlisstState();
}

class _ChatlisstState extends State<Chatlisst> {
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
    getCurrentUser();
  }

  Future<void> fetchUserList() async {
    final userSnapshot = await FirebaseFirestore.instance.collection('users')
        .get();
    List<Map<String, dynamic>> fetchedUserList = userSnapshot.docs
        .map((userDoc) => userDoc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      userList = fetchedUserList;
    });
  }

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? currentUserName = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(
          'users').doc(user.uid).get();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat')
          .where('sender', isEqualTo: currentUserName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot otherUserSnapshot = querySnapshot.docs[0];
        String currentUserName = otherUserSnapshot['name'];
        // Tiếp tục xử lý thông tin người dùng khác ở đây
      } else {
        // Người dùng không tồn tại trong cơ sở dữ liệu
      }
    } else {
      // Người dùng chưa đăng nhập
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.white
        , foregroundColor: Colors.black,
        centerTitle: true, // Căn giữa văn bản trong thanh AppBar
      ),
      body: Center(
        child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return buildUserWidget(userList[index]);
          },
        ),
      ),
    );
  }

  Widget buildUserWidget(Map<String, dynamic> user) {
    User? user1 = FirebaseAuth.instance.currentUser;
    String? currentUserName = user1?.displayName;
    String name = user['name'] ?? '';
    String email = user['email'] ?? '';

    Stream<bool> hasMessagesStream = Stream.value(true);
    return StreamBuilder<bool>(
      stream: hasMessagesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        if (snapshot.data!) {
          return GestureDetector(
            onTap: () {
              navigateToChatRoom(user);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(name[0]),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> navigateToChatRoom(Map<String, dynamic> recipientUser) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    String recipientId = '#';

    // Find recipient user in the userList
    recipientUser = userList.firstWhere((user) => user['uid'] == recipientId);

    // Check if chat room document exists
    final chatDocRef = FirebaseFirestore.instance.collection('chat')
        .doc('chat${user.uid}##vs##${recipientId}');
    final chatDocSnap = await chatDocRef.get();

    if (!chatDocSnap.exists) {
      // Create chat room document
      await chatDocRef.set({
        'createdAt': Timestamp.now(),
        'users': [user.uid, recipientId],
        'lastMessage': {
          'createdAt': Timestamp.now(),
          'text': '',
        },
      });
    }

    // Navigate to chat room screen
    // ...
  }
}*/
import '../../submodules/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tweet_app/src/features/tweet/submodules/chat/chat_screen.dart';
class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
    getCurrentUser();
  }

  Future<void> fetchUserList() async {
    final userSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> fetchedUserList = userSnapshot.docs
        .map((userDoc) => userDoc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      userList = fetchedUserList;
    });
  }
  void getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? currentUserName = user.displayName;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat')
          .where('sender', isEqualTo: currentUserName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot otherUserSnapshot = querySnapshot.docs[0];
        String currentUserName = otherUserSnapshot['name'];
        // Tiếp tục xử lý thông tin người dùng khác ở đây
      } else {
        // Người dùng không tồn tại trong cơ sở dữ liệu
      }
    } else {
      // Người dùng chưa đăng nhập
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return buildUserWidget(userList[index]);
          },
        ),
      ),
    );
  }


  Widget buildUserWidget(Map<String, dynamic> user) {
    User? user1 = FirebaseAuth.instance.currentUser;
    String name = user['identifier'] ?? '';
    String email = user['createAt'] ?? '';
    String? currentUserId = user1?.uid;
    String recipientId = user['uidAuth'] ?? '';

    final chatSnapshot = FirebaseFirestore.instance
        .collection('chat')
        .doc('chat$currentUserId##vs##$recipientId')
        .collection('conversation')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    Stream<bool> hasMessagesStream = FirebaseFirestore.instance
        .collection('chat')
        .doc('chat$currentUserId##vs##$recipientId')
        .collection('conversation')
        .orderBy("createAt" , descending: true)
        .limit(1)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);





    return StreamBuilder<bool>(
      stream: hasMessagesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        if (snapshot.data!) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(id: name,),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(name[0]),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,


                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }


  Future<void> navigateToChatRoom(Map<String, dynamic> recipientUser) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserName = user?.displayName;

    if (user != null) {
      String? currentUserId = user.uid;
      String recipientId = recipientUser['uidAuth'] ?? '';

      final chatDocRef = FirebaseFirestore.instance
          .collection('chat')
          .doc('chat$currentUserId##vs##$recipientId');
      final chatDocSnap = await chatDocRef.get();

      if (!chatDocSnap.exists) {
        await chatDocRef.set({
          'createdAt': Timestamp.now(),
          'users': [currentUserId, recipientId],
          'lastMessage': {
            'createdAt': Timestamp.now(),
            'text': '',
           },
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(id: recipientId,)
          ),
        );

      }


      // Navigate to chat room screen
      // ...
    }
  }
}*/

