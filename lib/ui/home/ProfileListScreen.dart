import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileDetailScreen.dart'; // 詳細画面をインポート

class ProfileListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ぷろふぃーる一覧",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black),
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

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final String documentId;

  ProfileCard({required this.profile, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDetailScreen(documentId: documentId),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: profile['imageUrl'] != null
                ? NetworkImage(profile['imageUrl'])
                : null,
            child: profile['imageUrl'] == null ? Icon(Icons.person) : null,
          ),
          title: Text(profile['name'] ?? '名前なし'),
          subtitle: Row(
            children: [
              if (profile['tag1'] != null) _buildTag(profile['tag1']),
              if (profile['tag2'] != null) _buildTag(profile['tag2']),
            ],
          ),
          trailing: Icon(Icons.favorite_border),
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(tag, style: TextStyle(fontSize: 12)),
    );
  }
}
