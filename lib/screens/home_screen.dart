import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';

import '../constants/app_colors_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lightWhite,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppColorsPath.purple,
        title: Container(
          padding: EdgeInsets.only(left:15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                style: AppTextStyle.text24SemiBold, content: 'TODO APP',
              ),
              Icon(
                Icons.calendar_today,
                size: 30,
                color: AppColorsPath.white,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 7,top: 22,left: 7),
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
              padding: EdgeInsets.only(left: 19,top: 22,right: 30),
              height: 82,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AppText(content: "TODO TITLE",style: AppTextStyle.text13Semibold),
                      SizedBox(height: 5,),
                      AppText(content: "TODO SUB TITLE",style: AppTextStyle.text10Regular,)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15),
                    width: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/edit',
                                  arguments: {
                                    'title': 'todoTitle',
                                    'detail': 'todoDetail '
                                  }
                              );
                            },
                            child: Icon(Icons.edit,color: AppColorsPath.lighPurple,)),
                        Icon(Icons.delete_outline,color: AppColorsPath.lighPurple,),
                        Icon(Icons.check_circle_outline,color: AppColorsPath.lighPurple,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: AppColorsPath.purple,
        child: Icon(Icons.add, color: AppColorsPath.white, size: 35),
      ),
      bottomNavigationBar: Container(
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             Column(
               children: [
                 Icon(
                     Icons.format_list_bulleted,
                   color: AppColorsPath.purple,
                   size: 30,
                 ),
                 AppText(content: "All",style: AppTextStyle.text10Regular.copyWith(color: AppColorsPath.purple),),
               ],
             ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/complete');
                },
                child: Column(
                  children: [
                    Icon(Icons.check,color: AppColorsPath.purple,size: 30,),
                    AppText(content: "Completed",style: AppTextStyle.text10Regular.copyWith(color: AppColorsPath.purple),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}