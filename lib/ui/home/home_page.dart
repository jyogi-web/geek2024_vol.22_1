import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth をインポート

// 画面遷移のためのWidget

import 'package:aicharamaker/ui/chat/view/chat_page.dart';
import 'package:aicharamaker/ui/home/HomeScreen.dart';
import 'package:aicharamaker/ui/create/view/create_page.dart';
import 'package:aicharamaker/ui/favorite/favorite_page.dart';

import 'package:aicharamaker/ui/home/ProfileCard.dart'; // プロフィールカードのインポート
import 'package:aicharamaker/ui/home/ProfileDetailScreen.dart'; // プロフィール詳細画面

import 'package:aicharamaker/ui/auth/view/auth_page.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteProfile();  // お気に入りのキャラを取得
  }

  void _fetchFavoriteProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('likedProfiles')
        .limit(1) // 最初のお気に入りを取得
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _selectedProfile = snapshot.docs.first.data();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(),
      CreateScreen(),
      _selectedProfile != null
          ? ChatPage(profile: _selectedProfile!)
          : Center(child: Text("お気に入りのキャラがありません")),
      FavoriteScreen(),
      AuthPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("ぷろふぃーるはぶ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          
        ]
        titleTextStyle: TextStyle(color: Colors.black),

      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.create), label: 'クリエイト'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'トーク'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ユーザー'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Firestore を使った検索機能のカスタムデリゲート
class ProfileSearchDelegate extends SearchDelegate {
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  final String? userId = FirebaseAuth.instance.currentUser?.uid; // ログインユーザーの ID を取得

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  
  @override
  Widget buildResults(BuildContext context) {
    if (userId == null) {
      return Center(child: Text("ログインしてください"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('profiles')
          .where('userId', isEqualTo: userId) // ログインユーザーの ID でフィルタリング
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("該当するプロフィールがありません"));
        }

        var profiles = snapshot.data!.docs;

        return ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            var profileData = profiles[index].data() as Map<String, dynamic>;
            return ProfileCard(profile: profileData, documentId: profiles[index].id);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (userId == null) {
      return Center(child: Text("ログインしてください"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('profiles')
          .where('userId', isEqualTo: userId) // ログインユーザーの ID でフィルタリング
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("検索候補がありません"));
        }

        var profiles = snapshot.data!.docs;

        return ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            var profileData = profiles[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(profileData['name'] ?? '名前なし'),
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailScreen(documentId: profiles[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
