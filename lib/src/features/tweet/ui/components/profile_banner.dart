
import 'dart:io';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../submodules/chat/chat_screen.dart';


class ProfileBanner extends StatefulWidget {
  final Image imageBanner;
  final String imageAvatar;
  final String identifier;
  final int followingQuantity;
  final int followersQuantity;
  final bool isFollowing;
  final String uidAuth;
  final VoidCallback followButtonFunction;

  const ProfileBanner({
    Key? key,
    required this.imageBanner,
    required this.imageAvatar,
    required this.identifier,
    required this.followingQuantity,
    required this.followersQuantity,
    required this.isFollowing,
    required this.uidAuth,
    required this.followButtonFunction,
  }) : super(key: key);



  @override
  State<ProfileBanner> createState() => _ProfileBannerState();
}

class _ProfileBannerState extends State<ProfileBanner> {
  final int coverHeight = 250;
  final int radiusAvatar = 75;

  File? pickedFile;
  String? Url;

  final me = FirebaseAuth.instance.currentUser;

  Future<void> uploadImageToFirebase(File imageFile) async {
    try {
      String folderPath = 'Images/${me!.uid}/anhDaiDien';
      String fileName = '${path.basename(imageFile.path)}';

      final firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child(folderPath);

      // Lấy danh sách tệp tin trong thư mục
      final ListResult result = await ref.listAll();

      // Xóa tất cả các tệp tin trong thư mục trừ tệp tin mới (sau khi đổi tên)
      for (final firebase_storage.Reference fileRef in result.items) {
        if (fileRef.name != fileName) {
          await fileRef.delete();
        }
      }

      // Tạo tham chiếu đến tệp tin trên Firebase Storage
      final firebase_storage.Reference newFileRef = ref.child(fileName);

      // Tải tệp tin lên Firebase Storage
      await newFileRef.putFile(imageFile);

      // Lấy đường dẫn tới tệp tin đã tải lên
      String imageUrl = await newFileRef.getDownloadURL();

      // Thực hiện xử lý với đường dẫn ảnh đã tải lên
      // Ví dụ: lưu đường dẫn vào cơ sở dữ liệu, hiển thị ảnh lên giao diện, vv.
      print('Đường dẫn ảnh đã tải lên: $imageUrl');

      // Đổi tên ảnh bằng cách tạo một tham chiếu mới và xóa tham chiếu cũ
      final newFileName = 'profile_banner_default';
      final firebase_storage.Reference renamedFileRef =
      firebase_storage.FirebaseStorage.instance.ref().child(folderPath).child(newFileName);
      await renamedFileRef.putFile(imageFile);
      String renamedImageUrl = await renamedFileRef.getDownloadURL();

      // In đường dẫn mới sau khi đã đổi tên
      print('Đường dẫn ảnh sau khi đổi tên: $renamedImageUrl');

      setState(() {
        Url = renamedImageUrl;
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi tải ảnh lên Firebase Storage hoặc đổi tên ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (me?.uid != widget.uidAuth) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: radiusAvatar.toDouble()),
                width: MediaQuery
                    .sizeOf(context)
                    .width,
                height: coverHeight.toDouble(),
                child: widget.imageBanner,
              ),
              Positioned(
                top: (coverHeight - radiusAvatar).toDouble(),
                child: GestureDetector(

                  onTap: () {
                    if (me?.uid == widget.uidAuth) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Chọn ảnh'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    child: const Text('Chọn ảnh từ thư viện'),
                                    onTap: () async {
                                      // Xử lý chọn ảnh từ thư viện ở đây
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        File imageFile = File(pickedFile.path);
                                        await uploadImageToFirebase(imageFile);
                                        setState(() {
                                          this.pickedFile = imageFile;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    child: const Text('Chụp ảnh'),
                                    onTap: () async {
                                      // Xử lý chụp ảnh ở đây
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        File imageFile = File(pickedFile.path);
                                        await uploadImageToFirebase(imageFile);
                                        setState(() {
                                          this.pickedFile = imageFile;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 80,
                    foregroundImage: NetworkImage(
                        pickedFile != null ? Url! : widget.imageAvatar),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.identifier,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    widget.followersQuantity.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Followers',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.followingQuantity.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Following',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.6,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: widget.isFollowing
                        ? MaterialStateProperty.all(Colors.black)
                        : MaterialStateProperty.all(Colors.indigo),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>( // nút được bo tròn 18.0
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: widget.followButtonFunction,
                  child: widget.isFollowing
                      ? const Text(
                    'Following',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20),
                  )
                      : const Text(
                    'Follow',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.35,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.red.withOpacity(
                              0.5); // Màu khi nút được nhấn
                        } else if (states.contains(MaterialState.disabled)) {
                          return Colors.indigo.withOpacity(
                              0.5); // Màu khi nút bị vô hiệu hóa
                        }
                        return Colors.indigo; // Màu mặc định khi không nhấn
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement chat button functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(uidAuth: widget.uidAuth,
                              identifier: widget.identifier,),
                      ),
                    );
                  },
                  child: const Text(
                    'Chat',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1.5,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: radiusAvatar.toDouble()),
                width: MediaQuery
                    .sizeOf(context)
                    .width,
                height: coverHeight.toDouble(),
                child: widget.imageBanner,
              ),
              Positioned(
                top: (coverHeight - radiusAvatar).toDouble(),
                child: GestureDetector(

                  onTap: () {
                    if (me?.uid == widget.uidAuth) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Chọn ảnh'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    child: const Text('Chọn ảnh từ thư viện'),
                                    onTap: () async {
                                      // Xử lý chọn ảnh từ thư viện ở đây
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        File imageFile = File(pickedFile.path);
                                        await uploadImageToFirebase(imageFile);
                                        setState(() {
                                          this.pickedFile = imageFile;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    child: const Text('Chụp ảnh'),
                                    onTap: () async {
                                      // Xử lý chụp ảnh ở đây
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        File imageFile = File(pickedFile.path);
                                        await uploadImageToFirebase(imageFile);
                                        setState(() {
                                          this.pickedFile = imageFile;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 80,
                    foregroundImage: NetworkImage(
                        pickedFile != null ? Url! : widget.imageAvatar),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.identifier,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    widget.followersQuantity.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Followers',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.followingQuantity.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Following',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.6,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: widget.isFollowing
                        ? MaterialStateProperty.all(Colors.black)
                        : MaterialStateProperty.all(Colors.indigo),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>( // nút được bo tròn 18.0
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: widget.followButtonFunction,
                  child: widget.isFollowing
                      ? const Text(
                    'Following',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20),
                  )
                      : const Text(
                    'Follow',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20),
                  ),
                ),
              ),

            ],
          ),
          const Divider(
            thickness: 1.5,
          ),
        ],
      );
    }
  }
}