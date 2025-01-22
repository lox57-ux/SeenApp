import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/Features/introPages/model/data/UniversitiesDataSource.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/localDataFunctions/indexedSubjectsFunction.dart';

import '../../introPages/model/classes/AuthResponse.dart';
import '../../introPages/model/classes/Years.dart';
import '../../introPages/model/data/UsersDataSource.dart';

import '../../Sections/Screens/ChooseSubject.dart';

class SelectLevelController extends GetxController {
  SharedPreferences? pref;
  String? selectType;
  RxBool isloading = false.obs;
  RxString show = 'bachelor'.obs;
  String? selectedCounty;
  int? selectedYear;
  int? universityId;
  int? collageId;
  List<String> bachelorSection = ['علمي', 'أدبي'];
  List genders = ['ذكر', 'أنثى'];
  List county = [
    'اللاذقية',
    'حمص',
    'دمشق',
    'طرطوس',
    'حلب',
    'حماة',
    'إدلب',
    'ريف دمشق',
    'درعا',
    'دير الزور',
    'الرقة',
    'القنيطرة',
    'الحسكة',
    'السويداء',
  ];
  List<Years> years = [];
  String? selectedBachelorSection;
  String? selectedGender;
  setBachelorSection(txt) {
    selectedBachelorSection = txt;
    update();
  }

  setCounty(txt) {
    selectedCounty = txt;
    update();
  }

  setGender(txt) {
    selectedGender = txt;
    update();
  }

  setYear(txt) {
    selectedYear = txt;
    update();
  }

  setUniversity(txt) {
    universityId = txt;
    update();
  }

  setCollage(txt) {
    collageId = txt;
    update();
  }

  List<University> universities = [];
  List<Collage> collages = [];

  setSelect(txt) {
    selectType = txt;
    update();
  }

  setUniversities() async {
    universities = await UniversitiesDataSource.instace.getAllUniversities();
    update();
  }

  setCollageForUniversity(int uniID) async {
    collages = [];
    collageId = null;
    collages =
        await UniversitiesDataSource.instace.getCollageOfUniversity(uniID);
    update();
  }

  setYeasrForCollage(int collageId) async {
    years = [];
    selectedYear = null;
    years = await UniversitiesDataSource.instace.getYearsOfCollage(collageId);
    update();
  }

  // setBachelorTypeList() async {
  //   bachelorSection = await UniversitiesDataSource.instace.getbachelorsTypes();
  //   update();
  // }

