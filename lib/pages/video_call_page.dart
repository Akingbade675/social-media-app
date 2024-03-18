import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:social_media_app/components/frosted_glass.dart';
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/cubit/video_call/video_call_cubit.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/signaling.service.dart';
import 'package:social_media_app/repositories/webrtc_repo.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class VideoCallPage extends StatefulWidget {
  final bool isCaller;
  const VideoCallPage({super.key, required this.isCaller});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  late final Timer countDownTimer;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _setUpLocalMedia().then(
      (value) => {
        if (widget.isCaller)
          {_startVideoCall(), initiateCountDownTimer()}
        else
          {_acceptVideoCall()}
      },
    );
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _acceptVideoCall() {
    context.read<VideoCallCubit>().acceptCall(_localStream!);
  }

  void _startVideoCall() {
    context.read<VideoCallCubit>().startCall(
          const User(
            id: '4',
            email: 'bhobo2@register.com',
            name: 'Bhobo2',
          ),
          _remoteRenderer,
          _localStream!,
        );
  }

  void initiateCountDownTimer() {
    countDownTimer = Timer(const Duration(minutes: 1), () {
      // FlutterRingtonePlayer.stop();
      hangUp().then((value) => Navigator.pop(context));
    });
  }

  Future<void> _setUpLocalMedia() async {
    _localStream = await WebRTCRepository().getMediaStream();
    _localRenderer.srcObject = _localStream;
    setState(() {});
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/temp/girl_4.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Container(),
              ),
            ),
          ),
          Positioned.fill(
            child: Builder(
              builder: (context) {
                final callState = context.watch<VideoCallCubit>().state;

                if (_remoteStream != null) {
                  countDownTimer.cancel();
                  return RTCVideoView(
                    _remoteRenderer,
                    mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  );
                }
                return CallStateWidget(
                  name: callState.friend?.name ?? 'John Dammy',
                  callStatus: callState.callStatus,
                );
              },
            ),
          ),
          // Positioned(
          //   top: 100,
          //   left: 20,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text(
          //         'Mare Smith',
          //         style: AppText.subtitle2.copyWith(color: AppColor.white),
          //       ),
          //       const SizedBox(height: 20),
          //       Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 6,
          //           vertical: 4,
          //         ),
          //         decoration: BoxDecoration(
          //           color: AppColor.primary,
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         child: Text(
          //           '',
          //           style: AppText.subtitle3.copyWith(color: AppColor.white),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Positioned(
            bottom: 15,
            left: 25,
            right: 25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onPanUpdate: (details) {},
                  onVerticalDragStart: (details) {
                    print('drag start');
                  },
                  onVerticalDragEnd: (details) {
                    print('drag end');
                  },
                  onPanEnd: (details) {},
                  onPanStart: (details) {
                    print('pan start');
                  },
                  child: PhysicalModel(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      width: 110,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: RTCVideoView(
                          _localRenderer,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                FrostedGlassCard(
                  padding: const EdgeInsets.all(10),
                  borderRadius: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      callIconButton(icon: Icons.videocam_off),
                      callIconButton(icon: Icons.mic_off),
                      IconButton.filled(
                        padding: const EdgeInsets.all(16),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.call_end_sharp,
                          color: AppColor.white,
                        ),
                        onPressed: () {
                          hangUp().then((value) => Navigator.pop(context));
                        },
                      ),
                      callIconButton(icon: Icons.switch_camera_outlined),
                      callIconButton(icon: Icons.bluetooth),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconButton callIconButton({
    Color color = Colors.transparent,
    VoidCallback? onPressed,
    required IconData icon,
  }) {
    return IconButton.filled(
      icon: Icon(icon, color: AppColor.white),
      highlightColor: color,
      focusColor: color,
      style: IconButton.styleFrom(
        backgroundColor: color,
      ),
      onPressed: onPressed,
    );
  }

  Future<void> hangUp() async {
    _localRenderer.srcObject?.getTracks().forEach((track) {
      track.stop();
    });

    _remoteStream?.getTracks().forEach((track) {
      track.stop();
    });

    await _localStream?.dispose();
    await _remoteStream?.dispose();
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();

    _localStream = null;
    _remoteStream = null;

    setState(() {});
  }
}

class CallStateWidget extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final CallStatus callStatus;

  const CallStateWidget({
    super.key,
    this.imageUrl,
    required this.name,
    required this.callStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          const UserAvatar(
            size: 120,
            borderRadius: 18,
            imageUrl: 'assets/temp/girl_4.jpg',
          ),
          const SizedBox(height: 30),
          Text(
            name,
            style: AppText.title1.copyWith(color: AppColor.black),
          ),
          const SizedBox(height: 20),
          Text(
            callStatus.name == 'ringing' ? 'Ringing...' : 'Calling...',
            style: AppText.subtitle2.copyWith(color: AppColor.black),
          ),
        ],
      ),
    );
  }
}
