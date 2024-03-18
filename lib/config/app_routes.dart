import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/cubit/auth/login_cubit1.dart';
import 'package:social_media_app/cubit/auth/signup_cubit.dart';
import 'package:social_media_app/cubit/message/message_cubit.dart';
import 'package:social_media_app/pages/edit_profile_page.dart';
import 'package:social_media_app/pages/main_page.dart';
import 'package:social_media_app/pages/my_chat_page.dart';
import 'package:social_media_app/pages/my_home_page.dart';
import 'package:social_media_app/pages/my_login_page.dart';
import 'package:social_media_app/pages/my_profile_page.dart';
import 'package:social_media_app/pages/my_sign_up_page.dart';
import 'package:social_media_app/pages/nearby_page.dart';
import 'package:social_media_app/pages/other_user_profile_page_copy.dart';
import 'package:social_media_app/pages/package_chat_page.dart';
import 'package:social_media_app/pages/video_call_page.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> pages = {
    login: (context) => loginPage,
    signup: (context) => signupPage,
    main: (context) => mainPage,
    home: (context) => homePage,
    profile: (context) => profilePage,
    editProfile: (context) => editProfilePage,
    nearby: (context) => nearbyPage,
    chat: (context) => chatPage,
    otherUserProfile: (context) => otherUserProfilePage,
    videoCall: (context) => videoCallPage,
  };

  static final loginPage = BlocProvider(
    create: (context) => LoginCubit(
      authenticationCubit: context.read<AuthenticationCubit>(),
    ),
    child: const MyLoginPage(),
  );

  static final signupPage = BlocProvider(
    create: (context) => SignupCubit(),
    child: const MySignupPage(),
  );

  static const mainPage = MainPage();

  static const homePage = MyHomePage();

  static const profilePage = MyProfilePage();

  static const editProfilePage = EditProfilePage();

  static const nearbyPage = NearbyPage();

  static final chatPage = BlocProvider(
    create: (context) => MessageCubit(
      authenticationCubit: context.read<AuthenticationCubit>(),
    ),
    child: const MyChatPage(),
  );

  static const otherUserProfilePage = OtherUserProfilePage();

  static const videoCallPage = VideoCallPage(isCaller: true);

  static const packageChatPage = PackageChatPage();

  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const main = '/main';
  static const profile = '/profile';
  static const editProfile = '/edit_profile';
  static const nearby = '/nearby';
  static const chat = '/chat';
  static const otherUserProfile = '/other_user_profile';
  static const videoCall = '/video_call';
}
