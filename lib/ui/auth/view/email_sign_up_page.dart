import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';
import 'package:aicharamaker/ui/auth/view/email_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/background_animation.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({Key? key}) : super(key: key);

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUpPage> {
  String errorMessage = '';
  bool hidePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// メールアドレスでユーザー登録
  Future<void> _signUp() async {
    final authVM = context.read<AuthViewModel>(); // ViewModelを取得

    try {
      await authVM.signUpWithEmail(
        emailController.text,
        passwordController.text,
      );
      // 登録成功時、currentUser がセットされているはず
      if (authVM.currentUser != null) {
        // 画面遷移やメッセージ表示などのUIロジック
        debugPrint("ユーザ登録: ${authVM.currentUser!.toJson()}");
        emailController.clear();
        passwordController.clear();

        // 例: 登録後はログイン画面へ飛ばす
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmailLoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        // FirebaseAuthException の場合はユーザに分かりやすいメッセージを
        errorMessage = e.message ?? '登録に失敗しました。';
      });
      debugPrint('FirebaseAuthException: $e');
    } catch (e) {
      // 予期せぬ例外
      setState(() {
        errorMessage = 'エラーが発生しました: $e';
      });
      debugPrint('Exception: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント登録'),
      ),
      body: BackgroundAnimation1(
        size: MediaQuery.of(context).size,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: 'example@email.com',
                      labelText: 'Email Address',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    child: const Text('登録'),
                    onPressed: _signUp,
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
