import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/routes/app_routes.dart';

class AddFloatingActionButtonWidget extends StatelessWidget {
  const AddFloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.add);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColorsPath.purple,
          boxShadow: [
            BoxShadow(
              color: AppColorsPath.dark.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        width: 70,
        height: 70,
        child: Icon(Icons.add, color: AppColorsPath.white, size: 35),
      ),
    );
  }
}
