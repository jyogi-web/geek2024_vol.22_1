import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String documentId;

  ProfileDetailScreen({required this.documentId});

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  Map<String, dynamic>? profile;
  bool isFavorite = false; // isFavoriteは不要でしたが、お気に入りの状態を管理するために利用します

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Firestoreからプロフィールデータを取得
  void _fetchProfileData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('profiles').doc(widget.documentId).get();
      if (doc.exists) {
        setState(() {
          profile = doc.data() as Map<String, dynamic>?;
          _checkUserFavoriteStatus();
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  // ユーザーのお気に入り状態を確認
  void _checkUserFavoriteStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // ユーザーの`likedProfiles`コレクションからプロフィールが存在するかチェック
      DocumentSnapshot likedProfileDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('likedProfiles')
          .doc(widget.documentId)
          .get();

      setState(() {
        isFavorite = likedProfileDoc.exists;
      });
    }
  }

  // お気に入りを切り替える
  void _toggleFavorite() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ログインしてください")));
      return;
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    // Firestoreで`likedProfiles`におけるプロフィールの追加・削除
    if (isFavorite) {
      // お気に入り追加
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid)
          .collection('likedProfiles').doc(widget.documentId)
          .set({'isFavorite': true}, SetOptions(merge: true));
    } else {
      // お気に入り削除
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid)
          .collection('likedProfiles').doc(widget.documentId)
          .delete();
    }

    // UIに反映
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isFavorite ? "お気に入りに追加しました" : "お気に入りを解除しました")));
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("プロフィール詳細"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィール詳細"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profile?['imageUrl'] != null ? NetworkImage(profile!['imageUrl']) : null,
                child: profile?['imageUrl'] == null ? Icon(Icons.person, size: 50) : null,
              ),
            ),
            SizedBox(height: 16),
            Text("名前: ${profile?['name'] ?? '名前なし'}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                if (profile?['tag1'] != null) _buildTag(profile!['tag1']),
                if (profile?['tag2'] != null) _buildTag(profile!['tag2']),
              ],
            ),
            SizedBox(height: 8),
            Text("説明: ${profile?['description'] ?? 'なし'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("性別: ${profile?['gender'] ?? '不明'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("生年月日: ${profile?['birthDate'] ?? '?'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("趣味: ${profile?['hobbies'] ?? 'なし'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("一覧画面に戻る"),
              ),
            ),
          ],
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
