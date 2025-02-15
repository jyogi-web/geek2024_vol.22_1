import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('likedProfiles')
            .snapshots(),  // likedProfilesを参照
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("お気に入りのプロフィールはありません"));
          }

          var likedProfiles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: likedProfiles.length,
            itemBuilder: (context, index) {
              var profileId = likedProfiles[index].id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('profiles').doc(profileId).get(),
                builder: (context, profileSnapshot) {
                  if (profileSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!profileSnapshot.hasData || !profileSnapshot.data!.exists) {
                    return SizedBox.shrink(); // プロフィールが存在しない場合、何も表示しない
                  }

                  var profile = profileSnapshot.data!.data() as Map<String, dynamic>;
                  return ProfileCard(profile: profile, documentId: profileId);
                },
              );
            },
          );
        },
      ),
    );
  }
}
