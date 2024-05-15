import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../submodules/chat/chat_screen.dart';
import 'dart:async';

import 'option_chat/Option_chat.dart';

class ChatUsersList extends StatefulWidget {
  const ChatUsersList({Key? key}) : super(key: key);

  @override
  State<ChatUsersList> createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  StreamController<List<Map<String, dynamic>>> userListController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final me = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>>? temp;

  @override
  void initState() {
    super.initState();
    getUsersWithMessagesStream();
    updateChatList();
  }

  @override
  void dispose() {
    userListController.close(); // Đảm bảo đóng StreamController khi State bị hủy.
    super.dispose();
  }

  Future<void> getUsersWithMessagesStream() async {

    if (me == null) {
      throw Exception('No current user');
    }

    final usersCollection = FirebaseFirestore.instance.collection('users');

    usersCollection.snapshots().listen((usersSnapshot) async {
      final List<Map<String, dynamic>> usersWithMessages = [];

      for (var user in usersSnapshot.docs) {
        final sortId = [me.uid, user.id];
        sortId.sort();
        final chatId = 'chat${sortId[0]}##vs##${sortId[1]}';

        try {
          final chatSnapshot = await FirebaseFirestore.instance
              .collection('chat')
              .doc(chatId)
              .collection('conversation')
              .orderBy('createdAt', descending: true)
              .get();

          final check = chatSnapshot.docs.where((doc) =>
          doc['deleteMe'] == false && doc['userId'] == me.uid
              ||
              doc['deleteOtherUser'] == false && doc['userId'] != me.uid
          ).toList();

          if (check.isNotEmpty) {
            final latestMessage = check[0]['text'];
            final timeSend = check[0]['createdAt'];


            //lấy hình ảnh xuống
            String? Url;
            final ref = FirebaseStorage.instance.ref().child(user['iconPhoto']);
            try{
              final getUrl = await ref.getDownloadURL();
              setState(() {
                Url = getUrl;
              });
            }
            catch(e){
              print('Failed to fetch profile. please login again.');
            }

            usersWithMessages.add({
              'id': user.id,
              'iconPhoto': Url,
              'identifier': user['identifier'],
              'latestMessage': latestMessage??'',
              'bannerPhoto': user['bannerPhoto'],
              'createdAt': timeSend,
            });
          }
        } catch (e) {
          print('Error fetching chat: $e');
        }
      }

      usersWithMessages.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      temp = usersWithMessages;
      userListController.add(temp!);
    });

  }

  Future<void> updateChatList() async{
    getUsersWithMessagesStream();
  }

  @override
  Widget build(BuildContext contextX) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: userListController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          final usersWithMessages = snapshot.data;

          if (usersWithMessages == null || usersWithMessages.isEmpty) {
            return const Center(
              child: Text('No users with messages'),
            );
          }

          return ListView.builder(
            itemCount: usersWithMessages.length,
            itemBuilder: (context, index) {
              final user = usersWithMessages[index];
              return GestureDetector(
                onTap: () {
                  userListController.stream;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        uidAuth: user['id'],
                        identifier: user["identifier"],
                      ),
                    ),
                  ).then((_) {
                    updateChatList();
                  });

                },
                onLongPress: () async {
                  await OptionChatList.show(
                    context,
                    deleteAll: () {
                      OptionChatList.deleteAllMessage(me.uid , user['id'] );
                      temp = temp?.where((doc) => doc['id'] != user['id']).toList();
                      userListController.add(temp!);
                    },
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(user['iconPhoto']),
                  ),
                  title: Text(user['identifier']),
                  subtitle: Text(
                    (user['latestMessage'] != null)
                        ? (user['latestMessage'].toString().length >= 25)
                        ? "${user['latestMessage'].toString().substring(0, 25)}..."
                        : user['latestMessage']
                        : "No message",
                  ),
                  trailing: Opacity(
                    opacity: 0.5,
                    child: Text(
                      DateFormat('h:mm a').format(user['createdAt'].toDate()),
                      style: const TextStyle(height: 4),
                    ),
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}
