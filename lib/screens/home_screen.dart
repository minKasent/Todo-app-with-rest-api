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
import 'package:todo_app_with_rest_api/screens/widgets/show_custom_snackbar_widget.dart';

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
      context.read<TaskProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lightWhite,
      appBar: _buildAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(right: 7, top: 22, left: 7),
        child: Column(
          children: [
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  /// Loading case
                  if (taskProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  /// Error case
                  if (taskProvider.hasError) {
                    return _buildErrorWidget(taskProvider);
                  }

                  final pendingTasks = taskProvider.pendingTasks;

                  return RefreshIndicator(
                    child:
                        pendingTasks.isEmpty
                            ? _buildEmptyWidget()
                            : _buildListTasksWidget(pendingTasks),
                    onRefresh: () async {
                      await context.read<TaskProvider>().refresh();
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  Center _buildErrorWidget(TaskProvider taskProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          AppText(
            content: 'Error: ${taskProvider.error}',
            style: AppTextStyle.text24SemiBold.copyWith(color: Colors.red),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => taskProvider.init(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: AppText(
              content: "Retry",
              style: AppTextStyle.text13Semibold.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildEmptyWidget() {
    return ListView(
      children: [
        SizedBox(height: 200),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                content: 'No task yet',
                style: AppTextStyle.text24SemiBold.copyWith(
                  color: AppColorsPath.dark,
                ),
              ),
              SizedBox(height: 16),
              AppText(
                content: 'Add your first task to get started',
                style: AppTextStyle.text24SemiBold.copyWith(
                  color: AppColorsPath.dark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView _buildListTasksWidget(List<Task> tasks) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 21),
      itemCount: tasks.length,
      padding: EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final task = tasks[index];
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
      /// Edit task
      _buildIconWidget(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.edit,
            arguments: {'task': task},
          );
        },
        imagePath: AppIconsPath.icPencil,
      ),
      SizedBox(width: 20),

      /// Delete task
      _buildIconWidget(
        onTap: () {
          if (task.id == null) {
            /// Show dialog notify id task null
            debugPrint("Task id is null");
            showCustomSnackBar(
              context,
              message: "Task id is null",
              icon: Icons.error_outline,
              backgroundColor: AppColorsPath.red,
            );
          } else {
            _showDeleteDialog(task.id!);
          }
        },
        imagePath: AppIconsPath.icTrash,
      ),
      SizedBox(width: 20),

      /// Complete task
      _buildIconWidget(
        /// TODO: Show cofirm complete dialog
        onTap: () {
          final completedTask = task.copyWith(status: 'completada');
          context.read<TaskProvider>().updateTask(completedTask);
        },
        imagePath: AppIconsPath.icCheckCircle,
      ),
    ];
  }

  void _showDeleteDialog(String taskId) {
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
                  context.read<TaskProvider>().deleteTask(taskId);
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
