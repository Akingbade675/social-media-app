part of 'video_call_cubit.dart';

enum CallStatus {
  idle,
  dialing,
  ringing,
  onCall,
  ended,
}

final class VideoCallState extends Equatable {
  final User? user;
  final User? friend;
  final String? roomId;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final bool isFrontCamera;
  final bool isCaller;
  final String? sessionType;
  final String? sessionDescription;
  final String callType;
  final CallStatus callStatus;
  final bool isCallAccepted;
  final bool isCallRejected;
  final bool isCallEnded;
  final bool isCallCancelled;
  final bool isCallBusy;
  final bool isCallDeclined;
  final bool isCallTimeout;
  final bool isCallFailed;

  const VideoCallState({
    this.user,
    this.friend,
    this.roomId,
    this.localStream,
    this.remoteStream,
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = false,
    this.isFrontCamera = true,
    this.isCaller = true,
    this.sessionType,
    this.sessionDescription,
    this.callType = 'video',
    this.callStatus = CallStatus.idle,
    this.isCallAccepted = false,
    this.isCallRejected = false,
    this.isCallEnded = false,
    this.isCallCancelled = false,
    this.isCallBusy = false,
    this.isCallDeclined = false,
    this.isCallTimeout = false,
    this.isCallFailed = false,
  });

  @override
  List<Object> get props => [
        user ?? '',
        friend ?? '',
        roomId ?? '',
        localStream ?? '',
        remoteStream ?? '',
        isMuted,
        isCameraOff,
        isSpeakerOn,
        isFrontCamera,
        isCaller,
        sessionType ?? '',
        sessionDescription ?? '',
        callType,
        callStatus,
        isCallAccepted,
        isCallRejected,
        isCallEnded,
        isCallCancelled,
        isCallBusy,
        isCallDeclined,
        isCallTimeout,
        isCallFailed,
      ];

  VideoCallState copyWith({
    User? user,
    User? friend,
    String? roomId,
    MediaStream? localStream,
    MediaStream? remoteStream,
    bool? isMuted,
    bool? isCameraOff,
    bool? isSpeakerOn,
    bool? isFrontCamera,
    bool? isCaller,
    String? sessionType,
    String? sessionDescription,
    String? callType,
    CallStatus? callStatus,
    bool? isCallAccepted,
    bool? isCallRejected,
    bool? isCallEnded,
    bool? isCallCancelled,
    bool? isCallBusy,
    bool? isCallDeclined,
    bool? isCallTimeout,
    bool? isCallFailed,
  }) {
    return VideoCallState(
      user: user,
      friend: friend ?? this.friend,
      roomId: roomId ?? this.roomId,
      localStream: localStream,
      remoteStream: remoteStream,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isCaller: isCaller ?? this.isCaller,
      sessionType: sessionType ?? this.sessionType,
      sessionDescription: sessionDescription ?? this.sessionDescription,
      callType: callType ?? this.callType,
      callStatus: callStatus ?? this.callStatus,
      isCallAccepted: isCallAccepted ?? this.isCallAccepted,
      isCallRejected: isCallRejected ?? this.isCallRejected,
      isCallEnded: isCallEnded ?? this.isCallEnded,
      isCallCancelled: isCallCancelled ?? this.isCallCancelled,
      isCallBusy: isCallBusy ?? this.isCallBusy,
      isCallDeclined: isCallDeclined ?? this.isCallDeclined,
      isCallTimeout: isCallTimeout ?? this.isCallTimeout,
      isCallFailed: isCallFailed ?? this.isCallFailed,
    );
  }
}
