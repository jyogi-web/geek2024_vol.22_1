import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileDetailScreen.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final String documentId;

  ProfileCard({required this.profile, required this.documentId});

  void _toggleFavorite() {
    bool isFavorite = profile['isFavorite'] ?? false;
    FirebaseFirestore.instance.collection('profiles').doc(documentId).update({
      'isFavorite': !isFavorite,
    });
  }

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
              if (profile['tag'] != null)
                ...profile['tag'].map<Widget>((tag) => _buildTag(tag)).toList(),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              profile['isFavorite'] == true
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: profile['isFavorite'] == true ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
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
