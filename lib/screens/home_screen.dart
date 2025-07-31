import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_with_rest_api/components/app_text.dart';
import 'package:todo_app_with_rest_api/components/app_text_style.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';
import 'package:todo_app_with_rest_api/constants/app_icons_path.dart';
import 'package:todo_app_with_rest_api/models/task.dart';
import 'package:todo_app_with_rest_api/provider/task_provider.dart';
import 'package:todo_app_with_rest_api/routes/app_routes.dart';
import 'package:todo_app_with_rest_api/screens/widgets/bottom_navigation_bar_widget.dart';
import 'package:todo_app_with_rest_api/screens/widgets/floating_action_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lightWhite,
      appBar: _buildAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(right: 7, top: 22, left: 7),
        child: Column(children: [Expanded(child: _buildListTasksWidget())]),
      ),
      floatingActionButton: FloatingActionButtonWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }

  AppBar _buildAppBarWidget() {
    return AppBar(
      toolbarHeight: 90,
      backgroundColor: AppColorsPath.purple,
      title: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(style: AppTextStyle.text24SemiBold, content: 'TODO APP'),
            Image.asset(
              AppIconsPath.icCalendar,
              width: 60,
              height: 60,
              color: AppColorsPath.white,
            ),
          ],
        ),
      ),
    );
  }

  Selector _buildListTasksWidget() {
    return Selector<TaskProvider, List<Task>>(
      builder: (_, data, __) {
        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 21),
          itemCount: data.length,
          padding: EdgeInsets.only(bottom: 30),
          itemBuilder: (context, index) {
            final task = data[index];
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
              padding: EdgeInsets.only(
                left: 19,
                top: 20,
                bottom: 20,
                right: 25,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          content: task.title,
                          style: AppTextStyle.text13Semibold,
                        ),
                        const SizedBox(height: 5),
                        AppText(
                          content: task.description,
                          style: AppTextStyle.text10Regular,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ..._buildListIconsActionWidget(task),
                ],
              ),
            );
          },
        );
      },
      selector: (_, taskProvider) => taskProvider.pendingTasks,
    );
  }

  GestureDetector _buildIconWidget({
    required VoidCallback onTap,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, color: AppColorsPath.lightPurple),
    );
  }

  List<Widget> _buildListIconsActionWidget(Task task) {
    return [
      _buildIconWidget(
        onTap: () async {
          // Navigate to edit screen và chờ result
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.edit,
            arguments: {'task': task},
          );

          // Nếu edit thành công, reload tasks
          if (result == true) {
            context.read<TaskProvider>().loadTasks();
          }
        },
        imagePath: AppIconsPath.icPencil,
      ),
      SizedBox(width: 20),
      _buildIconWidget(
        onTap: () {
          _showDeleteDialog(task.id!);
        },
        imagePath: AppIconsPath.icTrash,
      ),
      SizedBox(width: 20),
      _buildIconWidget(
        onTap: () async {
          // Lưu trữ contexts trước khi async operation
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);
          final taskProvider = context.read<TaskProvider>();

          // Hiển thị loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );

          try {
            final updatedTask = task.copyWith(status: 'completada');
            final success = await taskProvider.updateTask(updatedTask);

            // Đóng loading dialog
            if (mounted) {
              navigator.pop();
            }

            if (mounted) {
              if (success) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Đánh dấu hoàn thành thành công'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                final errorMessage = taskProvider.errorMessage;
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(errorMessage ?? 'Có lỗi xảy ra khi cập nhật task'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } catch (e) {
            // Đóng loading dialog nếu có lỗi
            if (mounted) {
              navigator.pop();
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Có lỗi xảy ra: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        imagePath: AppIconsPath.icCheckCircle,
      ),
    ];
  }

  void _showDeleteDialog(String taskId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa task này không?'),
        actions: [
          TextButton(
            child: Text('Hủy', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              // Lưu trữ contexts trước khi async operation
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final taskProvider = context.read<TaskProvider>();

              Navigator.of(dialogContext).pop();

              // Hiển thị loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingContext) => Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                final success = await taskProvider.deleteTask(taskId);

                // Đóng loading dialog
                if (mounted) {
                  navigator.pop();
                }

                // Hiển thị kết quả
                if (mounted) {
                  if (success) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Xóa task thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    final errorMessage = taskProvider.errorMessage;
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(errorMessage ?? 'Có lỗi xảy ra khi xóa task'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                // Đóng loading dialog nếu có lỗi
                if (mounted) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Có lỗi xảy ra: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
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
