import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aicharamaker/model/user_model.dart';
import 'package:aicharamaker/ui/auth/view_model/auth_view_model.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Center(
        child: user != null ? _buildUserInfo(user) : Text('No user logged in.'),
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Name: ${user.name}', style: TextStyle(fontSize: 24)),
        Text('Email: ${user.email}', style: TextStyle(fontSize: 24)),
        Text('Phone: ${user.phoneNumber}', style: TextStyle(fontSize: 24)),
        user.photoURL != null ? Image.network(user.photoURL!) : Container(),
      ],
    );
  }
}
