import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:linyu_mobile/api/chat_list_api.dart';
import 'package:linyu_mobile/api/msg_api.dart';
import 'package:linyu_mobile/api/video_api.dart';
import 'package:linyu_mobile/components/CustomDialog/index.dart';
import 'package:linyu_mobile/components/custom_flutter_toast/index.dart';
import 'package:linyu_mobile/utils/web_socket.dart';

class VideoChatLogic extends GetxController {
  final _chatListApi = ChatListApi();
  final _wsManager = WebSocketUtil();
  final _videoApi = VideoApi();
  final _msgApi = MsgApi();
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late String userId;
  late bool isOnlyAudio;
  late bool isSender;
  late dynamic userInfo = {};
  bool toUserIsReady = false;
  Timer? timer;
  RxInt time = 0.obs;
  StreamSubscription? _subscription;
  RxBool isRemoteFullScreen = false.obs;
  RxBool isVideoEnabled = true.obs;
  RxBool isAudioEnabled = true.obs;
  late final Rx<Offset> smallWindowOffset;

  late RTCPeerConnection peerConnection;
  late MediaStream webcamStream;

  @override
  void onInit() async {
    super.onInit();
    userId = Get.arguments['userId'];
    isOnlyAudio = Get.arguments['isOnlyAudio'];
    isSender = Get.arguments['isSender'];
    smallWindowOffset = Offset(Get.size.width - 116, 16).obs;
    await onGetChatDetail();
    await initializeRenderers();
    await initRTCPeerConnection();
    await videoCall();
    videoEvent();
  }

  Future<void> onGetChatDetail() async {
    _chatListApi.detail(userId, 'user').then((res) {
      if (res['code'] == 0) {
        userInfo = res['data'];
        update([const Key('video_chat')]);
      }
    });
  }

  void updateSmallWindowPosition(Offset delta) {
    final screenSize = Get.size;

    // 计算新的位置
    double newX = smallWindowOffset.value.dx + delta.dx;
    double newY = smallWindowOffset.value.dy + delta.dy;

    // 确保小窗口不会超出屏幕边界
    newX = newX.clamp(0, screenSize.width - 100); // 100是小窗口的宽度
    newY = newY.clamp(0, screenSize.height - 150); // 150是小窗口的高度

    // 更新位置
    smallWindowOffset.value = Offset(newX, newY);
  }

  void videoEvent() {
    _subscription = _wsManager.eventStream.listen((event) {
      if (event['type'] == 'on-receive-video') {
        var data = event['content'];
        switch (data['type']) {
          case 'offer':
            handleVideoOfferMsg(data);
            break;
          case 'answer':
            handleVideoAnswerMsg(data);
            break;
          case 'candidate':
            handleNewICECandidateMsg(data);
            break;
          case 'hangup':
            handlerDestroyTime();
            CustomFlutterToast.showErrorToast('对方已挂断~');
            Get.back();
            break;
          case 'accept':
            onOffer();
            break;
        }
      }
    });
  }

  Future<void> handleVideoOfferMsg(data) async {
    final RTCSessionDescription desc =
        RTCSessionDescription(data['desc']['sdp'], data['desc']['type']);
    await peerConnection.setRemoteDescription(desc);
    RTCSessionDescription localDesc = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(localDesc);
    _videoApi.answer(userId, {'sdp': localDesc.sdp, 'type': localDesc.type});
  }

  Future<void> handleVideoAnswerMsg(data) async {
    try {
      final RTCSessionDescription remoteDesc = RTCSessionDescription(
        data['desc']['sdp'],
        data['desc']['type'],
      );
      await peerConnection.setRemoteDescription(remoteDesc);
    } catch (e) {
      print('Error in handleVideoAnswerMsg: $e');
    }
  }

  Future<void> handleNewICECandidateMsg(data) async {
    try {
      final RTCIceCandidate candidate = RTCIceCandidate(
        data['candidate']['candidate'],
        data['candidate']['sdpMid'],
        data['candidate']['sdpMLineIndex'],
      );
      await peerConnection.addCandidate(candidate);
    } catch (e) {
      print('Error in handleNewICECandidateMsg: $e');
    }
  }

