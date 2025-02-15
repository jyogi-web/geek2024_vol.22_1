import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aicharamaker/ui/chat/view/chat_page.dart';
import 'package:aicharamaker/ui/home/HomeScreen.dart';
import 'package:aicharamaker/ui/create/view/create_page.dart';
import 'package:aicharamaker/ui/favorite/favorite_page.dart';
import 'package:aicharamaker/ui/user/user_page.dart';
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
    _fetchFavoriteProfile(); // お気に入りのキャラを取得
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

// 各画面のWidget（仮のUIを表示）
// これを各ページのファイルに分離して作成

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ユーザー画面', style: TextStyle(fontSize: 24)));
  }
}

// 検索機能のカスタムデリゲートを定義
class CustomSearchDelegate extends SearchDelegate {
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
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 検索結果を表示するウィジェットをここに追加
    return Center(
      child: Text('検索結果: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 検索候補を表示するウィジェットをここに追加
    return Center(
      child: Text('検索候補: $query'),
    );
  }
}
