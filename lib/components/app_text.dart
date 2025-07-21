import 'package:flutter/cupertino.dart';

import 'app_text_style.dart';

class AppText extends StatelessWidget {
  final String content ;
  final TextStyle? style ;
  const AppText({super.key, required this.content, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: style ??  AppTextStyle.text10Regular,textAlign: TextAlign.center,

    );
  }
}
