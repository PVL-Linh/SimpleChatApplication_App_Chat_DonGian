import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweet_app/src/core/repositories/cloud_storage_repository_firebase.dart';
import 'package:tweet_app/src/core/repositories/user_repository_firestore.dart';
import 'package:tweet_app/src/features/tweet/models/user_request_model.dart';

class GetUserInformationService {
  final UserRepositoryFirestore userRepository;
  final CloudStorageRepositoryFirebase storageRepository;
  GetUserInformationService(
      {required this.userRepository, required this.storageRepository});

  Future<Map<String, dynamic>> _getUserAsMap({required String uidAuth}) async {
    DocumentSnapshot userSnapshot =
        await userRepository.readUser(uidAuth: uidAuth);
    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Error in getUser because document dont exists.');
    }
  }

  Future<UserRequestModel> getUserWithNetworkImage({
    required String uidAuth,
    bool isOnlyProfilePicture = false,
  }) async {
    Map<String, dynamic> userMap = await _getUserAsMap(uidAuth: uidAuth);

    UserRequestModel userRequest = UserRequestModel.fromMap(userMap);

    String iconPhotoUrl =
        await storageRepository.getImageUrl(storagePath: userRequest.iconPhoto);

    if (!isOnlyProfilePicture) {
      String bannerPhotoUrl = await storageRepository.getImageUrl(
          storagePath: userRequest.bannerPhoto);

      userRequest = userRequest.copyWith(
          iconPhoto: iconPhotoUrl, bannerPhoto: bannerPhotoUrl);
    } else {
      userRequest = userRequest.copyWith(iconPhoto: iconPhotoUrl);
    }
    return userRequest;
  }
}
