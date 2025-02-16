import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aicharamaker/ui/home/ProfileCard.dart'; // プロフィールカードのインポート
import 'package:aicharamaker/ui/image_create/image_generator_page.dart'; // 画像生成画面のインポート
import 'package:aicharamaker/ui/favorite/favorite_page.dart';

class CreateProfileListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "画像を作るぷろふぃーる一覧",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
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
              return GestureDetector(
                onTap: () {
                  // タップ時に選択したプロフィール情報をもとに画像生成画面へ遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageGeneratorPage(
                        profile: profile,
                        doc_id: profiles[index].id,
                      ),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: ProfileCard(
                    profile: profile,
                    documentId: profiles[index].id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
