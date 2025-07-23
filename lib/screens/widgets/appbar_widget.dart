import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String content;
  const AppbarWidget({super.key, required this.content});

  @override
  Size get preferredSize => Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColorsPath.white, size: 35),
      toolbarHeight: 90,
      backgroundColor: AppColorsPath.purple,
      title: Container(
        padding: EdgeInsets.only(right: 15, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(style: AppTextStyle.text24SemiBold, content: content),
          ],
        ),
      ),
    );
  }
}