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
            _buildBottomNavigationBarItemWidget(context, isCompletedTab: false),
            _buildBottomNavigationBarItemWidget(context, isCompletedTab: true),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildBottomNavigationBarItemWidget(
    BuildContext context, {
    required bool isCompletedTab,
  }) {
    return GestureDetector(
      onTap:
          isCompletedTab
              ? () {
                Navigator.pushNamed(context, AppRoutes.complete);
              }
              : null,
      child: Column(
        children: [
          Icon(
            isCompletedTab ? Icons.check : Icons.format_list_bulleted,
            color: isCompletedTab ? AppColorsPath.gray : AppColorsPath.purple,
            size: 30,
          ),
          AppText(
            content: isCompletedTab ? "Completed" : "All",
            style: AppTextStyle.text10Regular.copyWith(
              color: isCompletedTab ? AppColorsPath.gray : AppColorsPath.purple,
            ),
          ),
        ],
      ),
    );
  }
}
