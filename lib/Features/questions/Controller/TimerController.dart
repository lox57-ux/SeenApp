import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt minuts = 00.obs;
  RxInt seconds = 00.obs;
  bool reset = false;
  late Timer _timer;

  @override
  void onInit() async {
    // await QuestionDataSource.instance.getQuestions(1);

    super.onInit();
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 1), () {
      if (seconds.value == 60) {
        seconds.value = 0;
        minuts += 1;
        startTimer();
        update();
      } else {
        seconds += 1;
        update();
        startTimer();
      }
    });
  }

  void restartTimer() {
    _timer.cancel();
  }

  void resetTimer() {
    reset = false;
    _timer.cancel();
    minuts.value = 00;
    seconds.value = 00;
  }
}
