import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aicharamaker/ui/chat/view/chat_page.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String documentId;

  ProfileDetailScreen({required this.documentId});

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("ぷろふぃーる詳細", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('profiles').doc(widget.documentId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("プロフィールが見つかりません"));
          }

          var profile = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profile['imageUrl'] != null ? NetworkImage(profile['imageUrl']) : null,
                    child: profile['imageUrl'] == null ? Icon(Icons.person, size: 60, color: Colors.grey) : null,
                  ),
                  SizedBox(height: 16),
                  Text(profile['name'] ?? '名前なし', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(profile: profile),
                        ),
                      );
                    },
                    child: Text("このキャラでチャットする"),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
