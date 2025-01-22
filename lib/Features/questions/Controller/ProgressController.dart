import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Progresscontroller extends GetxController {
  double x = 0;
  double progress = 0.0;
  calculateProgressPrecentage(int length, int? index) {
    x = 330.w / length;
    if (index != null && index > 0) {
      progress = x * (index + 1);
    } else {
      progress = x;
    }
  }

  increaseProgress() {
    progress += x;
    update();
  }

  increaseProgressByValue(int val) {
    progress = x;
    progress += val * x;
    update();
  }

  decreaseProgressByValue(int val) {
    progress -= val * x;
    update();
  }

  decreaseProgress() {
    progress -= x;
    update();
  }
}
