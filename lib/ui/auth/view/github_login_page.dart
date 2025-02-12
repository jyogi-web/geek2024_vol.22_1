import 'package:aicharamaker/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/background_animation.dart';

class GithubLoginPage extends StatefulWidget {
  const GithubLoginPage({Key? key}) : super(key: key);

  @override
  _GithubLogindPage createState() => _GithubLogindPage();
}

class _GithubLogindPage extends State<GithubLoginPage> {
  GithubAuthProvider githubProvider = GithubAuthProvider();

  Future _signInWithGitHub() async {
    await FirebaseAuth.instance.signInWithPopup(githubProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: Text('Login with GitHub'),
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
                })
          ],
        ),
      ),
    );
  }
}
