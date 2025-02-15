import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Providerパッケージ

import 'package:aicharamaker/ui/home/home_page.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';
import '../../components/background_animation.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({Key? key}) : super(key: key);

  @override
  _EmailLoginPage createState() => _EmailLoginPage();
}

class _EmailLoginPage extends State<EmailLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// メールアドレス＆パスワードでログイン
  Future<void> _login() async {
    final authVM = context.read<AuthViewModel>(); // ViewModel取得

    try {
      await authVM.signInWithEmail(
        emailController.text,
        passwordController.text,
      );
      // ログイン成功
      if (authVM.currentUser != null) {
        print("ログイン成功: ${authVM.currentUser!.toJson()}");

        // テキストフィールドクリア
        emailController.clear();
        passwordController.clear();

        // メイン画面に遷移
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'メールアドレスまたはパスワードが間違っています';
      });
      print(e);
    } catch (e) {
      setState(() {
        errorMessage = '予期せぬエラーが発生しました';
      });
      print(e);
    }
  }

  /// テストログイン用
  Future<void> _testLogin() async {
    // テストユーザのメールアドレスとパスワード
    final testEmail = 'test@test.com';
    final testPassword = 'password';

    emailController.text = testEmail;
    passwordController.text = testPassword;

    await _login(); // 上記の _login() を使い回し
  }

  /// パスワードリセット
  Future<void> _resetPassword() async {
    final authVM = context.read<AuthViewModel>();

    try {
      await authVM.resetPassword(emailController.text);
      // 必要に応じてユーザーに完了メッセージを表示
      print("${emailController.text} へパスワードリセットメールを送信しました");
    } on FirebaseAuthException catch (e) {
      print('パスワードリセット失敗: $e');
    } catch (e) {
      print('不明なエラーです: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAnimation1(
        size: MediaQuery.of(context).size,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.mail),
                    hintText: 'example@email.com',
                    labelText: 'Email Address',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('ログイン'),
                  onPressed: _login,
                ),
                ElevatedButton(
                  child: const Text('テストログイン'),
                  onPressed: _testLogin,
                ),
                ElevatedButton(
                  onPressed: _resetPassword,
                  child: const Text('パスワードリセット'),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
