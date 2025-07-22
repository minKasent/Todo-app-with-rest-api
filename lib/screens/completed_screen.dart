import 'package:flutter/material.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_colors_path.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lightWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColorsPath.white, size: 35),
        toolbarHeight: 90,
        backgroundColor: AppColorsPath.purple,
        title: Padding(
          padding: EdgeInsets.only(right: 15, left: 8),
          child: AppText(
            style: AppTextStyle.text24SemiBold,
            content: 'Completed Task',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 7, top: 22, left: 7),
        child: Column(
          children: [
            Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AppText(
                        content: "TODO TITLE",
                        style: AppTextStyle.text13Semibold,
                      ),
                      SizedBox(height: 5),
                      AppText(
                        content: "TODO SUB TITLE",
                        style: AppTextStyle.text10Regular,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15),
                    width: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}