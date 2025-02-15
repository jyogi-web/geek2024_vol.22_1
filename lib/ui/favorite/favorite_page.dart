import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/ProfileCard.dart'; // プロフィールカードのインポート

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("お気に入り一覧", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('profiles').where('isFavorite', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("お気に入りがありません"));
          }

          var favoriteProfiles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteProfiles.length,
            itemBuilder: (context, index) {
              var profile = favoriteProfiles[index].data() as Map<String, dynamic>;
              return ProfileCard(profile: profile, documentId: favoriteProfiles[index].id);
            },
          );
        },
      ),
    );
  }
}
