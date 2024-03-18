import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:social_media_app/bloc/bloc/internet_bloc.dart';
import 'package:social_media_app/components/loading_bar.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/components/user_pager_item.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/users/users_cubit.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class NearbyPage extends StatefulWidget {
  const NearbyPage({super.key});

  @override
  State<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  final pageController = PageController(viewportFraction: 0.9);
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    final internetState = context.read<InternetBloc>().state;
    if (internetState is InternetConnected) {
      context.read<UsersCubit>().getAllUsers(internetState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToolBar(title: AppStrings.nearby),
      body: Builder(
        builder: (context) {
          final usersState = context.watch<UsersCubit>().state;
          final internetState = context.watch<InternetBloc>().state;

          if (internetState is InternetDisconnected) {
            return const Center(
              child: Text(
                'No Internet Connection!!!',
                style: AppText.subtitle1,
              ),
            );
          } else {
            context.read<UsersCubit>().getAllUsers(internetState);
          }

          if (usersState is UsersLoading) {
            return const LoadingBar();
          }
          return Stack(
            children: [
              _buildMap((usersState as UsersLoaded).users),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 250,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: usersState.users.length,
                    itemBuilder: (context, index) {
                      return UserPagerItem(user: usersState.users[index]);
                    }),
              )
            ],
          );
        },
      ),
    );
  }

  _buildGoogleMap(List<User> users) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(6.5961984, 3.3390592),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      markers: Set.from(
        List.generate(
          users.length,
          (index) => Marker(
            markerId: MarkerId(users[index].id),
            position: LatLng(
              6.5961984 + (0.2 * index),
              3.3390592 + (0.2 * index),
            ),
            infoWindow: InfoWindow(
              title: users[index].name,
              snippet: users[index].email,
            ),
            onTap: () {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            },
          ),
        ),
      ),
    );
  }

  flutterMap.FlutterMap _buildMap(List<User> users) {
    return flutterMap.FlutterMap(
      options: flutterMap.MapOptions(
        center: const latLng.LatLng(6.5961984, 3.3390592),
        zoom: 10,
      ),
      children: [
        flutterMap.TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.social_media_ap',
          subdomains: const ['a', 'b', 'c'],
        ),
        flutterMap.MarkerLayer(
          markers: List.generate(
            users.length,
            (index) => myMarker(index, users),
          ),
        ),
      ],
    );
  }

  flutterMap.Marker myMarker(int index, List<User> users) {
    return flutterMap.Marker(
      width: 200.0,
      height: 100.0,
      // point: const LatLng(6.5961984, 3.3390592),
      point:
          latLng.LatLng(6.5961984 + (0.2 * index), 3.3390592 + (0.2 * index)),
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.grey,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(users[index].name,
                    style: AppText.body2.copyWith(color: Colors.white)),
              ),
              const SizedBox(height: 4),
              CustomPaint(
                painter: MarkerPainter(),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipPath(
                    clipper: MarkerClipper(),
                    child: SizedBox(
                      width: 48,
                      height: 60,
                      child: Image.asset(
                        'assets/temp/guy_4.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw a custom map marker
    final paint = Paint()
      ..color = AppColor.primaryDark
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawPath(_getPath(size), paint);
    canvas.drawShadow(_getPath(size), AppColor.grey, 10, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MarkerClipper extends CustomClipper<ui.Path> {
  @override
  getClip(Size size) => _getPath(size);

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

ui.Path _getPath(Size size) {
  final path = ui.Path();
  path.moveTo(size.width / 2, size.height);
  path.quadraticBezierTo(-.9, (size.height / 2) + 16, 0, size.height / 2);

  final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height);
  path.arcTo(rect, math.pi, math.pi, true);

  path.quadraticBezierTo(
      size.width + .9, (size.height / 2) + 16, size.width / 2, size.height);

  return path;
}

class UserMarkerClipper extends CustomClipper<ui.Path> {
  @override
  getClip(Size size) => _getShapePath(size);

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

ui.Path _getShapePath(Size size) {
  final path = ui.Path();
  path.moveTo(size.width * 0.15, 0);
  path.quadraticBezierTo(
    -.9,
    size.height * 0.35,
    size.width * 0.15,
    size.height * 0.7,
  );

  // final rect = Rect.fromCenter(
  //   center: Offset(0, size.height / 2),
  //   width: size.width * 0.4,
  //   height: size.height,
  // );
  // path.arcTo(rect, math.pi, math.pi, true);

  path.lineTo(size.width * 0.4, size.height * 0.7);
  path.lineTo(size.width * 0.5, size.height);
  path.lineTo(size.width * 0.6, size.height * 0.7);

  path.lineTo(size.width * 0.85, size.height * 0.7);

  path.quadraticBezierTo(
    size.width + .9,
    size.height * 0.35,
    size.width * 0.85,
    0,
  );

  path.lineTo(size.width * 0.15, 0);

  // path.quadraticBezierTo(
  //     size.width + .9, (size.height / 2) + 16, size.width / 2, size.height);

  return path;
}
