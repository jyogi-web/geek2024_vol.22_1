import 'package:flutter/material.dart';
import 'package:aicharamaker/model/profile_model.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
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

  void _submitProfile() {
    // ProfileModel に入力内容を詰め込む
    final profile = ProfileModel(
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
    );

    // 送信内容の確認用ログ
    print('Profile Submitted: '
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
        'Remarks: ${profile.remarks}');

    // ここで実際の保存処理や画面遷移などを行う
  }

  @override
  Widget build(BuildContext context) {
    // スクロール可能にするために SingleChildScrollView でラップ
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "名前",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: tagController,
            decoration: const InputDecoration(
              labelText: "タグ (半角スペース区切り)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: "説明",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(
              labelText: "画像 URL",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: genderController,
            decoration: const InputDecoration(
              labelText: "性別",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: personalityController,
            decoration: const InputDecoration(
              labelText: "性格",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "身長",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: bloodTypeController,
            decoration: const InputDecoration(
              labelText: "血液型",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "年齢",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: hobbiesController,
            decoration: const InputDecoration(
              labelText: "趣味 (半角スペース区切り)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: familyStructureController,
            decoration: const InputDecoration(
              labelText: "家族構成",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: birthDateController,
            decoration: const InputDecoration(
              labelText: "誕生日 (YYYY-MM-DD)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: otherDetailsController,
            decoration: const InputDecoration(
              labelText: "その他　話し方など",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: likesDislikesController,
            decoration: const InputDecoration(
              labelText: "好き/嫌い",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: concernsController,
            decoration: const InputDecoration(
              labelText: "悩み",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: remarksController,
            decoration: const InputDecoration(
              labelText: "備考",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text("決定！"),
          ),
        ],
      ),
    );
  }
}
