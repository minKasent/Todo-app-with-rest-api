import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/provider/task_provider.dart';
import 'package:todo_app_with_rest_api/screens/widgets/appbar_widget.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lightWhite,
      appBar: AppbarWidget(content: "Completed Task"),
      body: Padding(
        padding: const EdgeInsets.only(right: 7, top: 22, left: 7),
        child: Column(
          children: [Expanded(child: _buildListCompletedTasksWidget())],
        ),
      ),
    );
  }

  Selector _buildListCompletedTasksWidget() {
    return Selector<TaskProvider, List<Task>>(
      builder: (_, data, __) {
        return ListView.separated(
          padding: EdgeInsets.only(bottom: 30),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final task = data[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColorsPath.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColorsPath.dark.withValues(alpha: 0.25),
                    blurRadius: 5,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 19, top: 22, right: 30),
              height: 82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText(
                      content: task.title,
                      style: AppTextStyle.text13Semibold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: AppText(
                      content: task.description,
                      style: AppTextStyle.text10Regular,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 21),
          itemCount: data.length,
        );
      },
      selector: (_, taskProvider) => taskProvider.completedTasks,
    );
  }
}
