import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:provider/provider.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/routes/app_routes.dart';
import 'package:todo_app_with_rest_api/provider/task_provider.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to add screen và chờ result
        final result = await Navigator.pushNamed(context, AppRoutes.add);

        // Nếu add thành công, reload tasks
        if (result == true) {
          context.read<TaskProvider>().loadTasks();
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppColorsPath.purple,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColorsPath.dark.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Icon(Icons.add, color: AppColorsPath.white, size: 35),
      ),
    );
  }
}