  Future<void> onOffer() async {
    try {
      RTCSessionDescription offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);
      await _videoApi.offer(userId, {'sdp': offer.sdp, 'type': offer.type});
    } catch (e) {
      print('Error in onOffer: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    _subscription?.cancel();
    localRenderer.dispose();
    remoteRenderer.dispose();
    webcamStream.dispose();
    peerConnection.close();
  }

  Future<void> initializeRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> videoCall() async {
    try {
      // 获取用户媒体流（音频和视频）
      webcamStream = await webrtc.navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': !isOnlyAudio, // 如果是音频通话，则禁用视频
      });

      localRenderer.srcObject = webcamStream;
      // 如果是音频通话，禁用视频轨道
      if (isOnlyAudio) {
        webcamStream.getVideoTracks().forEach((track) {
          track.enabled = false;
        });
      }
      // 将所有的轨道添加到 PeerConnection
      webcamStream.getTracks().forEach((track) {
        peerConnection?.addTrack(track, webcamStream!);
      });
    } catch (e) {
      print('Error in videoCall: $e');
    }
  }

  Future<void> initRTCPeerConnection() async {
    // 配置 ICE 服务器
    final Map<String, dynamic> iceServer = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {
          'urls': 'turn:numb.viagenie.ca',
          'username': 'webrtc@live.com',
          'credential': 'muazkh',
        },
      ],
    };

    // 创建 PeerConnection
    peerConnection = await createPeerConnection(iceServer);
    // 设置 ICE 候选者事件处理
    peerConnection.onIceCandidate = handleICECandidateEvent;
    // 设置 ICE 连接状态更改事件处理
    peerConnection.onIceConnectionState = handleICEConnectionStateChangeEvent;
    // 设置 Track 事件处理
    peerConnection.onTrack = handleTrackEvent;
  }

  Future<void> handleICECandidateEvent(RTCIceCandidate candidate) async {
    if (candidate != null) {
      await _videoApi.candidate(userId, {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    }
  }

  void handleICEConnectionStateChangeEvent(RTCIceConnectionState? state) {
    toUserIsReady = true;
    handlerDestroyTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      time.value = time.value + 1;
    });
  }

  void handleTrackEvent(RTCTrackEvent event) {
    remoteRenderer.srcObject = event.streams[0];
    update([const Key('video_chat')]);
  }

  void handlerDestroyTime() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      timer = null;
    }
  }

  void onAccept() async {
    _videoApi.accept(userId).then((res) {
      if (res['code'] == 0) {
        toUserIsReady = true;
      }
    });
  }

  void onHangup() async {
    Map<String, dynamic> msg = {
      'toUserId': userId,
      'msgContent': {
        'type': 'call',
        'content': jsonEncode(
            {'type': isOnlyAudio ? "audio" : "video", 'time': time.value}),
      }
    };
    _msgApi.send(msg).then((res) {
      if (res['code'] == 0) {
        WebSocketUtil.eventController
            .add({'type': 'on-receive-msg', 'content': res['data']});
      }
    }).whenComplete(() {
      _videoApi.hangup(userId).then((res) {
        Get.back();
      });
    });
  }

  void toggleVideo() {
    isVideoEnabled.value = !isVideoEnabled.value;
    webcamStream.getVideoTracks().forEach((track) {
      track.enabled = isVideoEnabled.value;
    });
  }

  void toggleAudio() {
    isAudioEnabled.value = !isAudioEnabled.value;
    webcamStream.getAudioTracks().forEach((track) {
      track.enabled = isAudioEnabled.value;
    });
  }

  void showExitConfirmDialog(context) {
    CustomDialog.showTipDialog(context, text: "确定将结束本次通话，是否继续?", onOk: () {
      onHangup();
      Get.back();
    }, onCancel: () {});
  }
}
