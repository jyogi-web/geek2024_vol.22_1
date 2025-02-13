import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aicharamaker/ui/create/view_model/create_view_model.dart';

/// UI定義側 (MVVMパターンの "View" 相当)。
/// ViewModelを使って入力フォームとボタンを表示し、ユーザー入力を受け付ける。
class CreateScreen extends StatelessWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// ChangeNotifierProvider を使って ViewModel を提供
    /// （別画面から受け取る場合などはスコープに合わせて書き方を変える）
    return ChangeNotifierProvider(
      create: (_) => CreateScreenViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("キャラ作成"),
        ),
        body: Consumer<CreateScreenViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: viewModel.nameController,
                    decoration: const InputDecoration(
                      labelText: "名前",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.tagController,
                    decoration: const InputDecoration(
                      labelText: "タグ (半角スペース区切り)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.descriptionController,
                    decoration: const InputDecoration(
                      labelText: "説明",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.imageUrlController,
                    decoration: const InputDecoration(
                      labelText: "画像URL",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.genderController,
                    decoration: const InputDecoration(
                      labelText: "性別",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.personalityController,
                    decoration: const InputDecoration(
                      labelText: "性格",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "身長",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.bloodTypeController,
                    decoration: const InputDecoration(
                      labelText: "血液型",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "年齢",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.hobbiesController,
                    decoration: const InputDecoration(
                      labelText: "趣味 (半角スペース区切り)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.familyStructureController,
                    decoration: const InputDecoration(
                      labelText: "家族構成",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.birthDateController,
                    decoration: const InputDecoration(
                      labelText: "誕生日 (YYYY-MM-DD)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.otherDetailsController,
                    decoration: const InputDecoration(
                      labelText: "その他(話し方など)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.likesDislikesController,
                    decoration: const InputDecoration(
                      labelText: "好き/嫌い",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.concernsController,
                    decoration: const InputDecoration(
                      labelText: "悩み",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: viewModel.remarksController,
                    decoration: const InputDecoration(
                      labelText: "備考",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // ViewModelの submitProfile を呼び出す
                      viewModel.submitProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("決定！"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
