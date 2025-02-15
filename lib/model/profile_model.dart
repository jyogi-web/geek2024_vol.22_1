class ProfileModel {
  final String id;
  final String userId;
  final String userName;
  final String name;
  final List<String>? tag;
  final String? description;
  final String? imageUrl;
  final String? gender;
  final String? personality;
  final String? height;
  final String? bloodType;
  final String? age;
  final List<String>? hobbies;
  final String? familyStructure;
  final String? birthDate;
  final String? otherDetails;
  final String? likesDislikes;
  final String? concerns;
  final String? remarks;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id, // ID
    required this.userId, // ユーザーID
    required this.userName, // ユーザー名
    required this.name, // 名前
    this.tag, // タグ
    this.description, // 説明
    this.imageUrl, // 画像URL
    this.gender, // 性別
    this.personality, // 性格
    this.height, // 身長
    this.bloodType, // 血液型
    this.age, // 年齢
    this.hobbies, // 趣味
    this.familyStructure, // 家族構成
    this.birthDate, // 生年月日
    this.otherDetails, // その他 話し方など
    this.likesDislikes, // 好き嫌い
    this.concerns, // 悩み
    this.remarks, // 備考
    required this.createdBy, // 作成者
    required this.createdAt, // 作成日時
    required this.updatedAt, // 更新日時
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'name': name,
      'tag': tag,
      'description': description,
      'imageUrl': imageUrl,
      'gender': gender,
      'personality': personality,
      'height': height,
      'bloodType': bloodType,
      'age': age,
      'hobbies': hobbies,
      'familyStructure': familyStructure,
      'birthDate': birthDate,
      'otherDetails': otherDetails,
      'likesDislikes': likesDislikes,
      'concerns': concerns,
      'remarks': remarks,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
