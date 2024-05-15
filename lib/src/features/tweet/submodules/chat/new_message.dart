

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class NewMessage extends StatefulWidget {
  final String? uidAuth;
  final String? identifier;

  const
  NewMessage({Key? key,this.uidAuth, this.identifier}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    _messageController.clear();

    // lấy thông tin của người dùng hiện tại
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final sortId = [user.uid, widget.uidAuth];
    sortId.sort();
    String id = 'chat${sortId[0]}##vs##${sortId[1]}';

    DocumentReference messageRef = await FirebaseFirestore.instance.collection('chat').doc(id).collection('conversation').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['identifier'],
      'userImage': userData.data()!['imgUrl'],
      'RecipientName': widget.identifier,
      'RecipientId': widget.uidAuth,
      'deleteMe': false ,
      'deleteOtherUser' : false ,
    });
    String messageId = messageRef.id;
    await messageRef.update({'messageID': messageId});
  }
  bool _showEmoji = false, _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 15), // kích thước khung Chat

      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nhắn tin...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),),
                  ),

                  IconButton(

                    onPressed: () {  },
                    icon: const Icon(Icons.image,
                        color: Colors.blueAccent, size: 26),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: _submitMessage,
            minWidth: 0,
            padding:
            const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.blueAccent,
            child: const Icon(Icons.send, color: Colors.white, size: 26),
          ),

        ],
      ),
    );
  }
}


