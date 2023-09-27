import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/bloc/bloc/internet_bloc.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/components/posts_loading_widget.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/main_page/main_page_cubit.dart';
import 'package:social_media_app/cubit/message/message_bloc.dart';
import 'package:social_media_app/cubit/post/create_post_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final internetConnection = context.read<InternetBloc>().state;
      if (internetConnection is InternetConnected &&
          currentScroll == maxScroll - 30) {
        // context.read<PostCubit>().getPost();
        print('getting next posts');
      }
    });
    context.read<PostCubit>().getPost();
    context.read<ChatBloc>().add(ChatStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is PostCreated) {
          context.read<PostCubit>().getPost();
        }
      },
      child: Scaffold(
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
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<PostCubit, PostState>(
            listener: (context, state) {
              if (state is ScrollToTop) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            builder: (context, state) {
              if (state is PostGetSuccessful) {
                return RefreshIndicator(
                  onRefresh: () => context.read<PostCubit>().getPost(),
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: state.posts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (_, index) {
                      return PostItem(state.posts[index]);
                    },
                  ),
                );
              }
              return const PostLoadingWidget();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
