import 'package:tweet_app/src/features/tweet/submodules/chat/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  final String? uidAuth;
  final String? identifier;

  const ChatMessages({Key? key, this.uidAuth, this.identifier}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  String? chatId;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser!;
    final sortId = [me.uid, widget.uidAuth];
    sortId.sort();
    String id = 'chat${sortId[0]}##vs##${sortId[1]}';
    if (id == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .doc(id)
          .collection('conversation')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No messages',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          );
        }
        if (chatSnapshot.hasError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        final loadedMessages = chatSnapshot.data!.docs
            .where(
                (doc) =>
            doc['deleteMe'] == false && doc['userId'] == me.uid
                ||
                doc['deleteOtherUser'] == false && doc['userId'] == widget.uidAuth
        );
        if(loadedMessages.isEmpty)
        {
          return Center(
            child: Text(
              'No messages',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          );
        }

        final filteredMessages = loadedMessages.toList();
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 30, left: 13, right: 13),
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: filteredMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = filteredMessages[index].data();
            final nextChatMessage = index + 1 < filteredMessages.length
                ? filteredMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
            nextChatMessage != null ? nextChatMessage['userId'] : null;

            final nextUserisSame = nextMessageUserId == currentMessageUserId;
            if (nextUserisSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: me.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: me.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}

