import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Builder(
          builder: (context) {
            final callState = context.watch<VideoCallCubit>().state;

            if (_remoteStream != null &&
                callState.callStatus == CallStatus.onCall) {
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
        SafeArea(
          child: Positioned(
            bottom: 20,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Text(
                  'Mare Smith',
                  style: AppText.subtitle2.copyWith(color: AppColor.white),
                ),
                const Spacer(),
                GestureDetector(
                  onPanUpdate: (details) {},
                  onPanEnd: (details) {},
                  onPanStart: (details) {
                    print('pan start');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: AppColor.white,
                      width: 80,
                      height: 130,
                      child: RTCVideoView(
                        _localRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        backgroundColor: AppColor.primary,
                        onPressed: () {},
                        child: const Icon(Icons.videocam_off),
                      ),
                      FloatingActionButton(
                        backgroundColor: AppColor.primary,
                        onPressed: () {},
                        child: const Icon(Icons.mic_off),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: AppColor.error,
                        label: const Text('00:00'),
                        icon: const Icon(Icons.call_end_sharp),
                        onPressed: () {
                          hangUp().then((value) => Navigator.pop(context));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
    return Column(
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
    );
  }
}
