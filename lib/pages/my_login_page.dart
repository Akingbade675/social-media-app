import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/app_text_field.dart';
import 'package:social_media_app/components/signin_button.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/app/app_cubit.dart';
import 'package:social_media_app/cubit/auth/authentication_cubit.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationSuccess) {
                    print('State: $state');
                    context
                        .read<AppCubit>()
                        .userLoggedIn(user: state.user, token: state.token);
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  }
                  if (state is AuthenticationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AuthenticationInitial
                      ? const LoginPageWidget()
                      : state is AuthenticationLoading
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Logging in...'),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : const SizedBox.shrink();
                },
              ),
            ),
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
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
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
            hint: AppStrings.username, controller: _usernameController),
        const SizedBox(height: 16),
        AppTextField(
            hint: AppStrings.password,
            controller: _passwordController,
            obscureText: true),
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationCubit>().loginUser(
                  _usernameController.text, _passwordController.text);
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
              onPressed: () {},
              child: const Text(AppStrings.signUp),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
