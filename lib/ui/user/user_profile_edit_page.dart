import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/model/user_model.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aicharamaker/ui/create/view_model/create_view_model.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({Key? key}) : super(key: key);

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _photoURLController;

  @override
  void initState() {
    super.initState();
    // Providerから現在のユーザー情報を取得
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final UserModel? user = authViewModel.currentUser;

    _nameController = TextEditingController(text: user?.name ?? '');
    _photoURLController = TextEditingController(text: user?.photoURL ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _photoURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final UserModel? user = authViewModel.currentUser;
    String? _fileName;

    Future<void> _pickImage(TextEditingController _photoURLController) async {
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
        _photoURLController.text = downloadUrl;
        print('Download URL: $downloadUrl');
      });
      // print('file: $file');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
      ),
      body: SafeArea(
        child: user != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: (_photoURLController.text.isNotEmpty)
                              ? NetworkImage(_photoURLController.text)
                              : null,
                          child: (_photoURLController.text.isEmpty)
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '名前',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '名前を入力してください';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _photoURLController,
                        decoration: const InputDecoration(
                          labelText: "画像URL",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _pickImage(_photoURLController),
                        child: Text('ファイルを選択'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final newName = _nameController.text.trim();
                            final newPhotoURL = _photoURLController.text.trim();
                            try {
                              await authViewModel.updateUserProfile(
                                name: newName,
                                photoURL: newPhotoURL,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('プロフィールを更新しました')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('更新に失敗しました: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('更新する'),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('ユーザーがログインしていません'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('ログイン画面へ'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
