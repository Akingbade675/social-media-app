import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/bloc/bloc/internet_bloc.dart';
import 'package:social_media_app/components/persistent_divider.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/components/posts_loading_widget.dart';
import 'package:social_media_app/components/scroll_animation_wrapper.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/cubit/message/message_bloc.dart';
import 'package:social_media_app/cubit/post/create_post_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit_copy.dart';
import 'package:social_media_app/cubit/video_call/video_call_cubit.dart';
import 'package:social_media_app/repositories/socket_repo.dart';
import 'package:social_media_app/styles/app_colors.dart';

class CustomHomePage extends StatefulWidget {
  const CustomHomePage({super.key});

  @override
  State<CustomHomePage> createState() => _CustomHomePageState();
}

class _CustomHomePageState extends State<CustomHomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     showDialog(
    //       context: context,
    //       builder: (_) => AlertDialog(
    //         title: const Text('Allow Notifications'),
    //         content: const Text(
    //             'Please allow notifications to get the best experience'),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text('Cancel'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               AwesomeNotifications()
    //                   .requestPermissionToSendNotifications()
    //                   .then((_) => Navigator.of(context).pop());
    //             },
    //             child: const Text('Allow'),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final internetConnection = context.read<InternetBloc>().state;
      if (internetConnection is InternetConnected &&
          currentScroll == maxScroll - 30) {
        // context.read<PostCubit>().getPost();
        print('getting next post');
      }
    });
    // context.read<PostBloc>().add(GetPost());
    // context.read<ChatBloc>().add(ChatStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is PostCreated) {
          context.read<PostBloc>().add(GetPost());
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Social Media App'),
            backgroundColor: AppColor.white,
            surfaceTintColor: AppColor.white,
            floating: true,
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
                    AppColor.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const PersistentDividerHeader(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: BlocConsumer<PostBloc, PostState>(
              listener: (context, state) {
                // if (state is ScrollToTop) {
                //   _scrollController.animateTo(
                //     0,
                //     duration: const Duration(milliseconds: 300),
                //     curve: Curves.easeInOut,
                //   );
                // }
              },
              builder: (context, state) {
                if (state.isLoading != true) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ScrollAnimationWrapper(
                        controller: _scrollController,
                        child: state.posts[index],
                      ),
                      childCount: state.posts.length,
                    ),
                  );
                } else {
                  return SliverList.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (_, __) => const PostLoadingListItem(),
                    itemCount: 5,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
