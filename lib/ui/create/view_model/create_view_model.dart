import 'package:flutter/material.dart';
import 'package:aicharamaker/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CreateScreenViewModel extends ChangeNotifier {
  // 入力されるテキストを管理するコントローラー
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController personalityController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController hobbiesController = TextEditingController();
  final TextEditingController familyStructureController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController otherDetailsController = TextEditingController();
  final TextEditingController likesDislikesController = TextEditingController();
  final TextEditingController concernsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  /// 入力された内容から ProfileModel を生成し、ログ出力などを行う
  Future<void> submitProfile() async {
    final profileId = FirebaseFirestore.instance
        .collection('profiles')
        .doc()
        .id; // ドキュメントIDを自動生成
    final user = FirebaseAuth.instance.currentUser; // ログインユーザー情報を取得

    if (user == null) {
      // ログインしていない場合はエラーを出力して処理を中断
      debugPrint('User is not logged in');
      return;
    }

    final profile = ProfileModel(
      id: profileId,
      userId: user.uid,
      userName: user.displayName ?? 'No Name',
      name: nameController.text,
      // タグはスペース区切りでリスト化
      tag: tagController.text.split(' ').map((tag) => tag.trim()).toList(),
      description: descriptionController.text,
      imageUrl: imageUrlController.text,
      gender: genderController.text,
      personality: personalityController.text,
      height: heightController.text,
      bloodType: bloodTypeController.text,
      age: ageController.text,
      // 趣味もスペース区切りでリスト化
      hobbies: hobbiesController.text
          .split(' ')
          .map((hobby) => hobby.trim())
          .toList(),
      familyStructure: familyStructureController.text,
      birthDate: birthDateController.text,
      otherDetails: otherDetailsController.text,
      likesDislikes: likesDislikesController.text,
      concerns: concernsController.text,
      remarks: remarksController.text,
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // 送信内容の確認用ログ
    debugPrint('Profile Submitted: '
        'ID: ${profile.id}, '
        'UserID: ${profile.userId}, '
        'UserName: ${profile.userName}, '
        'Name: ${profile.name}, '
        'Tag: ${profile.tag}, '
        'Description: ${profile.description}, '
        'ImageUrl: ${profile.imageUrl}, '
        'Gender: ${profile.gender}, '
        'Personality: ${profile.personality}, '
        'Height: ${profile.height}, '
        'BloodType: ${profile.bloodType}, '
        'Age: ${profile.age}, '
        'Hobbies: ${profile.hobbies}, '
        'FamilyStructure: ${profile.familyStructure}, '
        'BirthDate: ${profile.birthDate}, '
        'OtherDetails: ${profile.otherDetails}, '
        'LikesDislikes: ${profile.likesDislikes}, '
        'Concerns: ${profile.concerns}, '
        'Remarks: ${profile.remarks}'
        'CreatedBy: ${profile.createdBy}, '
        'CreatedAt: ${profile.createdAt}, '
        'UpdatedAt: ${profile.updatedAt}');

    // ここで実際のデータ保存や画面遷移、API通信などの処理を行う
    // Firestore へのデータ保存
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(profileId)
        .set(profile.toJson());
    // Navigator による画面遷移
    navigatorKey.currentState?.pushReplacementNamed('/userScreen');
  }

  /// ViewModelを破棄するときにコントローラを解放
  @override
  void dispose() {
    nameController.dispose();
    tagController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    genderController.dispose();
    personalityController.dispose();
    heightController.dispose();
    bloodTypeController.dispose();
    ageController.dispose();
    hobbiesController.dispose();
    familyStructureController.dispose();
    birthDateController.dispose();
    otherDetailsController.dispose();
    likesDislikesController.dispose();
    concernsController.dispose();
    remarksController.dispose();
    super.dispose();
  }
}
