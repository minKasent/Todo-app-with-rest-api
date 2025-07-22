import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/constants/app_icons_path.dart';
import 'package:todo_app_with_rest_api/screens/widgets/add_floating_action_button_widget.dart';
import 'package:todo_app_with_rest_api/screens/widgets/bottom_navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lightWhite,
      appBar: _buildAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(right: 7, top: 22, left: 7),
        child: Column(children: [_buildTaskItemWidget()]),
      ),
      floatingActionButton: AddFloatingActionButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }

  AppBar _buildAppBarWidget() {
    return AppBar(
      toolbarHeight: 90,
      backgroundColor: AppColorsPath.purple,
      title: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(style: AppTextStyle.text24SemiBold, content: 'TODO APP'),
            Icon(Icons.calendar_today, size: 30, color: AppColorsPath.white),
          ],
        ),
      ),
    );
  }

  Container _buildTaskItemWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsPath.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColorsPath.dark.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 19, top: 20, bottom: 20, right: 25),
      child: Row(
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
          const Spacer(),
          ..._buildListIconsWidget(),
        ],
      ),
    );
  }

  GestureDetector _buildIconWidget({
    required VoidCallback onTap,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, color: AppColorsPath.lighPurple),
    );
  }

  List<Widget> _buildListIconsWidget() {
    return [
      _buildIconWidget(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/edit',
            arguments: {'title': 'todoTitle', 'detail': 'todoDetail '},
          );
        },
        imagePath: AppIconsPath.icPencil,
      ),
      SizedBox(width: 20),
      _buildIconWidget(
        onTap: () {
          _showDeleteDialog();
        },
        imagePath: AppIconsPath.icTrash,
      ),
      SizedBox(width: 20),
      _buildIconWidget(
        /// TODO: complete task logic
        onTap: () {},
        imagePath: AppIconsPath.icCheckCircle,
      ),
    ];
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete confirmation'),
            content: Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  /// TODO : Handle delete action here
                  Navigator.of(context).pop();
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );
  }
}
