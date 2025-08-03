import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_rest_api/components/app_button.dart';
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
  double screenWidth = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;

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
                AppButton(
                  onTap: () async {
                    await _updateTask(context);
                  },
                  content: "Update",
                  width: (screenWidth - 14 * 2 - 46) / 2,
                ),
                AppButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  content: "Cancel",
                  width: (screenWidth - 14 * 2 - 46) / 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateTask(BuildContext context) async {
    String title = _titleController.text.trim();
    String detail = _detailController.text.trim();
    if (title.isEmpty || detail.isEmpty) {
      showCustomSnackBar(
        context,
        message: "Title and detail are required",
        icon: Icons.error_outline,
        backgroundColor: AppColorsPath.red,
      );
      return;
    }
    if (_task != null) {
      try {
        final updatedTask = _task!.copyWith(title: title, description: detail);
        await context.read<TaskProvider>().updateTask(updatedTask);
        if (context.mounted) {
          Navigator.pop(context);
          showCustomSnackBar(
            context,
            message: "Save successfully",
            icon: Icons.check_circle,
            backgroundColor: AppColorsPath.green,
          );
        }
      } catch (e) {
        if (context.mounted) {
          showCustomSnackBar(
            context,
            message: "Lỗi khi cập nhật task: $e",
            icon: Icons.error_outline,
            backgroundColor: AppColorsPath.red,
          );
        }
      }
    }
  }
}
