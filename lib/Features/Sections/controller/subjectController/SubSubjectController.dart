import 'package:get/get.dart';
import 'package:seen/core/functions/QuestionFunction.dart';

import '../../../../core/functions/localDataFunctions/SubsubjectsFunction.dart';
import '../../model/classes/SubSubjects.dart';

class SubSubjectController extends GetxController {
  static SubSubjectController instance = SubSubjectController();
  List<SubSubject?>? subSubjects = [];
  List<SubSubject?>? fatherSubSubjects = [];
  List<List> listo = [];
  expand(bool value, SubSubject s) {
    s.expanded = value;
    update();
  }

  Future<List<SubSubject?>?> getFathersSubject(int id) async {
    subSubjects = await getSubSubjectsForSubject(id);
    List<SubSubject?> fatherSubSubjects =
        subSubjects!.where((element) => element!.fatherId == null).toList();

    // await Future.forEach(
    //   temp,
    //   (element) async {
    //     print(1);
    //     List<SubSubject?> sub = subSubjects!
    //         .where(
    //           (elent) => element!.id == elent!.fatherId,
    //         )
    //         .toList();
    //     if (sub != null && sub.isNotEmpty) {
    //       await Future.forEach(sub, (el) {
    //         if (el!.has_data!) {
    //           print('@###############');
    //           element!.has_data = true;
    //         } else {
    //           print("object");
    //         }
    //       });
    //     }
    //     print('aaaaaaaaaaa');
    //     fatherSubSubjects!.add(element);
    //   },
    // );

    return fatherSubSubjects;
  }

  Future<List<SubSubject?>?> getFathersForFavoritesSubject(int id) async {
    subSubjects = await getSubSubjectsForSubject(id);
    List<SubSubject?>? tempSubSubjects = [];
    fatherSubSubjects = [];
    List<SubSubject?>? tempFatherSubSubjects = [];

    await Future.forEach(subSubjects!, (elemento) async {
      List? tempQs = await getFavoritesQuestionWithAnswers(elemento!.id!);

      if (tempQs != null && tempQs.isNotEmpty) {
        if (tempSubSubjects.contains(elemento)) {
        } else {
          tempSubSubjects.add(elemento);
        }
      } else {
        if (elemento.fatherId == null) {
          tempSubSubjects.add(elemento);
        }
      }
    }).then((value) {
      subSubjects = tempSubSubjects;
    });

    await Future.forEach(subSubjects!, (elmen) async {
      if (elmen!.fatherId == null) {
        if (tempFatherSubSubjects.contains(elmen)) {
        } else {
          tempFatherSubSubjects.add(elmen);
        }
      }
    }).then((value) async {
      fatherSubSubjects = [];
      for (var e in subSubjects!) {
        for (var ef in tempFatherSubSubjects) {
          if (ef!.id == e!.fatherId) {
            if (fatherSubSubjects!.contains(ef)) {
            } else {
              fatherSubSubjects!.add(ef);
            }
          }
        }
      }
    });
    fatherSubSubjects!.sort((a, b) => a!.id!.compareTo(b!.id!));

    return fatherSubSubjects;
  }

  Future<List<SubSubject?>?> getFathersForWrongSubject(int id) async {
    subSubjects = await getSubSubjectsForSubject(id);
    List<SubSubject?>? tempSubSubjects = [];
    fatherSubSubjects = [];
    List<SubSubject?>? tempFatherSubSubjects = [];

    await Future.forEach(subSubjects!, (elemento) async {
      List? tempQs = await getWrongQuestionWithAnswers(elemento!.id!);

      if (tempQs != null && tempQs.isNotEmpty) {
        if (tempSubSubjects.contains(elemento)) {
        } else {
          tempSubSubjects.add(elemento);
        }
      } else {
        if (elemento.fatherId == null) {
          tempSubSubjects.add(elemento);
        }
      }
    }).then((value) {
      subSubjects = tempSubSubjects;
    });

    await Future.forEach(subSubjects!, (elmen) async {
      if (elmen!.fatherId == null) {
        if (tempFatherSubSubjects.contains(elmen)) {
        } else {
          tempFatherSubSubjects.add(elmen);
        }
      }
    }).then((value) async {
      fatherSubSubjects = [];
      for (var e in subSubjects!) {
        for (var ef in tempFatherSubSubjects) {
          if (ef!.id == e!.fatherId) {
            if (fatherSubSubjects!.contains(ef)) {
            } else {
              fatherSubSubjects!.add(ef);
            }
          }
        }
      }
    });
    fatherSubSubjects!.sort((a, b) => a!.id!.compareTo(b!.id!));

    return fatherSubSubjects;
  }

  @override
  void onInit() {
    // SubjectDataSource.instance.get_Sub_Subjects();
    super.onInit();
  }
}
