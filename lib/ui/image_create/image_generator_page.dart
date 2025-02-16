import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageGeneratorPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String doc_id;

  const ImageGeneratorPage(
      {Key? key, required this.profile, required this.doc_id})
      : super(key: key);

  @override
  _ImageGeneratorPageState createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends State<ImageGeneratorPage> {
  String? _imageUrl;
  bool _isLoading = false;

  /// Firestore から取得した Map の各フィールドを使ってプロンプト文字列を生成する
  String buildPrompt(Map<String, dynamic> profile, String doc_id) {
    List<String> parts = [];
    parts.add(
        "This is an agent to create a character. I will provide information about the character. Please adhere to it as much as possible.");
    if (profile['name'] != null &&
        profile['name'].toString().trim().isNotEmpty) {
      parts.add("Name: ${profile['name']}");
    }
    if (profile['age'] != null && profile['age'].toString().trim().isNotEmpty) {
      parts.add("Age: ${profile['age']}");
    }
    if (profile['height'] != null &&
        profile['height'].toString().trim().isNotEmpty) {
      parts.add("Height: ${profile['height']}");
    }
    if (profile['bloodType'] != null &&
        profile['bloodType'].toString().trim().isNotEmpty) {
      parts.add("Blood type: ${profile['bloodType']}");
    }
    if (profile['familyStructure'] != null &&
        profile['familyStructure'].toString().trim().isNotEmpty) {
      parts.add("Family structure: ${profile['familyStructure']}");
    }

    if (profile['tag'] != null &&
        profile['tag'] is List &&
        (profile['tag'] as List).isNotEmpty) {
      parts.add("Tags: ${(profile['tag'] as List).join(', ')}");
    }

    if (profile['otherDetails'] != null &&
        profile['otherDetails'].toString().trim().isNotEmpty) {
      parts.add("Other details: ${profile['otherDetails']}");
    }
    if (profile['description'] != null &&
        profile['description'].toString().trim().isNotEmpty) {
      parts.add("Description: ${profile['description']}");
    }
    if (profile['gender'] != null &&
        profile['gender'].toString().trim().isNotEmpty) {
      parts.add("Gender: ${profile['gender']}");
    }
    if (profile['personality'] != null &&
        profile['personality'].toString().trim().isNotEmpty) {
      parts.add("Personality: ${profile['personality']}");
    }
    if (profile['hobbies'] != null &&
        profile['hobbies'] is List &&
        (profile['hobbies'] as List).isNotEmpty) {
      parts.add("Hobbies: ${(profile['hobbies'] as List).join(', ')}");
    }
    if (profile['likesDislikes'] != null &&
        profile['likesDislikes'].toString().trim().isNotEmpty) {
      parts.add("Likes/Dislikes: ${profile['likesDislikes']}");
    }
    if (profile['concerns'] != null &&
        profile['concerns'].toString().trim().isNotEmpty) {
      parts.add("Concerns: ${profile['concerns']}");
    }
    if (profile['remarks'] != null &&
        profile['remarks'].toString().trim().isNotEmpty) {
      parts.add("Remarks: ${profile['remarks']}");
    }
    if (profile['createdBy'] != null &&
        profile['createdBy'].toString().trim().isNotEmpty) {
      parts.add("user_id: ${profile['createdBy']}");
    }

    // 必要に応じて他のフィールドも追加可能
    return parts.join(". ") + ".";
  }

  Future<void> _generateImage() async {
    setState(() {
      _isLoading = true;
    });

    // dotenv の初期化（アプリ起動時に一度 load しておく方法もあります）
    await dotenv.load(fileName: ".env");
    final serverIp = dotenv.env['MY_SERVER_IP'];
    final _url = 'http://$serverIp:8000/generate';
    final url = Uri.parse(_url);

    // Firestore の全プロフィール情報からプロンプト文字列を作成
    final prompt = buildPrompt(widget.profile, widget.doc_id);

    print('prompt $prompt');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "prompt": prompt,
          "user_id": widget.profile['createdBy'],
          "name": widget.profile['name'],
          "doc_id": widget.doc_id,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // サーバー側が返すフィールド名は image_url とする前提
        setState(() {
          _imageUrl = data['image_url'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Image generation failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画像生成'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _imageUrl != null
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(_imageUrl!),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "プロンプト:\n${buildPrompt(widget.profile, widget.doc_id)}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text('画像が生成されていません'),
      ),
    );
  }
}
