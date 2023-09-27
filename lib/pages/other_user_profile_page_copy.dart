import 'package:flutter/material.dart';
import 'package:social_media_app/components/posts_loading_widget.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class OtherUserProfilePage extends StatefulWidget {
  const OtherUserProfilePage({super.key});

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            pinned: true,
            elevation: 0,
            expandedHeight: MediaQuery.of(context).size.width,
            collapsedHeight: 230,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColor.white,
            ),
            flexibleSpace: MyUserAppBar(
              offset: scrollController.hasClients ? scrollController.offset : 0,
            ),
          ),
          // SliverToBoxAdapter(
          //   child: MyUserAppBar(
          //     offset: scrollController.hasClients ? scrollController.offset : 0,
          //   ),
          // ),
          SliverList.builder(
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.all(24.0),
              child: PostLoadingListItem(isUserVisible: false),
            ),
            itemCount: 10,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyUserAppBar extends StatelessWidget {
  final double offset;
  var expanded = true;

  MyUserAppBar({super.key, required this.offset});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final statusBarPadding = MediaQuery.of(context).viewPadding.top + 24;
    final progress = offset / width;
    expanded = progress < 0.04;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      height: expanded ? width : 260,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: expanded ? 0 : statusBarPadding,
            child: AnimatedContainer(
              width: expanded ? width : 90,
              height: expanded ? width : 90,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/temp/girl_4.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            left: 24,
            bottom: 24,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: expanded ? Alignment.centerLeft : Alignment.center,
              child: Column(
                crossAxisAlignment: expanded
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text('Bhobo Akingbade',
                      style: AppText.header2.copyWith(
                          color: expanded ? AppColor.white : AppColor.black)),
                  const SizedBox(height: 10),
                  Text('Lagos, Nigeria',
                      style: AppText.subtitle3.copyWith(
                          color: expanded ? AppColor.white : AppColor.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
