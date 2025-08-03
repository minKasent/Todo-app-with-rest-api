import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';

class AppButton extends StatelessWidget {
  final String content;
  final double? width;
  final VoidCallback onTap;
  const AppButton({
    required this.content,
    this.width,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? size.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColorsPath.purple,
        ),
        padding: const EdgeInsets.only(top: 22, bottom: 22),
        alignment: Alignment.center,
        child: AppText(
          content: content,
          style: AppTextStyle.text24SemiBold.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}
