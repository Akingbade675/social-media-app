import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToolBar(
        title: AppStrings.appName,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.nearby);
            },
            icon: SvgPicture.asset(
              AppIcons.icLocation,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(height: 24),
          itemBuilder: (_, index) {
            return const PostItem();
          }),
    );
  }
}
