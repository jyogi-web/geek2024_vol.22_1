import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuthのインポート

import 'ProfileDetailScreen.dart';

class ProfileCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String documentId;

  ProfileCard({required this.profile, required this.documentId});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  // ユーザーがこのプロフィールをお気に入りにしているか確認する
  void _checkFavoriteStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Firestoreの`likedProfiles`コレクションにプロフィールがあるか確認
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

  // お気に入りを切り替える
  void _toggleFavorite(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("ログインしてください")));
      return;
    }

    if (isFavorite) {
      // お気に入り解除
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('likedProfiles')
          .doc(widget.documentId)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("お気に入りを解除しました")));
    } else {
      // お気に入り追加
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('likedProfiles')
          .doc(widget.documentId)
          .set({'isFavorite': true});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("お気に入りに追加しました")));
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileDetailScreen(documentId: widget.documentId),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: widget.profile['imageUrl'] != null
                ? NetworkImage(widget.profile['imageUrl'])
                : null,
            child:
                widget.profile['imageUrl'] == null ? Icon(Icons.person) : null,
          ),
          title: Text(widget.profile['name'] ?? '名前なし'),
          subtitle: Row(
            children: [
              if (widget.profile['tag'] != null)
                ...widget.profile['tag']
                    .map<Widget>((tag) => _buildTag(tag))
                    .toList(),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () => _toggleFavorite(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(tag) {
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
