import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/model/user_model.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';
import 'package:aicharamaker/ui/auth/view/auth_page.dart';
import 'package:aicharamaker/ui/user/user_proflile_page.dart';
import 'package:aicharamaker/ui/favorite/favorite_page.dart';
import 'package:aicharamaker/ui/home/ProfileListScreen.dart';
import 'package:aicharamaker/ui/user/user_create_list_page.dart';
import 'package:aicharamaker/ui/user/user_detail_page.dart';
import 'package:aicharamaker/ui/image_create/profile_to_image_page.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final UserModel? user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1BEE7), Color(0xFFF8BBD0)], // 薄い紫から薄いピンク
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: user != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 24),
                      // 丸いアイコン（アバター）
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: (user.photoURL != null &&
                                  user.photoURL!.isNotEmpty)
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: (user.photoURL == null ||
                                  user.photoURL!.isEmpty)
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ユーザー名 & キャラ愛Lv.
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
                            // StreamBuilderを使ってドキュメント数を表示
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
                      // ボタン一覧
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDetailScreen()),
                          );
                        },
                        child: const Text('ユーザー情報'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserCreateListScreen()),
                          );
                        },
                        child: const Text('作成したぷろふぃーる一覧'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoriteScreen()),
                          );
                        },
                        child: const Text('いいねしたぷろふぃーる一覧'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateProfileListScreen()),
                          );
                        },
                        child: Text("画像生成"),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          // ログアウト処理
                          authViewModel.signOut();
                        },
                        child: const Text('ログアウト'),
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('ログイン画面へ'),
                      ),
                    ],
               ),
            ),
        ),
      ),
    );
  }
}