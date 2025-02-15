import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/model/user_model.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthViewModelのインスタンスを取得
    final authViewModel = Provider.of<AuthViewModel>(context);
    final UserModel? user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: user != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(user.name),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(user.email ?? 'No email provided'),
                  ),
                  ListTile(
                    title: const Text('Email Verified'),
                    subtitle: Text(user.isEmailVerified == true ? 'Yes' : 'No'),
                  ),
                  ListTile(
                    title: const Text('Anonymous'),
                    subtitle: Text(user.isAnonymous == true ? 'Yes' : 'No'),
                  ),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(user.phoneNumber ?? 'No phone number'),
                  ),
                  ListTile(
                    title: const Text('Photo URL'),
                    subtitle: Text(user.photoURL ?? 'No photo URL'),
                  ),
                  ListTile(
                    title: const Text('Refresh Token'),
                    subtitle: Text(user.refreshToken ?? 'No refresh token'),
                  ),
                  ListTile(
                    title: const Text('Tenant ID'),
                    subtitle: Text(user.tenantId ?? 'No tenant id'),
                  ),
                  ListTile(
                    title: const Text('UID'),
                    subtitle: Text(user.uid ?? 'No uid'),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ユーザーがログインしていません'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // ログイン画面などへ遷移する処理を記述
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('ログイン画面へ'),
                  ),
                ],
              ),
            ),
    );
  }
}
