import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/app/app_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    final token = context.read<AppCubit>().state.token;
    print('TOKEN: $token');
    context.read<PostCubit>().getPost(token!);
  }

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
      body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        return state is PostGetSuccessful
            ? ListView.separated(
                itemCount: state.posts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 24),
                itemBuilder: (_, index) {
                  return PostItem(state.posts[index]);
                },
              )
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
