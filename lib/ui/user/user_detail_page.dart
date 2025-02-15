import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/model/user_model.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final UserModel? user = authViewModel.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー詳細'),
        // 自動で戻るボタンを表示
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: user != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    // ユーザーのアバター
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            (user.photoURL != null && user.photoURL!.isNotEmpty)
                                ? NetworkImage(user.photoURL!)
                                : null,
                        child: (user.photoURL == null || user.photoURL!.isEmpty)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ユーザー名とキャラ愛Lv.
                    Center(
                      child: Column(
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid!)
                                .collection('createdProfiles')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('エラーが発生しました');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('読み込み中...');
                              }
                              final docs = snapshot.data?.docs ?? [];
                              final playerLevel = docs.length;
                              return Text(
                                'キャラ愛Lv.$playerLevel',
                                style: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // 内側の ListView を shrinkWrap と NeverScrollableScrollPhysics で修正
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: const Text('Email'),
                          subtitle: Text(user.email ?? 'No email provided'),
                        ),
                        ListTile(
                          title: const Text('UID'),
                          subtitle: Text(user.uid ?? 'No uid'),
                        ),
                      ],
                    ),
                  ],
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
