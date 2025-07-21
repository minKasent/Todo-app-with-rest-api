import 'package:flutter/material.dart';
import '../components/app_text.dart';
import '../components/app_text_field.dart';
import '../components/app_text_style.dart';
import '../constants/app_colors_path.dart';

class EditScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    titleController.text = args?['title'] ?? '';
    detailController.text = args?['detail'] ?? '';
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColorsPath.white, size: 35),
        toolbarHeight: 90,
        backgroundColor: AppColorsPath.purple,
        title: Padding(
          padding: EdgeInsets.only(right: 15, left: 8),
          child: AppText(
            style: AppTextStyle.text24SemiBold,
            content: 'Edit Task',
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 29, right: 29, top: 43),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(label: 'Title', controller: titleController),
                  SizedBox(height: 43),
                  AppTextField(label: 'Detail', controller: detailController),
                ],
              ),
            ),
            SizedBox(height: 54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Nút Update
                GestureDetector(
                  onTap: () {
                    String title = titleController.text.trim();
                    String detail = detailController.text.trim();

                    if (title.isEmpty || detail.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.white, size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Không được để trống Title hoặc Detail',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Color(0xFFD32F2F),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Lưu thành công!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Color(0xFF43A047),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },

                ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 14),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Container(
                        width: 170,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColorsPath.purple,
                        ),
                        child: Center(
                          child: AppText(
                            content: "Update",
                            style: AppTextStyle.text24SemiBold.copyWith(fontSize: 20),
                          ),
                        ),
                                       ),
                       GestureDetector(
                         onTap: () {
                           Navigator.pop(context);
                         },
                         child: Container(
                           width: 170,
                           height: 70,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(15),
                             color: AppColorsPath.purple,
                           ),
                           child: Center(
                             child: AppText(
                               content: "Cancel",
                               style: AppTextStyle.text24SemiBold.copyWith(fontSize: 20),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
              ],
            ),
            SizedBox(height: 54),
          ],
        ),
      ),
    );
  }
}
