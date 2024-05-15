import 'package:tweet_app/src/features/tweet/submodules/chat/chat_messages.dart';
import 'package:tweet_app/src/features/tweet/submodules/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatScreen extends StatefulWidget {
  final String? uidAuth;
  final String? identifier;
  const ChatScreen({Key? key,this.uidAuth, this.identifier,}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? url;
  void setupPushNotifications() async {
    final me = FirebaseMessaging.instance;
    await me.requestPermission();
    me.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
    getUrl();
  }

  // Dòng mã này được sử dụng để lấy URL tải xuống của hình ảnh từ Firebase Storage.
  void getUrl() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Images/${widget.uidAuth}/anhDaiDien/profile_banner_default');

    try {
      final downloadURL = await ref.getDownloadURL();
      print('Download URL: $downloadURL');
      setState(() {
        url = downloadURL;
      });
      // Thực hiện các thao tác khác với downloadURL tại đây
    } catch (e) {
      print('Error getting download URL: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: Theme.of(context).appBarTheme.scrolledUnderElevation,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 8 , top : 10),
          child: CircleAvatar(
            foregroundImage: url != null ? NetworkImage(url!) : null,
          ),
        ),
        title: Text(
          widget.identifier ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call , color: Colors.blue,),
            onPressed: () {
              // Xử lý sự kiện gọi điện ở đây
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call , color: Colors.blue),
            onPressed: () {
              // Xử lý sự kiện gọi video ở đây
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(child:  ChatMessages(uidAuth: widget.uidAuth ??'',identifier: widget.identifier??'')),
          const SizedBox(
            height: 5,
          ),
          NewMessage(uidAuth: widget.uidAuth ??'',identifier: widget.identifier??''),
        ],
      ),
    );
  }
}
