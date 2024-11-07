
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterPageLogic extends GetxController{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late Timer _timer;
  int _countdownTime = 0;
  int get countdownTime =>_countdownTime;
  set countdownTime(int i){
    _countdownTime = i;
    super.update([const Key("countdown"),this._countdownTime!=0]);
  }

  void onTapSendMail(){
    if (countdownTime == 0) {
      //TODO Http请求发送验证码
    countdownTime = 60;
    //开始倒计时
    _startCountdownTimer();
  }
  }

  void _startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    callback(timer) => {
        if (countdownTime < 1) {
          _timer.cancel()
        } else {
          countdownTime = countdownTime - 1
        }
    };
    _timer = Timer.periodic(oneSec, callback);
  }

}
