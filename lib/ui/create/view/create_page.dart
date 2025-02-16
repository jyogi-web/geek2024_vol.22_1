import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/ui/create/view_model/create_view_model.dart';
import 'package:aicharamaker/ui/auth/view/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateScreen extends StatelessWidget {
  CreateScreen({Key? key}) : super(key: key);
  String? _fileName;

  // ユーザーがログインしているかどうかを判定するメソッド
  bool _isUserLoggedIn(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('user: $user');
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _pickImage(CreateScreenViewModel viewModel) async {
    // 画像をfirebase storageにアップロードする処理
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) {
      return;
    }
    final file = result.files.single;

    _fileName = file.name;
    final storageRef =
        FirebaseStorage.instance.ref().child('uploads/${file.name}');
    final metadata = SettableMetadata(
      contentType: 'image/png',
    );
    final uploadTask = storageRef.putData(file.bytes!, metadata);

    await uploadTask.whenComplete(() async {
      final downloadUrl = await storageRef.getDownloadURL();
      viewModel.imageUrlController.text = downloadUrl;
      print('Download URL: $downloadUrl');
    });
    // print('file: $file');
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _isUserLoggedIn(context);
    print('isLoggedIn: $isLoggedIn');
    // ログインしていない場合、AuthPage()への遷移ボタンのみを表示
    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("キャラ作成"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthPage()),
              );
            },
            child: const Text("ログインして作成する"),
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => CreateScreenViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("キャラ作成"),
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