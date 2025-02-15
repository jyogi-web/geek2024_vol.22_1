import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String documentId;

  ProfileDetailScreen({required this.documentId});

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  bool isFavorite = false;
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Firestore からプロフィールデータを取得
  void _fetchProfileData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('profiles').doc(widget.documentId).get();
    if (doc.exists) {
      setState(() {
        profile = doc.data() as Map<String, dynamic>?;
        isFavorite = profile?['isFavorite'] ?? false;
      });
    }
  }

  // お気に入りを切り替える
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    FirebaseFirestore.instance.collection('profiles').doc(widget.documentId).update({
      'isFavorite': isFavorite,
    });
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
        title: Text("ぷろふぃーる画面"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
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
                child: Text("一覧画面"),
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
