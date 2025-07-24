import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/routes/app_routes.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationBarItemWidget(context, isCompleteTab: false),
            _buildBottomNavigationBarItemWidget(context, isCompleteTab: true),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBottomNavigationBarItemWidget(
    BuildContext context, {
    required bool isCompleteTab,
  }) {
    return GestureDetector(
      onTap: isCompleteTab
          ? () {
              Navigator.pushNamed(context, AppRoutes.complete);
            }
          : null,
      child: Column(
        children: [
          Icon(
            isCompleteTab ? Icons.check : Icons.format_list_bulleted,
            color: isCompleteTab ? AppColorsPath.gray : AppColorsPath.purple,
            size: 30,
          ),
          AppText(
            content: isCompleteTab ? "Completed" : "All",
            style: AppTextStyle.text10Regular.copyWith(
              color: isCompleteTab ? AppColorsPath.gray : AppColorsPath.purple,
            ),
          ),
        ],
      ),
    );
  }
}
