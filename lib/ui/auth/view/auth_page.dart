import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

// ViewModel, Model
import 'package:aicharamaker/model/user_model.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';
import 'email_login_page.dart';
import 'email_sign_up_page.dart';
import 'package:aicharamaker/ui/home/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider で AuthViewModel を提供
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン・サインアップ'),
        ),
        body: Consumer<AuthViewModel>(
          builder: (context, authVM, child) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Containerでラップしてmarginをつけて余白を作成した
                    Container(
                      width: 300,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                      child: 
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedMailAccount01,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Center(
                          child: const Text('メールアドレスでログイン',
                          style: TextStyle(color: Colors.black),
                            ),
                          ),
                         ),
                        ],
                       ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLoginPage()),
                        );
                      },
                    ),
                    ),
                    // メールアドレスでログイン
                    
                    // GitHubでログイン
                    Container(
                      width: 300,
                      margin: EdgeInsets.all(10),
                      child:  ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedGithub01,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                          child: Center(
                          child: const Text('GitHubでログイン',
                          style: TextStyle(color: Colors.black),
                            ),
                           ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          await authVM.signInWithGitHub();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          );
                        } catch (e) {
                          // エラー表示など行う
                          debugPrint('GitHubログインエラー: $e');
                        }
                      },
                    ),
                    ),

                    // メールアドレスでアカウント登録
                    Container(
                      width: 300,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedMailAccount01,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                          child: Center(
                          child: const Text('メールアドレスでアカウント登録',
                          style: TextStyle(color: Colors.black),
                            ),
                           ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailSignUpPage()),
                        );
                      },
                    ),
                    ),
                    // ログアウト
                    Container(
                      width: 300,
                      margin: EdgeInsets.all(10),
                      child:ElevatedButton(
                      child: const Text('ログアウト',
                      style: TextStyle(color: Colors.black),
                    ),
                      onPressed: () async {
                        await authVM.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AuthPage()),
                        );
                      },
                    ),
                    ),

                    const SizedBox(height: 20),
                    // ログインユーザ情報を表示する例
                    if (authVM.currentUser != null) ...[
                      Text('ログイン中ユーザ:'),
                      Text('UID: ${authVM.currentUser?.uid}'),
                      Text('Name: ${authVM.currentUser?.name}'),
                      Text('Email: ${authVM.currentUser?.email}'),
                    ] else ...[
                      const Text('未ログインです。'),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
