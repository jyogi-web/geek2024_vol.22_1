import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileCard.dart';
import 'package:aicharamaker/ui/favorite/favorite_page.dart'; // お気に入り画面のインポート

class ProfileListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ぷろふぃーる一覧", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
              return ProfileCard(profile: profile, documentId: profiles[index].id);
            },
          );
        },
      ),
    );
  }
}
