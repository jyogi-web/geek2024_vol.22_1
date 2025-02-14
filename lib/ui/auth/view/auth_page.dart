import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

// ViewModel, Model
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
                          const SizedBox(width: 8),
                          const Text('メールアドレスでログイン'),
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
                          const SizedBox(width: 8),
                          const Text('GitHubでログイン'),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          // GitHubログイン処理
                          // await authVM.signInWithGitHub();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          );
                        } catch (e) {
                          // エラー表示など行う
                          debugPrint('GitHubログインエラー: $e');
                        }
                      },
                    ),
                    // メールアドレスでアカウント登録
                    ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedMailAccount01,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          const SizedBox(width: 8),
                          const Text('メールアドレスでアカウント登録'),
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
                    // ログアウト
                    ElevatedButton(
                      child: const Text('ログアウト'),
                      onPressed: () async {
                        // ログアウト処理
                        // await authVM.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AuthPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20)
                  ]),
            ),
          ),
        ));
  }
}
