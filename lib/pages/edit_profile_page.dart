import 'package:flutter/material.dart';
import 'package:social_media_app/components/app_text_field.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

enum RadioItem {
  male,
  female,
  other,
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  RadioItem selectedRadio = RadioItem.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToolBar(title: AppStrings.editProfile),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: UserAvatar(size: 120.0),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(66.0),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              const AppTextField(hint: AppStrings.firstName),
              const SizedBox(height: 16.0),
              const AppTextField(hint: AppStrings.lastName),
              const SizedBox(height: 16.0),
              const AppTextField(hint: AppStrings.phoneNumber),
              const SizedBox(height: 16.0),
              const AppTextField(hint: AppStrings.location),
              const SizedBox(height: 16.0),
              const AppTextField(hint: AppStrings.birthDay),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0)
                    .copyWith(top: 6.0),
                decoration: BoxDecoration(
                  color: AppColor.fieldColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.gender,
                      style: AppText.body1.copyWith(
                        fontSize: 12,
                        color: AppColor.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<RadioItem>(
                            value: RadioItem.male,
                            contentPadding: EdgeInsets.zero,
                            groupValue: selectedRadio,
                            title: const Text(AppStrings.male),
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<RadioItem>(
                            value: RadioItem.female,
                            contentPadding: EdgeInsets.zero,
                            groupValue: selectedRadio,
                            title: const Text(AppStrings.female),
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<RadioItem>(
                            value: RadioItem.other,
                            contentPadding: EdgeInsets.zero,
                            groupValue: selectedRadio,
                            title: const Text(AppStrings.other),
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedRadio = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
