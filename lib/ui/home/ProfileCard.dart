import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCard extends StatelessWidget {
  final QueryDocumentSnapshot profile;

  ProfileCard({required this.profile});

  void _toggleFavorite() {
    bool isFavorite = profile["isFavorite"] ?? false;
    FirebaseFirestore.instance.collection('profiles').doc(profile.id).update({
      "isFavorite": !isFavorite,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: profile["imageUrl"] != null
              ? NetworkImage(profile["imageUrl"])
              : null,
          child: profile["imageUrl"] == null ? Icon(Icons.person) : null,
        ),
        title: Text(profile["name"] ?? "名前なし"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile["personality"] != null)
              Text(profile["personality"], style: TextStyle(fontSize: 14)),
            if (profile["description"] != null)
              Text(profile["description"], style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            profile["isFavorite"] == true ? Icons.favorite : Icons.favorite_border,
            color: profile["isFavorite"] == true ? Colors.red : null,
          ),
          onPressed: _toggleFavorite,
        ),
      ),
    );
  }
}
