import 'package:flutter/material.dart';

// 画面遷移のためのWidget
import 'package:aicharamaker/ui/chat/view/chat_page.dart';
import 'package:aicharamaker/ui/auth/view/auth_page.dart';
import 'package:aicharamaker/ui/create/view/create_page.dart';
import 'package:aicharamaker/ui/home/HomeScreen.dart';
import 'package:aicharamaker/ui/favorite/favorite_page.dart';
import 'package:aicharamaker/ui/user/user_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CreateScreen(),
    ChatPage(),
    FavoriteScreen(),
    UserScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ぷろふぃーるはぶ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // 検索機能の処理をここに追加
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
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
