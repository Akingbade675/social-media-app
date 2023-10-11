import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/bloc/bloc/internet_bloc.dart';
import 'package:social_media_app/components/bottom_nav_bar.dart';
import 'package:social_media_app/components/bottom_navigation_item.dart';
import 'package:social_media_app/config/app_config.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/cubit/main_page/main_page_cubit.dart';
import 'package:social_media_app/cubit/message/message_bloc.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';
import 'package:social_media_app/pages/custom_home_page.dart';
import 'package:social_media_app/pages/my_profile_page_copy.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    final internetConnection = context.read<InternetBloc>().state;
    print('Internet Connection State');
    if (internetConnection is InternetConnected) {
      print('Internet Connected');
      context.read<PostCubit>().getPost();
      context.read<ChatBloc>().add(ChatStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final currentItemIndex = context.watch<MainPageCubit>().state.index;
            return IndexedStack(
              index: currentItemIndex,
              children: _pages,
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  final _pages = const [
    // MyHomePage(),
    CustomHomePage(),
    Center(child: Text('Favourites')),
    Center(child: Text('Add Post')),
    SizedBox(),
    CustomProfilePage(),
  ];
}
