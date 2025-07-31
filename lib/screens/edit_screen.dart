import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_field.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/provider/task_provider.dart';
import 'package:todo_app_with_rest_api/screens/widgets/appbar_widget.dart';
import 'package:todo_app_with_rest_api/screens/widgets/show_custom_snackbar_widget.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  Task? _task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_task == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      if (args != null && args.containsKey('task')) {
        _task = args['task'] as Task;
        _titleController.text = _task!.title;
        _detailController.text = _task!.description;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  AppTextField(label: 'Title', controller: _titleController),
                  SizedBox(height: 43),
                  AppTextField(label: 'Detail', controller: _detailController),
                ],
              ),
            ),
            SizedBox(height: 54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    String title = _titleController.text.trim();
                    String detail = _detailController.text.trim();
                    if (title.isEmpty || detail.isEmpty) {
                      ShowCustomSnackBar(
                        context,
                        message: "Không được để trống",
                        icon: Icons.error_outline,
                        backgroundColor: AppColorsPath.red,
                      );
                      return;
                    }
                    if (_task != null) {
                      // Hiển thị loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) =>
                                Center(child: CircularProgressIndicator()),
                      );

                      final updatedTask = _task!.copyWith(
                        title: title,
                        description: detail,
                      );

                      final success = await context
                          .read<TaskProvider>()
                          .updateTask(updatedTask);

                      // Đóng loading dialog
                      Navigator.pop(context);

                      if (success) {
                        // Hiển thị thông báo thành công trước
                        ShowCustomSnackBar(
                          context,
                          message: "Cập nhật thành công",
                          icon: Icons.check_circle,
                          backgroundColor: AppColorsPath.green,
                        );

                        // Delay một chút để user thấy thông báo, sau đó quay lại
                        await Future.delayed(Duration(milliseconds: 500));

                        // Quay lại home screen
                        Navigator.pop(
                          context,
                          true,
                        ); // Return true để indicate success
                      } else {
                        final errorMessage =
                            context.read<TaskProvider>().errorMessage;
                        ShowCustomSnackBar(
                          context,
                          message: errorMessage ?? "Có lỗi xảy ra khi cập nhật",
                          icon: Icons.error_outline,
                          backgroundColor: AppColorsPath.red,
                        );
                      }
                    }
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
