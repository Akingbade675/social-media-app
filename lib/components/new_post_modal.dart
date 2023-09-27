import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/components/app_text_field.dart';
import 'package:social_media_app/cubit/app/app_cubit.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/cubit/post/create_post_cubit.dart';
import 'package:social_media_app/cubit/users/users_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class NewPostModal extends StatelessWidget {
  const NewPostModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Insert Message', style: AppText.header2),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
              hint: 'Message...',
              onChanged: (value) {
                context.read<CreatePostCubit>().changePostMsg(value);
              }),
          const SizedBox(
            height: 16,
          ),
          const Text('Add Image', style: AppText.header2),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () async {
              context.read<CreatePostCubit>().pickImage(ImageSource.gallery);
            },
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: BlocBuilder<CreatePostCubit, CreatePostState>(
                builder: (context, state) {
                  if (state is CreatingPostState && state.image.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.file(
                            File(state.image),
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<CreatePostCubit>().clearImage();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColor.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('Upload from gallery'));
                },
              ),
            ),
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
              final token = context.read<AppCubit>().state.token!;
              context.read<CreatePostCubit>().createPost(token).then((value) {
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

class CreatePostModalSheet extends StatelessWidget {
  const CreatePostModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Container(
        color: AppColor.grey,
        // margin: EdgeInsets.only(top: 38),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  Builder(builder: (context) {
                    final state = context.watch<CreatePostCubit>().state;
                    return TextButton(
                      onPressed: (state is CreatingPostState &&
                              state.message.isNotEmpty)
                          ? () => createPost(context)
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.primaryDark,
                        foregroundColor: AppColor.white,
                        visualDensity: VisualDensity.comfortable,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Post'),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Material(
                // color: AppColor.white.withOpacity(0.9),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/temp/girl_3.jpg'),
                          ),
                          const SizedBox(width: 10),
                          Text(context
                              .read<AuthenticationCubit>()
                              .getUser()
                              .name),
                        ],
                      ),
                    ),
                    TextField(
                      maxLines: null,
                      expands: true,
                      onChanged: (value) {
                        context.read<CreatePostCubit>().changePostMsg(value);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What\'s on your mind?',
                        // hintStyle: TextStyle(
                        //   fontSize: 20,
                        // ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Builder(builder: (context) {
                      final state = context.watch<CreatePostCubit>().state;
                      if (state is CreatingPostState &&
                          state.image.isNotEmpty) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColor.grey,
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(state.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      context
                                          .read<CreatePostCubit>()
                                          .pickImage(ImageSource.gallery);
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Edit   '),
                                    style: TextButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor:
                                          Colors.transparent.withOpacity(
                                        0.5,
                                      ),
                                      foregroundColor: AppColor.white,
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton.filled(
                                    onPressed: () {
                                      context
                                          .read<CreatePostCubit>()
                                          .clearImage();
                                    },
                                    icon: const Icon(Icons.close),
                                    style: TextButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor:
                                          Colors.transparent.withOpacity(
                                        0.5,
                                      ),
                                      foregroundColor: AppColor.white,
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Builder(builder: (context) {
                final state = context.watch<CreatePostCubit>().state;
                return Row(
                  children: [
                    IconButton(
                      onPressed:
                          state is CreatingPostState && state.image.isNotEmpty
                              ? null
                              : () {
                                  context
                                      .read<CreatePostCubit>()
                                      .pickImage(ImageSource.camera);
                                },
                      // disable camera button if image is already picked
                      icon: const Icon(Icons.photo_camera),
                      color: AppColor.black.withOpacity(0.7),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      onPressed:
                          state is CreatingPostState && state.image.isNotEmpty
                              ? null
                              : () {
                                  context
                                      .read<CreatePostCubit>()
                                      .pickImage(ImageSource.gallery);
                                },
                      icon: const Icon(Icons.photo),
                      color: AppColor.black.withOpacity(0.7),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void createPost(BuildContext context) {
    final token = context.read<AppCubit>().state.token!;
    context.read<CreatePostCubit>().createPost(token).then((value) {
      Navigator.of(context).pop();
    });
  }
}
