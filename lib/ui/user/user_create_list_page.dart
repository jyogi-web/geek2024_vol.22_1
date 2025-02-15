// user_create_list_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aicharamaker/ui/favorite/favorite_page.dart'; // お気に入り画面のインポート

class UserCreateListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("つくったぷろふぃーる一覧", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!userSnapshot.hasData) {
            return Center(child: Text("ログインしてください"));
          }

          User? user = userSnapshot.data;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .where('userId', isEqualTo: user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("プロフィールがありません"));
              }

              var profiles = snapshot.data!.docs;

              return ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  var profile = profiles[index].data() as Map<String, dynamic>;
                  var documentId = profiles[index].id;

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(profile['name'] ?? '名前なし'),
                      subtitle: Text(profile['description'] ?? '説明なし'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProfile(context, documentId),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // プロフィール削除の処理
  Future<void> _deleteProfile(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('profiles').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('プロフィールが削除されました')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('削除に失敗しました')));
    }
  }
}
