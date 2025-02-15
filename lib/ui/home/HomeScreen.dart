import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aicharamaker/ui/home/ProfileListScreen.dart'; // 一覧画面用

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("新着ぷろふぃーる", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .orderBy('createdAt', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("新着プロフィールがありません"));
                }

                var profiles = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    var profile = profiles[index].data() as Map<String, dynamic>;
                    return ProfileCard(profile: profile);
                  },
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileListScreen()),
                );
              },
              child: Text("一覧画面"),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: profile['imageUrl'] != null
              ? NetworkImage(profile['imageUrl'])
              : null,
          child: profile['imageUrl'] == null ? Icon(Icons.person) : null,
        ),
        title: Text(profile['name'] ?? '名前なし'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile['remarks'] != null)
              Text(profile['remarks'], style: TextStyle(fontSize: 14)),
            if (profile['description'] != null)
              Text(profile['description'], style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        trailing: Icon(Icons.favorite_border),
      ),
    );
  }
}
