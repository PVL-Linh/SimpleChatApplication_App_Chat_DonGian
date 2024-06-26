import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TweetRequestModel {
  final String docName;
  final List<String> images;
  final List<String> likesUidUsers;
  final int likesValue;
  final DateTime postCreationTime;
  final String text;
  final String uidPoster;
  final List<String> commentDocNames;
  final bool isComment;

  TweetRequestModel(
      {required this.docName,
      required this.images,
      required this.likesUidUsers,
      required this.likesValue,
      required this.postCreationTime,
      required this.text,
      required this.uidPoster,
      required this.commentDocNames,
      required this.isComment});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docName': docName,
      'images': images,
      'likesUidUsers': likesUidUsers,
      'likesValue': likesValue,
      'postCreationTime': postCreationTime.millisecondsSinceEpoch,
      'text': text,
      'ownerUid': uidPoster,
    };
  }

  factory TweetRequestModel.fromMap(Map<String, dynamic> map) {
    return TweetRequestModel(
      docName: map['docName'] as String,
      images: List<String>.from(map['images'] as List<dynamic>),
      likesUidUsers: List<String>.from(map['likesUidUsers'] as List<dynamic>),
      likesValue: map['likesValue'] as int,
      postCreationTime: (map['postCreationTime'] as Timestamp)
          .toDate(), // Convert to DateTime
      text: map['text'] as String,
      uidPoster: map['ownerUid'] as String,
      commentDocNames:
          List<String>.from(map['commentDocNames'] as List<dynamic>),
      isComment: map['isComment'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TweetRequestModel.fromJson(String source) =>
      TweetRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  TweetRequestModel copyWith({
    String? docName,
    List<String>? images,
    List<String>? likesUidUsers,
    int? likesValue,
    DateTime? postCreationTime,
    String? text,
    String? uidPoster,
    List<String>? commentDocNames,
    bool? isComment,
  }) {
    return TweetRequestModel(
        docName: docName ?? this.docName,
        images: images ?? this.images,
        likesUidUsers: likesUidUsers ?? this.likesUidUsers,
        likesValue: likesValue ?? this.likesValue,
        postCreationTime: postCreationTime ?? this.postCreationTime,
        text: text ?? this.text,
        uidPoster: uidPoster ?? this.uidPoster,
        commentDocNames: commentDocNames ?? this.commentDocNames,
        isComment: isComment ?? this.isComment);
  }

  @override
  String toString() {
    return 'TweetRequestModel(docName: $docName, images: $images, likesUidUsers: $likesUidUsers, likesValue: $likesValue, postCreationTime: $postCreationTime, text: $text, uidPoster: $uidPoster, commentDocNames: $commentDocNames, isComment: $isComment)';
  }

  DateTime getTweetDate() {
    return postCreationTime;
  }
}
