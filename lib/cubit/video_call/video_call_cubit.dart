import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/notification_service.dart';
import 'package:social_media_app/data/service/overlay_service.dart';
import 'package:social_media_app/data/service/signaling.service.dart';
import 'package:social_media_app/repositories/socket_repo.dart';
import 'package:social_media_app/styles/app_colors.dart';

part 'video_call_state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  final AuthenticationCubit authCubit;
  late Signaling signaling;
  late SocketRepository socketRepo;

  VideoCallCubit({required this.authCubit}) : super(const VideoCallState());

  void init() {
    socketRepo = SocketRepository.instance;
    final user = authCubit.getUser();
    // emit(state.copyWith(user: authCubit.getUser()));
    signaling = Signaling(videoCallCubit: this);
    socketRepo.listen('incoming:call', (data) {
      print('Incoming call ${user.id}: $data');
      if (data['calleeId'] == user.id) {
        socketRepo.send('incoming:call:ack', {'roomId': data['roomId']});

        print('Incoming call: $data');
        emit(state.copyWith(
          // callStatus: CallStatus.ringing,
          roomId: data['roomId'],
          friend: User.fromMap(data['caller']),
          sessionType: data['offer']['type'],
          sessionDescription: data['offer']['sdp'],
        ));
        // play ringing sound and show incoming call notification
        CallKitService.showIncomingCall(
          uuid: data['roomId'],
          callerHandle: data['caller']['name']!,
          callerName: data['caller']['name']!,
        );

        //   NotificationService.showNotification(
        //     title: 'Incoming Call',
        //     body: '${state.friend!.name} is calling...',
        //     category: NotificationCategory.Call,
        //     actionButtons: [
        //       NotificationActionButton(
        //         key: 'accept_call',
        //         label: 'ACCEPT',
        //         autoDismissible: true,
        //         color: AppColor.primary,
        //       ),
        //       NotificationActionButton(
        //         key: 'reject_call',
        //         label: 'REJECT',
        //         autoDismissible: true,
        //         color: Colors.red,
        //       ),
        //     ],
        //   );
      }
    });
  }

  void endCall(RTCVideoRenderer localRenderer) {
    signaling.hangUp(localRenderer);
    emit(state.copyWith(
      callStatus: CallStatus.ended,
      isCallEnded: true,
    ));
  }

  void rejectCall() {
    // signaling.close();
    emit(state.copyWith(
      callStatus: CallStatus.ended,
      isCallDeclined: true,
    ));
  }

  void startCall(
      User callee, RTCVideoRenderer remoteRenderer, MediaStream stream) async {
    final roomId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    emit(state.copyWith(
      user: authCubit.getUser(),
      roomId: roomId,
      isCaller: true,
      friend: callee,
    ));
    signaling.createRoom(remoteRenderer, state.remoteStream, stream);
  }

  void acceptCall(MediaStream stream) {
    signaling.joinRoom(state.sessionType!, state.sessionDescription!, stream);
  }

  void setCaller(bool isCaller) {
    emit(state.copyWith(isCaller: isCaller));
  }

  void setFriend(User friend) {
    emit(state.copyWith(friend: friend));
  }

  void setCallId(String callId) {
    emit(state.copyWith(roomId: callId));
  }

  void setLocalStream(MediaStream? localStream) {
    emit(state.copyWith(localStream: localStream));
  }

  MediaStream? getLocalStream() {
    return state.localStream;
  }

  void setRemoteStream(MediaStream? remoteStream) {
    emit(state.copyWith(remoteStream: remoteStream));
  }

  void setSessionType(String sessionType) {
    emit(state.copyWith(sessionType: sessionType));
  }

  void setSessionDescription(String sessionDescription) {
    emit(state.copyWith(sessionDescription: sessionDescription));
  }

  void setCallStatus(CallStatus callStatus) {
    emit(state.copyWith(callStatus: callStatus));
  }

  void setCallType(String callType) {
    emit(state.copyWith(callType: callType));
  }

  void setCallAccepted(bool isCallAccepted) {
    emit(state.copyWith(isCallAccepted: isCallAccepted));
  }

  void setCallRejected(bool isCallRejected) {
    emit(state.copyWith(isCallRejected: isCallRejected));
  }

  void setCallEnded(bool isCallEnded) {
    emit(state.copyWith(isCallEnded: isCallEnded));
  }

  void setCallCancelled(bool isCallCancelled) {
    emit(state.copyWith(isCallCancelled: isCallCancelled));
  }

  void setCallBusy(bool isCallBusy) {
    emit(state.copyWith(isCallBusy: isCallBusy));
  }

  void setCallDeclined(bool isCallDeclined) {
    emit(state.copyWith(isCallDeclined: isCallDeclined));
  }

  void setCallTimeout(bool isCallTimeout) {
    emit(state.copyWith(isCallTimeout: isCallTimeout));
  }

  void setCallFailed(bool isCallFailed) {
    emit(state.copyWith(isCallFailed: isCallFailed));
  }

  void setMuted(bool isMuted) {
    emit(state.copyWith(isMuted: isMuted));
  }

  void setCameraOff(bool isCameraOff) {
    emit(state.copyWith(isCameraOff: isCameraOff));
  }

  void setSpeakerOn(bool isSpeakerOn) {
    emit(state.copyWith(isSpeakerOn: isSpeakerOn));
  }

  void setFrontCamera(bool isFrontCamera) {
    emit(state.copyWith(isFrontCamera: isFrontCamera));
  }
}
