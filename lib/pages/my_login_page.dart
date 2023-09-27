import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/app_text_field.dart';
import 'package:social_media_app/components/loading_bar.dart';
import 'package:social_media_app/components/signin_button.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/auth/login_cubit1.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              // if (state is LoginSuccess) {
              //   Navigator.pushReplacementNamed(context, AppRoutes.main);
              // }
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return const LoginPageWidget();
            },
          ),
        ),
      ),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            const Text(
              AppStrings.helloWelcome,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.loginInContinue,
              style: TextStyle(),
            ),
            const Spacer(),
            AppTextField(
              hint: AppStrings.username,
              onChanged: (value) {
                context.read<LoginCubit>().setEmail(value);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: AppStrings.password,
              obscureText: true,
              onChanged: (value) {
                context.read<LoginCubit>().setPassword(value);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(12).copyWith(right: 0),
                ),
                child: const Text(AppStrings.forgotPassword),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<LoginCubit>().loginUser();
                  // Navigator.of(context).pushNamed(AppRoutes.main);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  AppStrings.login,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(AppStrings.orSignInWith),
            const SizedBox(height: 10.0),
            const SignInButton(
              text: AppStrings.loginWithGoogle,
              iconPath: AppIcons.icGoogle,
            ),
            const SignInButton(
              text: AppStrings.loginWithFacebook,
              iconPath: AppIcons.icFacebook,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(AppStrings.dontHaveAccount),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.signup);
                  },
                  child: const Text(AppStrings.signUp),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        Visibility(
            visible: context.watch<LoginCubit>().state is LoginLoading,
            child: const LoadingBar()),
      ],
    );
  }
}
