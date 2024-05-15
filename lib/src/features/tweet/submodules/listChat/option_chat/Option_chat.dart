// file: option_menu.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class OptionChatList{
  static Future<void> show(BuildContext context, {required VoidCallback deleteAll}) async{
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Xóa cuộc trò chuyện"),
                onTap: () async{
                  deleteAll();
                  Navigator.pop(context); // Đóng modal khi tùy chọn được chọn
                },
              ),
            ],
          ),
        );
      },
    );
  }
  static void deleteAllMessage(String myID, String otherID, ) async {
    final sortId = [myID, otherID];
    sortId.sort();

    String chatID = 'chat${sortId[0]}##vs##${sortId[1]}';
    try{
      final doc = await FirebaseFirestore.instance
          .collection('chat')
          .doc(chatID)
          .collection('conversation')
          .get();

      final messageAll = doc.docs.where((doc) =>
      doc['deleteMe'] == false && doc['userId'] == myID
          ||
          doc['deleteOtherUser'] == false && doc['userId'] == otherID
      );

      for(var item in messageAll)
      {
        final messageID = item.id;
        String temp = item['userId'] == myID? 'deleteMe':'deleteOtherUser';
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(chatID)
            .collection('conversation')
            .doc(messageID)
            .update({temp:true});
        print("xóa tất cả tin nhắn thành công");
      }

    }
    catch(e){
      print("not found doc");
    }
  }
}