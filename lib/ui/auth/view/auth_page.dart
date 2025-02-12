// 遷移先
import 'package:aicharamaker/ui/auth/view/email_login_page.dart';
import 'package:aicharamaker/ui/auth/view/email_sign_up_page.dart';
import 'package:aicharamaker/ui/auth/view/github_login_page.dart';
import 'package:aicharamaker/ui/home/home_page.dart';

// 標準
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // ログイン・サインインの選択画面
  GithubAuthProvider githubProvider = GithubAuthProvider();

  Future _signInWithGitHub() async {
    await FirebaseAuth.instance.signInWithPopup(githubProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン・サインアップ'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレスでログイン
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedMailAccount01,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    SizedBox(width: 8),
                    Text('メールアドレスでログイン'),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailLoginPage()));
                },
              ),
              // GitHubでログイン
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedGithub01,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    SizedBox(width: 8),
                    Text('GitHubでログイン'),
                  ],
                ),
                onPressed: () async {
                  try {
                    await _signInWithGitHub();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return MainScreen();
                        },
                      ),
                    );
                  } catch (e) {
                    print('エラーです');
                  }
                },
              ),
              // メールアドレスでログイン
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedMailAccount01,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    SizedBox(width: 8),
                    Text('メールアドレスでアカウント登録'),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailSignUpPage()));
                },
              ),
              // ログアウト
              ElevatedButton(
                child: const Text('ログアウト'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  print('ログアウトしました');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailLoginPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
