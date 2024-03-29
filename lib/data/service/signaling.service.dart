// ignore_for_file: avoid_print

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:social_media_app/cubit/video_call/video_call_cubit.dart';
import 'package:social_media_app/repositories/socket_repo.dart';
import 'package:social_media_app/repositories/webrtc_repo.dart';

class Signaling {
  final WebRTCRepository _rtcRepository = WebRTCRepository();
  final SocketClient _socketClient = SocketClient.instance();

  VideoCallCubit videoCallCubit;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  // MediaStream? _remoteStream;
  final List<RTCIceCandidate> _rtcIceCandidates = [];

  Signaling({required this.videoCallCubit});

  void createRoom(RTCVideoRenderer remoteRenderer, MediaStream? remoteStream,
      MediaStream localStream) async {
    _peerConnection = await _rtcRepository.createPeerConnections();
    print('\n\n\n\nPEER CONNECTION ESTABLISHED\n\n\n\n');

    registerPeerConnectionListeners();

    localStream.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, localStream);
    });

    _socketClient.listen('outgoing:call:accepted', (data) async {
      _rtcRepository.setRemoteDescription(
        _peerConnection!,
        await _rtcRepository.createRTCSessionDescriptionFromMap(data['answer']),
      );

      _socketClient.listen('outgoing:call:candidate', (candidate) async {
        _rtcRepository.addCandidate(
          _peerConnection!,
          await _rtcRepository.createIceCandidateFromMap(candidate),
        );
      });

      for (var candidate in _rtcIceCandidates) {
        _socketClient.send('outgoing:call:candidate', {
          'roomId': videoCallCubit.state.roomId,
          'candidate': candidate.toMap()
        });
      }

      _peerConnection?.onIceCandidate = (candidate) {
        _socketClient.send('outgoing:call:candidate', {
          'roomId': videoCallCubit.state.roomId,
          'candidate': candidate.toMap()
        });
      };

      // videoCallCubit.setCallStatus(CallStatus.onCall);
    });
    // Creating a room
    RTCSessionDescription offer = await _peerConnection!.createOffer();

    print('\n\n\nOffer: ${offer.toMap()}\n\n\n');

    // TODO: Send this offer/SDP to peer
    final payload = {
      'calleeId': '4',
      'caller': videoCallCubit.state.user,
      'roomId': videoCallCubit.state.roomId,
      'offer': offer.toMap(),
    };
    print(payload);
    _socketClient.send('outgoing:call', payload);

    _socketClient.listen(
      'outgoing:call:ack',
      (_) => {
        videoCallCubit.setCallStatus(CallStatus.ringing),
      },
    );

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}\n${event.track}');

      // event.streams[0].getTracks().forEach((track) {
      //   print('Add a track to the remoteStream $track');
      //   remoteStream?.addTrack(track);
      // });
    };
  }

  void joinRoom(String sessionDescription, String sessionType,
      MediaStream localStream) async {
    _peerConnection = await _rtcRepository.createPeerConnections();

    registerPeerConnectionListeners();

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _socketClient.send('incoming:call:candidate', {
        'roomId': videoCallCubit.state.roomId,
        'candidate': candidate,
      });
    };

    _rtcRepository.setRemoteDescription(
        _peerConnection!,
        RTCSessionDescription(
          sessionDescription,
          sessionType,
        ));

    localStream.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    // Code for creating SDP answer
    RTCSessionDescription? answer =
        await _rtcRepository.createAnswer(_peerConnection!);

    // Send answer and ICE candidates to peer via socket
    print('Answer: ${answer!.toMap()}');
    _socketClient.send(
      'incoming:call:accepted',
      {
        'roomId': videoCallCubit.state.roomId,
        'answer': answer.toMap(),
      },
    );

    // TODO: Listen for remote ICE candidates and add them to the local PeerConnection
    _socketClient.listen(
      'incoming:call:candidate',
      (candidate) async {
        _rtcRepository.addCandidate(
          _peerConnection!,
          await _rtcRepository.createIceCandidateFromMap(candidate),
        );
      },
    );

    // _peerConnection?.onTrack = (RTCTrackEvent event) {
    //   print('Got remote track: ${event.streams[0]}\n${event.track}');

    //   event.streams[0].getTracks().forEach((track) {
    //     print('Add a track to the remoteStream $track');
    //     _remoteStream?.addTrack(track);
    //   });
    // };
  }

  Future<MediaStream> openUserMedia() async {
    return _localStream = await _rtcRepository.getMediaStream();
  }

  Future<void> hangUp(RTCVideoRenderer localRenderer) async {
    final remoteStream = videoCallCubit.state.remoteStream;
    final localStream = videoCallCubit.state.localStream;

    localRenderer.srcObject?.getTracks().forEach((track) {
      track.stop();
    });

    remoteStream?.getTracks().forEach((track) {
      track.stop();
    });

    await localStream?.dispose();
    await remoteStream?.dispose();
    await _peerConnection?.close();

    videoCallCubit.setLocalStream(null);
    videoCallCubit.setRemoteStream(null);
    _peerConnection = null;
    print('Hanged up successfully');
  }

  void registerPeerConnectionListeners() {
    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _rtcIceCandidates.add(candidate);
    };

    _peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    _peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state changed: $state');
    };

    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      print('ICE connection state changed: $state');
    };

    _peerConnection?.onAddStream = (MediaStream stream) {
      print('addStream: $stream');
      videoCallCubit.setRemoteStream(stream);
    };

    _peerConnection?.onRemoveStream = (MediaStream stream) {
      print('removeStream: $stream');
      videoCallCubit.setRemoteStream(null);
    };
  }
}
