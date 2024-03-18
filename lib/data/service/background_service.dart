import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:social_media_app/cubit/message/message_bloc.dart';
import 'package:social_media_app/cubit/video_call/video_call_cubit.dart';
import 'package:social_media_app/repositories/socket_repo.dart';

class BackgroundService {
  static final _service = FlutterBackgroundService();
  static late VideoCallCubit _videoCallCubit;
  static late ChatBloc _chatBloc;

  static initializeService() async {
    await _service.configure(
      iosConfiguration: IosConfiguration(autoStart: false),
      androidConfiguration: AndroidConfiguration(
        isForegroundMode: false,
        autoStart: false,
        autoStartOnBoot: false,
        onStart: _onStart,
      ),
    );
  }

  static startService(ChatBloc chatBloc, VideoCallCubit videoCallCubit) async {
    if (await _service.isRunning()) {
      _service.invoke('stopService');
    }
    _chatBloc = chatBloc;
    _videoCallCubit = videoCallCubit;
    await _service.startService();
  }

  @pragma('vm:entry-point')
  static _onStart(ServiceInstance service) async {
    // service.onDataReceived.listen((event) {
    //   if (event["action"] == "setRoomId") {
    //     _videoCallCubit.setRoomId(event["roomId"]);
    //   }
    // });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    print('STARTING SERVICE');
    // start listening for incoming calls and messages
    SocketClient.instance().connect();
    print('SERVICE CONNECTS SOCKET');
    // register a callback function to handle incoming messages
    // _chatBloc.registerChatListeners();
    // _videoCallCubit.init();
  }
}
