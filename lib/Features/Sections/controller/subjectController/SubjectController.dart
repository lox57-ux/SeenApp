import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../../core/functions/ActiveCodeFunction.dart';
import '../../../../core/functions/localDataFunctions/ActiveCoupon.dart';
import '../../../../core/functions/localDataFunctions/indexedSubjectsFunction.dart';

import '../../../CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../../../CodeManaging/model/classes/ActiveCouponsLocal.dart';
import '../../model/classes/IndexedSubjects.dart';
import '../../model/classes/SubjectModule.dart';

class SubjectController extends GetxController
    with GetTickerProviderStateMixin {
  //RefreshController refreshController = Get.put(RefreshController());
  RxString? questionsLanguage = "عربي".obs;
  bool animateIt = false;
  late AnimationController? animationController;

  checkSubscription(Subject data) async {
    int numOFDisabeledcodes = 0;
    /* checks if user had active code or coupons for this subject or not  */
    List<ActiveCodesLocal>? a = await getActiveCodeForSubject(data.id!);

    if (a != null) {
      for (var valid in a) {
        List<ActiveCodesLocal>? b = await isValidCode(valid.id!);

        if (b != null && b.isNotEmpty) {
        } else {
          numOFDisabeledcodes++;
        }
      }
    }
    int numOFDisabeledcoupons = 0;
    List<ActiveCouponsLocal>? acCoupon =
        await getActiveCouponForSubject(data.id!);

    if (acCoupon != null) {
      for (var validc in acCoupon) {
        List<ActiveCouponsLocal>? bcoupoun = await isValidCoupon(validc.id!);

        if (bcoupoun != null) {
        } else {
          numOFDisabeledcoupons++;
        }
      }
    }

    if (data.subject_code != null && data!.subject_coupon == null) {
      if (numOFDisabeledcodes >= data!.subject_code!) {
        stopAstartAnimation();
        //   refreshController.update();
        await Future.delayed(const Duration(milliseconds: 100));
        stopAstartAnimation();

        Get.nestedKey(1)!.currentState!.pushNamed(
              '/notAmember',
            );
      } else {
        //here if the subject is active for user we first get
        // the length of the indexed and reorder it
        //(note we check first if the subject is already inserted or not if not we insert then reorder with update function)
        var indexedLentgh = await getIndexedSubjects();
        List<IndexedSubject?>? a = await getIndexedSubject(data!.id!);

        if (a != null) {
          updateIndex(IndexedSubject(
              id: data!.id,
              language: data!.language,
              hasUnloackedSub: data.hasUnloackedSub,
              has_data: data.has_data,
              open_subject: data.open_subject,
              subjectName: data.subjectName,
              subject_coupon: data.subject_coupon,
              subject_code: data.subject_code));
        } else {
          insertIndexed(
              data!, indexedLentgh == null ? 0 : indexedLentgh!.length);
          updateIndex(IndexedSubject(
              id: data!.id,
              hasUnloackedSub: data.hasUnloackedSub,
              has_data: data.has_data,
              open_subject: data.open_subject,
              language: data!.language,
              subjectName: data.subjectName,
              subject_coupon: data.subject_coupon,
              subject_code: data.subject_code));
        }

        Get.nestedKey(1)!.currentState!.pushNamed('/SubSubjects', arguments: {
          'id': data!.id!,
          'subject_name': data.subjectName!,
          'isLocked': !data.open_subject!
        });
      }
    } else if (data.subject_code == null && data!.subject_coupon != null) {
      if (numOFDisabeledcoupons >= data.subject_coupon!) {
        stopAstartAnimation();
        //  refreshController.update();
        await Future.delayed(const Duration(milliseconds: 100));
        stopAstartAnimation();

        Get.nestedKey(1)!.currentState!.pushNamed(
              '/notAmember',
            );
      } else {
        var indexedLentgh = await getIndexedSubjects();
        List<IndexedSubject?>? a = await getIndexedSubject(data!.id!);

        if (a != null) {
          updateIndex(IndexedSubject(
              id: data!.id,
              subject_coupon: data.subject_coupon,
              language: data!.language,
              hasUnloackedSub: data.hasUnloackedSub,
              has_data: data.has_data,
              open_subject: data.open_subject,
              subjectName: data.subjectName,
              subject_code: data.subject_code));
        } else {
          insertIndexed(
              data!, indexedLentgh == null ? 0 : indexedLentgh!.length);
          updateIndex(IndexedSubject(
              subject_coupon: data.subject_coupon,
              id: data!.id,
              language: data!.language,
              subjectName: data.subjectName,
              hasUnloackedSub: data.hasUnloackedSub,
              has_data: data.has_data,
              open_subject: data.open_subject,
              subject_code: data.subject_code));
        }

        Get.nestedKey(1)!.currentState!.pushNamed('/SubSubjects', arguments: {
          'id': data!.id!,
          'subject_name': data.subjectName!,
          'isLocked': !data.open_subject!
        });
      }
    } else if (data.subject_code != null && data!.subject_coupon != null) {
      if (numOFDisabeledcodes >= data.subject_code! ||
          numOFDisabeledcoupons >= data!.subject_coupon! ||
          (numOFDisabeledcodes >= data!.subject_code! &&
              numOFDisabeledcoupons >= data!.subject_coupon!)) {
        stopAstartAnimation();
        //  refreshController.update();
        await Future.delayed(const Duration(milliseconds: 100));
        stopAstartAnimation();

        Get.nestedKey(1)!.currentState!.pushNamed(
              '/notAmember',
            );
      } else {
        var indexedLentgh = await getIndexedSubjects();
        List<IndexedSubject?>? a = await getIndexedSubject(data!.id!);

        if (a != null) {
          updateIndex(IndexedSubject(
              id: data!.id,
              language: data!.language,
              hasUnloackedSub: data.hasUnloackedSub,
              has_data: data.has_data,
              open_subject: data.open_subject,
              subject_coupon: data.subject_coupon,
              subjectName: data!.subjectName,
              subject_code: data.subject_code));
        } else {
          insertIndexed(
              data!, indexedLentgh == null ? 0 : indexedLentgh!.length);
          updateIndex(IndexedSubject(
              id: data!.id,
              language: data!.language,
              subject_coupon: data.subject_coupon,
              hasUnloackedSub: data.hasUnloackedSub,
              has_data: data.has_data,
              open_subject: data.open_subject,
              subjectName: data.subjectName,
              subject_code: data.subject_code));
        }

        Get.nestedKey(1)!.currentState!.pushNamed('/SubSubjects', arguments: {
          'id': data!.id!,
          'subject_name': data.subjectName!,
          'isLocked': data.open_subject!
        });
      }
    } else {
      stopAstartAnimation();
      // refreshController.update();
      await Future.delayed(const Duration(milliseconds: 100));
      stopAstartAnimation();

      Get.nestedKey(1)!.currentState!.pushNamed(
            '/notAmember',
          );
    }
  }

  stopAstartAnimation() {
    animateIt = !animateIt;
    update();
  }

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    super.onInit();
  }

  @override
  void onClose() {
    animationController!.dispose();
    super.onClose();
  }
}
