import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_field.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/provider/task_provider.dart';
import 'package:todo_app_with_rest_api/screens/widgets/appbar_widget.dart';
import 'package:todo_app_with_rest_api/screens/widgets/show_custom_snackbar_widget.dart';

class AddScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  AddScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context);
    return Scaffold(
      appBar: AppbarWidget(content: 'Add Task'),
      body: Padding(
        padding: EdgeInsets.only(left: 29, right: 29, top: 43),
        child: Column(
          children: [
            AppTextField(label: 'Title', controller: titleController),
            SizedBox(height: 43),
            AppTextField(label: 'Detail', controller: detailController),
            SizedBox(height: 54),
            GestureDetector(
              onTap: () async {
                String title = titleController.text.trim();
                String detail = detailController.text.trim();
                if (title.isEmpty || detail.isEmpty) {
                  showCustomSnackBar(
                    context,
                    message: "Không được để trống",
                    icon: Icons.error_outline,
                    backgroundColor: AppColorsPath.red,
                  );
                  return;
                }

                try {
                  await context.read<TaskProvider>().addTask(title, detail);
                  if (context.mounted) {
                    Navigator.pop(context);
                    showCustomSnackBar(
                      context,
                      message: "Lưu thành công",
                      icon: Icons.check_circle,
                      backgroundColor: AppColorsPath.green,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    showCustomSnackBar(
                      context,
                      message: "Lỗi khi thêm task: $e",
                      icon: Icons.error_outline,
                      backgroundColor: AppColorsPath.red,
                    );
                  }
                }
              },
              child: _buildButtonWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildButtonWidget(BuildContext context) {
    final size = MediaQuery.of(context);
    return Container(
      width: size.size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColorsPath.purple,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              content: "ADD",
              style: AppTextStyle.text24SemiBold.copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
