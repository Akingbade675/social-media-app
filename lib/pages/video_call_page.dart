import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:social_media_app/cubit/video_call/video_call_cubit.dart';
import 'package:social_media_app/data/model/user.dart';
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
  late final Timer countDownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
    if (widget.isCaller) {
      _startVideoCall();
      initiateCountDownTimer();
    } else {
      _acceptVideoCall();
    }
    // _setUpLocalMedia();
  }

  initialization() {
    initRenderers();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _acceptVideoCall() {
    context.read<VideoCallCubit>().acceptCall();
  }

  void _startVideoCall() {
    context.read<VideoCallCubit>().startCall(
          const User(
            id: '4',
            email: 'bhobo2@register.com',
            name: 'Bhobo2',
          ),
          _remoteRenderer,
        );
  }

  void initiateCountDownTimer() {
    final videoCallCubit = context.read<VideoCallCubit>();
    countDownTimer = Timer(const Duration(minutes: 1), () {
      // FlutterRingtonePlayer.stop();
      videoCallCubit.endCall(_localRenderer);
    });
  }

  // void _setUpLocalMedia() async {
  //   final localStream = await _signaling.openUserMedia();
  //   _localRenderer.srcObject = localStream;
  //   setState(() {});
  // }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Builder(builder: (context) {
                  final callState = context.watch<VideoCallCubit>().state;

                  if (callState.callStatus == CallStatus.onCall) {
                    countDownTimer.cancel();
                    _remoteRenderer.srcObject = callState.remoteStream;
                    return RTCVideoView(
                      _remoteRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    );
                  }
                  return CallStateWidget(
                    name: callState.friend?.name ?? 'John Dammy',
                    callStatus: callState.callStatus,
                  );
                }),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 120,
                      height: 150,
                      child: Builder(
                        builder: (context) {
                          final localStream =
                              context.watch<VideoCallCubit>().state.localStream;
                          _localRenderer.srcObject = localStream;
                          return RTCVideoView(
                            _localRenderer,
                            mirror: true,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.mic_off),
                ),
                FloatingActionButton(
                  onPressed: () {
                    context.read<VideoCallCubit>().endCall(_localRenderer);
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.call_end),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.videocam_off),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        const SizedBox(height: 30),
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColor.grey,
          backgroundImage: const AssetImage('assets/temp/girl_4.jpg'),
        ),
        const SizedBox(height: 24),
        Text(
          name,
          style: AppText.subtitle1.copyWith(color: AppColor.black),
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
