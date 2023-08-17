import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      titleTextStyle: AppText.title1,
      title: Text(title),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
