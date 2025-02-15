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
    final uploadTask = storageRef.putData(file.bytes!);

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
                children: [
                  TextField(
                    controller: viewModel.nameController,
                    decoration: const InputDecoration(
                      labelText: "名前",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.tagController,
                    decoration: const InputDecoration(
                      labelText: "タグ (半角スペース区切り)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.descriptionController,
                    decoration: const InputDecoration(
                      labelText: "説明",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.imageUrlController,
                    decoration: const InputDecoration(
                      labelText: "画像URL",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(viewModel),
                    child: Text('ファイルを選択'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: viewModel.genderController,
                    decoration: const InputDecoration(
                      labelText: "性別",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.personalityController,
                    decoration: const InputDecoration(
                      labelText: "性格",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "身長",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.bloodTypeController,
                    decoration: const InputDecoration(
                      labelText: "血液型",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "年齢",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.hobbiesController,
                    decoration: const InputDecoration(
                      labelText: "趣味 (半角スペース区切り)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.familyStructureController,
                    decoration: const InputDecoration(
                      labelText: "家族構成",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.birthDateController,
                    decoration: const InputDecoration(
                      labelText: "誕生日 (YYYY-MM-DD)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.otherDetailsController,
                    decoration: const InputDecoration(
                      labelText: "その他(話し方など)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.likesDislikesController,
                    decoration: const InputDecoration(
                      labelText: "好き/嫌い",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.concernsController,
                    decoration: const InputDecoration(
                      labelText: "悩み",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.remarksController,
                    decoration: const InputDecoration(
                      labelText: "備考",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.submitProfile(context); // contextを渡す
                    },
                    child: const Text("決定！"),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
