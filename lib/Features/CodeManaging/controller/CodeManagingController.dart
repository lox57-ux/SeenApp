import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeManagingController extends GetxController {
  RxBool isLoading = false.obs;
  RxString messege = ''.obs;
  IconData icon = Icons.error_outline;
  resetMessege() {
    messege.value = '';
  }

  updateLoadingState() {
    isLoading.value = !isLoading.value;
  }
}
