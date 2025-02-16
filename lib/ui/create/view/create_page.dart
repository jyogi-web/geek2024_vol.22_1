import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/ui/create/view_model/create_view_model.dart';
import 'package:aicharamaker/ui/auth/view/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateScreen extends StatelessWidget {
  final String? profileId; // 編集時に渡されるプロフィールID
  final Map<String, dynamic>? initialProfileData; // 初期データ

  CreateScreen({Key? key, this.profileId, this.initialProfileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = CreateScreenViewModel();
        
        // 編集モードなら初期値をセット
        if (initialProfileData != null) {
          viewModel.nameController.text = initialProfileData!['name'] ?? '';
          viewModel.descriptionController.text = initialProfileData!['description'] ?? '';
          viewModel.imageUrlController.text = initialProfileData!['imageUrl'] ?? '';
          viewModel.tagController.text = (initialProfileData!['tag'] as List<dynamic>).join(' ');
          viewModel.genderController.text = initialProfileData!['gender'] ?? '';
          viewModel.personalityController.text = initialProfileData!['personality'] ?? '';
          viewModel.heightController.text = initialProfileData!['height'] ?? '';
          viewModel.bloodTypeController.text = initialProfileData!['bloodType'] ?? '';
          viewModel.ageController.text = initialProfileData!['age'] ?? '';
          viewModel.hobbiesController.text = (initialProfileData!['hobbies'] as List<dynamic>).join(' ');
          viewModel.familyStructureController.text = initialProfileData!['familyStructure'] ?? '';
          viewModel.birthDateController.text = initialProfileData!['birthDate'] ?? '';
          viewModel.otherDetailsController.text = initialProfileData!['otherDetails'] ?? '';
          viewModel.likesDislikesController.text = initialProfileData!['likesDislikes'] ?? '';
          viewModel.concernsController.text = initialProfileData!['concerns'] ?? '';
          viewModel.remarksController.text = initialProfileData!['remarks'] ?? '';
        }

        return viewModel;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(profileId != null ? "キャラ編集" : "キャラ作成"), // 編集ならタイトル変更
        ),
        body: Consumer<CreateScreenViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: viewModel.nameController,
                    decoration: InputDecoration(
                      labelText: "名前",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.tagController,
                    decoration: InputDecoration(
                      labelText: "タグ (半角スペース区切り)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.descriptionController,
                    decoration: InputDecoration(
                      labelText: "説明",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.imageUrlController,
                    decoration: InputDecoration(
                      labelText: "画像URL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(viewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                    ),
                    child: const Text('ファイルを選択'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.genderController,
                    decoration: InputDecoration(
                      labelText: "性別",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.personalityController,
                    decoration: InputDecoration(
                      labelText: "性格",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "身長",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.bloodTypeController,
                    decoration: InputDecoration(
                      labelText: "血液型",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "年齢",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.hobbiesController,
                    decoration: InputDecoration(
                      labelText: "趣味 (半角スペース区切り)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.familyStructureController,
                    decoration: InputDecoration(
                      labelText: "家族構成",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.birthDateController,
                    decoration: InputDecoration(
                      labelText: "誕生日 (YYYY-MM-DD)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.otherDetailsController,
                    decoration: InputDecoration(
                      labelText: "その他(話し方など)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.likesDislikesController,
                    decoration: InputDecoration(
                      labelText: "好き/嫌い",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.concernsController,
                    decoration: InputDecoration(
                      labelText: "悩み",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.remarksController,
                    decoration: InputDecoration(
                      labelText: "備考",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.submitProfile(context); // contextを渡す
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                      child: const Text("決定！"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}