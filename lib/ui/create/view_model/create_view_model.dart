import 'package:flutter/material.dart';
import 'package:aicharamaker/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aicharamaker/ui/home/home_page.dart';
import 'package:aicharamaker/ui/auth/view/auth_page.dart';

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

  /// 入力された内容から ProfileModel を生成し、Firestore に保存してポップアップを表示
  Future<void> submitProfile(BuildContext context) async {
    final profileId =
        FirebaseFirestore.instance.collection('profiles').doc().id;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('User is not logged in');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        ),
      );
      return;
    }

    final profile = ProfileModel(
      id: profileId,
      userId: user.uid,
      userName: user.displayName ?? 'No Name',
      name: nameController.text,
      tag: tagController.text.split(' ').map((tag) => tag.trim()).toList(),
      description: descriptionController.text,
      imageUrl: imageUrlController.text,
      gender: genderController.text,
      personality: personalityController.text,
      height: heightController.text,
      bloodType: bloodTypeController.text,
      age: ageController.text,
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
      createdBy: user.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Firestore へのデータ保存
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(profileId)
        .set(profile.toJson());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('createdProfiles')
        .doc(profileId)
        .set(profile.toJson());

    showDialog(
      context: context, // 受け取ったcontextを使う
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('保存成功'),
          content: const Text('プロフィールが保存されました。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ダイアログを閉じる
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
