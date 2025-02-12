import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<TextEditingController> fieldControllers =
      List.generate(10, (index) => TextEditingController());
  
  bool isFormVisible = false;
  String selectedCategory = "すべて";
  final List<String> categories = ["すべて", "カテゴリ1", "カテゴリ2", "カテゴリ3", "カテゴリ4"];

  void _toggleFormVisibility() {
    setState(() {
      isFormVisible = !isFormVisible;
    });
  }

  void _submitForm() {
    print("検索カテゴリ: $selectedCategory");
    print("検索: ${searchController.text}");
    for (int i = 0; i < fieldControllers.length; i++) {
      print("フィールド${i + 1}: ${fieldControllers[i].text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 検索バー + カテゴリー選択
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "ここでなんか検索",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // 入力フィールド（作成ボタンを押すと表示）
          Visibility(
            visible: isFormVisible,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(fieldControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextField(
                        controller: fieldControllers[index],
                        decoration: InputDecoration(
                          labelText: "入力項目${index + 1}",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // 作成ボタン
          ElevatedButton(
            onPressed: _toggleFormVisibility,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              textStyle: TextStyle(fontSize: 18),
            ),
            child: Text(isFormVisible ? "閉じる" : "作成"),
          ),
        ],
      ),
    );
  }
}
