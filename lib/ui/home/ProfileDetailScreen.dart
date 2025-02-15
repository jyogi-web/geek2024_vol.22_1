import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aicharamaker/ui/chat/view/chat_page.dart';
import 'package:aicharamaker/ui/image_create/image_generator_page.dart';

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
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text(
          "ぷろふぃーる詳細",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('profiles')
            .doc(widget.documentId)
            .snapshots(),
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
                  // プロフィール画像
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profile['imageUrl'] != null
                        ? NetworkImage(profile['imageUrl'])
                        : null,
                    child: profile['imageUrl'] == null
                        ? Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  SizedBox(height: 16),

                  // 名前
                  Text(
                    profile['name'] ?? '名前なし',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 8),

                  // タグ
                  Wrap(
                    spacing: 8,
                    children: [
                      if (profile['tag1'] != null) _buildTag(profile['tag1']),
                      if (profile['tag2'] != null) _buildTag(profile['tag2']),
                    ],
                  ),
                  SizedBox(height: 16),

                  // プロフィール情報
                  _buildProfileSection("基本情報", [
                    _buildProfileRow("タグ", profile['tag']),
                    _buildProfileRow("説明", profile['description']),
                    _buildProfileRow("性別", profile['gender']),
                    _buildProfileRow("誕生日", profile['birthDate']),
                    _buildProfileRow("年齢", profile['age']),
                    _buildProfileRow("血液型", profile['bloodType']),
                    _buildProfileRow("身長", profile['height']),
                    _buildProfileRow("性格", profile['personality']),
                  ]),

                  _buildProfileSection("趣味・好み", [
                    _buildProfileRow("趣味", profile['hobbies']),
                    _buildProfileRow("好き / 嫌い", profile['likesDislikes']),
                  ]),

                  _buildProfileSection("その他の情報", [
                    _buildProfileRow("家族構成", profile['familyStructure']),
                    _buildProfileRow("悩み", profile['remarks']),
                    _buildProfileRow("その他（話し方など）", profile['otherDetails']),
                  ]),

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
                  ElevatedButton(
                    onPressed: () {
                      // タップ時に選択したプロフィール情報をもとに画像生成画面へ遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageGeneratorPage(
                            profile: profile,
                            doc_id: widget.documentId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text("このプロフィールで画像をAI生成",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  // 一覧画面に戻るボタン
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text("一覧画面へ戻る",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  // 一覧画面に戻るボタン
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  // プロフィール情報の表示用
// プロフィール情報の表示用
  Widget _buildProfileSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }


      
  // プロフィールの項目を整える
  Widget _buildProfileRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$label: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value != null ? value.toString() : '不明',
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // タグ表示用
  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tag,
          style: TextStyle(fontSize: 14, color: Colors.blue.shade900)),
    );
  }
}
