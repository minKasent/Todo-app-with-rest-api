import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_field.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/screens/widgets/appbar_widget.dart';
import 'package:todo_app_with_rest_api/screens/widgets/show_custom_snackbar_widget.dart';

class EditScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();

  EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    titleController.text = args?['title'] ?? '';
    detailController.text = args?['detail'] ?? '';

    return Scaffold(
      appBar: AppbarWidget(content: "Edit Task"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 29, right: 29, top: 43),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(label: 'Title', controller: titleController),
                  SizedBox(height: 43),
                  AppTextField(label: 'Detail', controller: detailController),
                ],
              ),
            ),
            SizedBox(height: 54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    String title = titleController.text.trim();
                    String detail = detailController.text.trim();
                    if (title.isEmpty || detail.isEmpty) {
                      ShowCustomSnackBar(
                        context,
                        message: "Không được để trống",
                        icon: Icons.error_outline,
                        backgroundColor: AppColorsPath.red,
                      );
                      return;
                    }
                    ShowCustomSnackBar(
                      context,
                      message: "Lưu thành công",
                      icon: Icons.check_circle,
                      backgroundColor: AppColorsPath.green,
                    );
                  },
                  child: _buildButtonWidget(content: "Update"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: _buildButtonWidget(content: "Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildButtonWidget({required String content}) {
    return Container(
      width: 170,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColorsPath.purple,
      ),
      child: Center(
        child: AppText(
          content: content,
          style: AppTextStyle.text24SemiBold.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}