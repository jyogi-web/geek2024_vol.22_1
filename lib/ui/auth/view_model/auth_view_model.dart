import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aicharamaker/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 認証まわりの状態や処理をまとめる。
class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // 現在ログイン中のユーザーを表す (nullの場合は未ログイン)
  UserModel? currentUser;

  // GitHubプロバイダ
  final githubProvider = GithubAuthProvider();

  /// GitHubでログイン
  Future<void> signInWithGitHub() async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithPopup(githubProvider);

      // 取得したFirebaseのUserをUserModelに変換して保持する
      final user = userCredential.user;
      if (user != null) {
        currentUser = _convertToUserModel(user);
        debugPrint("GitHubログイン成功: ${currentUser!.toJson()}");
      }
    } catch (e, st) {
      debugPrint("GitHubログイン失敗: $e\n$st");
      rethrow; // 必要に応じて再スローやエラー管理を行う
    }
    notifyListeners(); // UIに変更があったことを通知
  }

  /// メールアドレスでログイン
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        currentUser = _convertToUserModel(user);
        debugPrint("メールログイン成功: ${currentUser!.toJson()}");
      }
    } catch (e, st) {
      debugPrint("メールログイン失敗: $e\n$st");
      rethrow; // ここで例外処理を書くか、呼び出し元で処理
    }
    notifyListeners();
  }

  /// メールアドレスでアカウント作成
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        currentUser = _convertToUserModel(user);
        debugPrint("メールでアカウント作成成功: ${currentUser!.toJson()}");
      }
    } catch (e, st) {
      debugPrint("メールでアカウント作成失敗: $e\n$st");
      rethrow;
    }
    notifyListeners();
  }

  /// ログアウト
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    currentUser = null;
    debugPrint("ログアウトしました。");
    notifyListeners();
  }

  /// FirebaseのUser情報をUserModelに変換するヘルパー
  UserModel _convertToUserModel(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email,
      isEmailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      refreshToken: user.refreshToken,
      tenantId: user.tenantId,
      uid: user.uid,
    );
  }
}
