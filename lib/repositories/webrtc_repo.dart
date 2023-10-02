import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCRepository {
  final Map<String, dynamic> offerSdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  Future<MediaStream> getMediaStream() async {
    return await navigator.mediaDevices.getUserMedia({
      'audio': true,
      // 'video': true,
      'video': {
        'minWidth': '640',
        'minHeight': '480',
        'minFrameRate': '24',
        'facingMode': 'user',
        'optional': [],
      }
    });
  }

  Future<RTCPeerConnection> createPeerConnections() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    };

    final pc = await createPeerConnection(configuration, offerSdpConstraints);

    return pc;
  }

  Future<RTCSessionDescription?> createOffer(RTCPeerConnection pc) async {
    final offer = await pc.createOffer(offerSdpConstraints);

    await pc.setLocalDescription(offer);

    return pc.getLocalDescription();
  }

  Future<RTCSessionDescription?> createAnswer(RTCPeerConnection pc) async {
    final answer = await pc.createAnswer();

    await pc.setLocalDescription(answer);

    return pc.getLocalDescription();
  }

  Future<void> setRemoteDescription(
      RTCPeerConnection pc, RTCSessionDescription remoteDescription) async {
    await pc.setRemoteDescription(remoteDescription);
  }

  Future<void> addCandidate(
      RTCPeerConnection pc, RTCIceCandidate candidate) async {
    await pc.addCandidate(candidate);
  }

  Future<void> close(RTCPeerConnection pc) async {
    await pc.close();
  }

  Future<RTCIceCandidate> createIceCandidate(RTCIceCandidate candidate) async {
    return RTCIceCandidate(
      candidate.candidate,
      candidate.sdpMid,
      candidate.sdpMLineIndex,
    );
  }

  Future<RTCIceCandidate> createIceCandidateFromMap(
      Map<String, dynamic> candidateMap) async {
    return RTCIceCandidate(
      candidateMap['candidate'],
      candidateMap['sdpMid'],
      candidateMap['sdpMLineIndex'],
    );
  }

  Future<RTCSessionDescription> createRTCSessionDescription(
      Map<String, dynamic> sessionDescriptionMap) async {
    return RTCSessionDescription(
        sessionDescriptionMap['sdp'], sessionDescriptionMap['type']);
  }

  Future<RTCSessionDescription> createRTCSessionDescriptionFromMap(
      Map<String, dynamic> sessionDescriptionMap) async {
    return RTCSessionDescription(
        sessionDescriptionMap['sdp'], sessionDescriptionMap['type']);
  }

  // Future<RTCDataChannel> createDataChannel(RTCPeerConnection pc, String label,
  //     RTCDataChannelInit dataChannelDict) async {
  //   return pc.createDataChannel(label, data: dataChannelDict);
  // }

  // Future<RTCDataChannel> createDataChannelFromMap(
  //     Map<String, dynamic> dataChannelMap) async {
  //   return RTCDataChannel.fromMap(dataChannelMap);
  // }
}
