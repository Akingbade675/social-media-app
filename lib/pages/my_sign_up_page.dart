import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/app_text_field.dart';
import 'package:social_media_app/components/loading_bar.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/auth/signup_cubit.dart';

class MySignupPage extends StatelessWidget {
  const MySignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<SignupCubit, SignupState>(
                listener: (context, state) {
                  if (state is SignupSuccess) {
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  }
                  if (state is SignupFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return const SignupPageWidget();
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class SignupPageWidget extends StatefulWidget {
  const SignupPageWidget({super.key});

  @override
  State<SignupPageWidget> createState() => _SignupPageWidgetState();
}

class _SignupPageWidgetState extends State<SignupPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            const Text(
              AppStrings.signUp,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            AppTextField(
              hint: AppStrings.email,
              onChanged: (value) {
                context.read<SignupCubit>().setEmail(value);
              },
            ),
            const SizedBox(height: 24),
            AppTextField(
              hint: AppStrings.username,
              onChanged: (value) {
                context.read<SignupCubit>().setUsername(value);
              },
            ),
            const SizedBox(height: 24),
            AppTextField(
              hint: AppStrings.password,
              obscureText: true,
              onChanged: (value) {
                context.read<SignupCubit>().setPassword(value);
              },
            ),
            const SizedBox(height: 24),
            AppTextField(
              hint: AppStrings.confirmPassword,
              obscureText: true,
              onChanged: (value) {
                context.read<SignupCubit>().setConfirmPassword(value);
              },
            ),
            const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<SignupCubit>().signupUser();
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
                  AppStrings.signUp,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
        Visibility(
          visible: context.watch<SignupCubit>().state is SignupLoading,
          child: const LoadingBar(),
        ),
      ],
    );
  }
}
