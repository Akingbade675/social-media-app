import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/app_text_field.dart';
import 'package:social_media_app/cubit/app/app_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class NewPostModal extends StatelessWidget {
  const NewPostModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Insert Message', style: AppText.header2),
          const SizedBox(
            height: 16,
          ),
          const AppTextField(hint: 'Message...'),
          const SizedBox(
            height: 16,
          ),
          const Text('Add Image', style: AppText.header2),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Upload from gallery')),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text('OR'),
          const SizedBox(
            height: 16,
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Camera'),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<PostCubit>()
                  .createPost('message', context.read<AppCubit>().state.token!)
                  .then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }
}