  saveInfo({required name, bool? isUpdate}) async {
    pref = await SharedPreferences.getInstance();

    await pref!.setString('Name', name);

    if (selectType == "بكالوريا") {
      await pref!.setString('county', selectedCounty!);
      await pref!.setString('section', selectType!);
      await pref!.setString('bSection', selectedBachelorSection!);
      await UserDataSource.instance.addbachelore({
        "token": pref!.getString('token'),
        "bachelor_name": selectedBachelorSection,
        "state": selectedCounty
      }, pref!.getInt('u_id')).then((value) async {
        if (value.messege == null) {
          if (isUpdate != null) {
            Get.snackbar('', '',
                backgroundColor: Colors.white,
                colorText: SeenColors.rightAnswer,
                titleText: Text(
                  ' تم التعديل بنجاح ',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 18.sp),
                ),
                messageText: Text(
                  ' الرجاء تحديث البيانات',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 15.sp),
                ),
                duration: const Duration(milliseconds: 1300));
            await Future.delayed(const Duration(milliseconds: 2400));
            await pref!.remove('yearID');
            await pref!.remove('subjectYearID');
            await deleteAllIndexedSubjects();
            Get.back();
          } else {
            Get.offNamed(ChooseSubject.routeName);
          }
        }
      });
    } else if (selectType! == "السنة التحضيرية") {
      int? tempID;
      int? tempYearID;
      await setCollageForUniversity(universityId!);
      for (var element in collages) {
        if (element.collageName!.contains('البشري')) {
          tempID = element.id;
        }
      }
      if (tempID != null) {
        await setYeasrForCollage(tempID!);
        for (var el in years) {
          if (el.yearName == 'تحضيرية') {
            tempYearID = el.id;
          }
        }
        if (tempYearID == null) {
          Get.snackbar(' ', '',
              backgroundColor: Colors.white,
              titleText: Text(
                ' يرجى التأكد من الكلية ',
                style: ownStyle(Colors.red, 18.sp),
              ),
              messageText: Text(
                '   لا توجد السنة التحضيرية في الجامعة المختارة',
                style: ownStyle(Colors.red, 15.sp),
              ),
              duration: const Duration(milliseconds: 1300));
          isloading.value = false;
          throw Exception();
        } else {
          await pref!.setInt('yearID', tempYearID!);

          await pref!.setInt('collageId', tempID!);
        }
      } else {
        Get.snackbar(' ', '',
            backgroundColor: Colors.white,
            titleText: Text(
              ' يرجى التأكد من الجامعة ',
              style: ownStyle(Colors.red, 18.sp),
            ),
            messageText: Text(
              '   لا توجد كلية الطب في الجامعة المختارة',
              style: ownStyle(Colors.red, 15.sp),
            ),
            duration: const Duration(milliseconds: 1300));
        isloading.value = false;
        throw Exception();
      }

      await UserDataSource.instance.addStudent({
        "token": pref!.getString('token'),
        "student_number": null,
        "year_id": tempYearID,
      }, pref!.getInt('u_id')).then((value) async {
        if (value.messege == null) {
          await pref!.setString('section', selectType!);
          await pref!.setInt('university', universityId!);
          await pref!.setInt('subjectYearID', value.subjectYear!);
          if (isUpdate != null) {
            Get.snackbar(' ', '',
                backgroundColor: Colors.white,
                titleText: Text(
                  ' تم التعديل بنجاح ',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 18.sp),
                ),
                messageText: Text(
                  ' الرجاء تحديث البيانات',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 15.sp),
                ),
                colorText: SeenColors.rightAnswer,
                duration: const Duration(milliseconds: 1300));

            await Future.delayed(const Duration(milliseconds: 2400));
            await deleteAllIndexedSubjects();
            Get.back();
          } else {
            Get.offNamed(ChooseSubject.routeName);
          }
        }
      });
    } else if (selectType == 'السنوات الانتقالية') {
      await UserDataSource.instance.addStudent({
        "token": pref!.getString('token'),
        "student_number": null,
        "year_id": selectedYear
      }, pref!.getInt('u_id')).then((value) async {
        if (value.messege == null) {
          await pref!.setString('section', selectType!);
          await pref!.setInt('university', universityId!);
          await pref!.setInt('yearID', selectedYear!);
          await pref!.setInt('subjectYearID', value.subjectYear!);
          await pref!.setInt('collageId', collageId!);
          if (isUpdate != null) {
            Get.snackbar('', '',
                backgroundColor: Colors.white,
                titleText: Text(
                  ' تم التعديل بنجاح ',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 18.sp),
                ),
                messageText: Text(
                  ' الرجاء تحديث البيانات',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 15.sp),
                ),
                colorText: SeenColors.rightAnswer,
                duration: const Duration(milliseconds: 1300));
            await Future.delayed(const Duration(milliseconds: 2400));
            await pref!.setInt('yearID', selectedYear!);
            await deleteAllIndexedSubjects();
            Get.back();
          } else {
            Get.offNamed(ChooseSubject.routeName);
          }
        }
      });
    } else if (selectType! == 'السنة السادسة') {
      int? tempID;
      int? tempYearID;
      await setCollageForUniversity(universityId!);
      for (var element in collages) {
        if (element.collageName!.contains('البشري')) {
          tempID = element.id;
        }
      }
      if (tempID != null) {
        await setYeasrForCollage(tempID!);
        for (var el in years) {
          if (el.yearName == 'السادسة') {
            tempYearID = el.id;
          }
        }
        if (tempYearID == null) {
          Get.snackbar(' ', '',
              backgroundColor: Colors.white,
              titleText: Text(
                ' يرجى التأكد من الكلية ',
                style: ownStyle(Colors.red, 18.sp),
              ),
              messageText: Text(
                '   لا توجد سنة سادسة في الجامعة المختارة',
                style: ownStyle(Colors.red, 15.sp),
              ),
              duration: const Duration(milliseconds: 1300));
          isloading.value = false;
          throw Exception();
        } else {
          await pref!.setInt('yearID', tempYearID!);
          await pref!.setInt('collageId', tempID!);
        }
      } else {
        Get.snackbar(' ', '',
            backgroundColor: Colors.white,
            titleText: Text(
              ' يرجى التأكد من الجامعة ',
              style: ownStyle(Colors.red, 18.sp),
            ),
            messageText: Text(
              '   لا توجد كلية الطب في الجامعة المختارة',
              style: ownStyle(Colors.red, 15.sp),
            ),
            duration: const Duration(milliseconds: 1300));
        isloading.value = false;
        throw Exception();
      }

      await UserDataSource.instance.addStudent({
        "token": pref!.getString('token'),
        "student_number": null,
        "year_id": tempYearID
      }, pref!.getInt('u_id')).then((value) async {
        if (value.messege == null) {
          await pref!.setString('section', selectType!);
          await pref!.setInt('university', universityId!);
          await pref!.setInt('subjectYearID', value.subjectYear!);
          if (isUpdate != null) {
            Get.snackbar('', '',
                titleText: Text(
                  ' تم التعديل بنجاح ',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 18.sp),
                ),
                backgroundColor: Colors.white,
                messageText: Text(
                  ' الرجاء تحديث البيانات',
                  style:
                      ownStyle(const Color.fromARGB(207, 83, 169, 79), 15.sp),
                ),
                colorText: SeenColors.rightAnswer,
                duration: const Duration(milliseconds: 1300));
            await Future.delayed(const Duration(milliseconds: 2400));
            await deleteAllIndexedSubjects();
            Get.back();
          } else {
            Get.offNamed(ChooseSubject.routeName);
          }
        }
      });
    }

    pref!.setString('gender', selectedGender!);
  }

  @override
  void onInit() async {
    // universities = await UniversitiesDataSource.instace.getAllUniversities();
    //bachelorSection = await UniversitiesDataSource.instace.getbachelorsTypes();

    super.onInit();
  }

  void showWidget(select) {
    if (select == "بكالوريا") {
      show.value = 'bachelor';
    } else if (select == "السنة التحضيرية") {
      show.value = 'pre';
    } else if (select == 'السنوات الانتقالية') {
      show.value = 'TransitionYears';
    } else if (select == 'السنة السادسة') {
      show.value = 'SixthYear';
    }
  }
}
