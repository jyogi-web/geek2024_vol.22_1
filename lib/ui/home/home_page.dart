import 'package:flutter/material.dart';

// 画面遷移のためのWidget
import 'package:aicharamaker/ui/auth/view/auth_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CreateScreen(),
    TalkScreen(),
    FavoriteScreen(),
    AuthPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ホーム画面', style: TextStyle(fontSize: 24)));
  }
}

class CreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('クリエイト画面', style: TextStyle(fontSize: 24)));
  }
}

class TalkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('トーク画面', style: TextStyle(fontSize: 24)));
  }
}

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('お気に入り画面', style: TextStyle(fontSize: 24)));
  }
}

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ユーザー画面', style: TextStyle(fontSize: 24)));
  }
}
