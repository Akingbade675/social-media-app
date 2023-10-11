import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/bloc/bloc/internet_bloc.dart';
import 'package:social_media_app/components/loading_bar.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/app/app_cubit.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/cubit/emoji_keyboard_cubit.dart';
import 'package:social_media_app/cubit/main_page/main_page_cubit.dart';
import 'package:social_media_app/cubit/message/message_bloc.dart';
import 'package:social_media_app/cubit/post/create_post_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit_copy.dart';
import 'package:social_media_app/cubit/users/users_cubit.dart';
import 'package:social_media_app/cubit/video_call/video_call_cubit.dart';
import 'package:social_media_app/data/service/notification_service.dart';
import 'package:social_media_app/repositories/socket_repo.dart';
import 'package:social_media_app/repositories/user_repo.dart';
import 'package:social_media_app/styles/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  Connectivity connectivity = Connectivity();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await NotificationService.initializeNotification();

  runApp(
    RepositoryProvider(
      create: (context) => UserRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InternetBloc(connectivity: connectivity),
          ),
          BlocProvider(
            create: (context) => AuthenticationCubit(
                userRepository: context.read<UserRepository>()),
          ),
          BlocProvider(
            create: (context) => AppCubit(),
          ),
          BlocProvider(create: (_) => MainPageCubit()),
          BlocProvider(
            create: (context) => PostCubit(
              context.read<AuthenticationCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostBloc(
              context.read<AuthenticationCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              context.read<AuthenticationCubit>(),
            ),
          ),
          BlocProvider(
            create: (_) => CreatePostCubit(),
          ),
          BlocProvider(
            create: (context) => UsersCubit(
              authenticationCubit: context.read<AuthenticationCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => VideoCallCubit(
              authCubit: context.read<AuthenticationCubit>(),
            ),
          ),
          BlocProvider(
            create: (_) => EmojiKeyboardCubit(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().appStarted();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: AppStrings.appName,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColor.white,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.pages,
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Builder(
          builder: (context) {
            final authState = context.watch<AuthenticationCubit>().state;
            if (authState is AuthenticationUnintialized) {
              return const Scaffold(
                body: LoadingBar(),
              );
            } else if (authState is AuthenticationAuthenticated) {
              SocketRepository.setInstance(context.read<AuthenticationCubit>());
              SocketRepository.instance.initializeSocket();
              context.read<VideoCallCubit>().init();

              return AppRoutes.mainPage;
            } else {
              return AppRoutes.loginPage;
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    SocketRepository.instance.close();
    super.dispose();
  }
}
