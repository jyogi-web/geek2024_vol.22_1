class UserModel {
  String name;
  final String? email;
  final bool? isEmailVerified;
  final bool? isAnonymous;
  final String? phoneNumber;
  String? photoURL;
  final String? refreshToken;
  final String? tenantId;
  final String? uid;

  UserModel(
      {required this.name,
      this.email,
      this.isEmailVerified,
      this.isAnonymous,
      this.phoneNumber,
      this.photoURL,
      this.refreshToken,
      this.tenantId,
      this.uid});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'isAnonymous': isAnonymous,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'refreshToken': refreshToken,
      'tenantId': tenantId,
      'uid': uid
    };
  }
}
