import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/controller/text_controller.dart';

import 'package:seen/core/Services/Network.dart';
import 'package:seen/core/constants/url.dart';

import 'package:http/http.dart' as http;
import 'package:seen/Features/Sections/model/classes/SubjectModule.dart';

import '../../../../core/constants/TextStyles.dart';
import '../../../../core/functions/ActiveCodeFunction.dart';
import '../../../../core/functions/QuestionFunction.dart';
import '../../../../core/functions/localDataFunctions/SubjectFunctions.dart';
import '../../../../core/functions/localDataFunctions/SubsubjectsFunction.dart';
import '../../../CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../classes/SubSubjects.dart';

class SubjectDataSource {
  static SubjectDataSource instance = SubjectDataSource();
  Function eq = const ListEquality().equals;
  TextController textController = Get.find();
  List<Map<String, dynamic>> subID = [];
  Future<List<Subject>?> get_All_Subjects() async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId, "token": token});

    if (await checkConnection()) {
      try {
        // deleteAllIndexedSubjects();
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/user/get-my-subjects/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);
        var unlockedResponse = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/user/get-my-subjects-with-unlocked/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        List<Subject?>? localSubject = await getSubjects();

        List<Subject> subjects =
            (jsonDecode(response.body)).map<Subject>((ele) {
          if (ele["codes"] != null && ele["codes"].isNotEmpty) {
            return Subject.fromJson(ele, true);
          } else if (ele["coupons"] != null && ele["coupons"].isNotEmpty) {
            return Subject.fromJson(ele, true);
          } else {
            return Subject.fromJson(ele, false);
          }
        }).toList();

        List<Subject>? activeSubjects = await get_Active_Subjects();
        // List<Subject> comparisonList = subjects.where((element) => false);
        if (activeSubjects != null && activeSubjects.isNotEmpty) {
          for (var active in activeSubjects!) {
            Subject? tempSub = subjects.firstWhere(
                (element) => element.id == active.id,
                orElse: () => Subject());
            if (tempSub.id != null) {
            } else {
              if (textController.pref!.getInt('yearID') != null) {
                if (active.yearId == textController.pref!.getInt('yearID')) {
                  subjects.add(active);
                }
              } else {
                if (active.yearId == null) {
                  subjects.add(active);
                }
              }
            }
          }
        }
        List<dynamic> decodedUnloackedRes = jsonDecode(unlockedResponse.body);
        await deleteAllSubjects();
        await Future.forEach(subjects, (ele) async {
          Map<String, dynamic>? elem = decodedUnloackedRes.firstWhereOrNull(
            (element) => element['id'] == ele.id,
          );

          if (elem != null) {
            if (elem['coupons'].isNotEmpty ||
                elem['codes'].isNotEmpty ||
                (elem['coupons'].isNotEmpty && elem['codes'].isNotEmpty)) {
              Subject temp = ele;
              if (elem['sub_subjects'].isNotEmpty) {
                for (var sub in elem['sub_subjects']) {
                  subID.add(
                      {'id': sub['id'], 'is_unlocked': sub['is_unlocked']});
                }
                temp.hasUnloackedSub = true;
              } else {
                temp.hasUnloackedSub = false;
              }
              if (await checkQuestionWithAnswersForSubject(ele.id!) == 1) {
                temp.open_subject = true;
                temp.has_data = true;

                await insert(temp);
              } else {
                await insert(ele);
              }
            } else if (elem['sub_subjects'].isNotEmpty) {
              for (var sub in elem['sub_subjects']) {
                subID.add({'id': sub['id'], 'is_unlocked': sub['is_unlocked']});
              }
              if (await checkQuestionWithAnswersForSubject(ele.id!) == 1) {
                Subject temp = ele;
                temp.open_subject = false;
                temp.has_data = true;
                temp.hasUnloackedSub = true;

                await insert(temp);
              } else {
                Subject temp = ele;
                temp.open_subject = false;
                temp.has_data = false;
                temp.hasUnloackedSub = true;

                await insert(temp);
              }
            } else {
              if (await checkQuestionWithAnswersForSubject(ele.id!) == 1) {
                Subject temp = ele;
                temp.open_subject = false;
                temp.has_data = true;
                temp.hasUnloackedSub = false;
                await insert(temp);
              } else {
                await insert(ele);
              }
            }
          } else {
            if (await checkQuestionWithAnswersForSubject(ele.id!) == 1) {
              Subject temp = ele;
              temp.open_subject = true;
              temp.has_data = true;
              temp.hasUnloackedSub = true;
              await insert(temp);
            } else {
              await insert(ele);
            }
          }

          return ele;
        });

        return subjects;
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }

  Future<List<Subject>?> get_Active_Subjects() async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId, "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/user/get-active-subjects/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        List<Subject> subjects =
            (jsonDecode(response.body)).map<Subject>((ele) {
          if (ele["codes"] != null) {
            return Subject.fromJson(ele, true);
          } else if (ele["coupons"] != null) {
            return Subject.fromJson(ele, true);
          } else {
            return Subject.fromJson(ele, false);
          }
        }).toList();
        deleteAllActiveCodes();

        jsonDecode(response.body).forEach((element) {
          if (element["codes"] != null) {
            element["codes"].forEach((e) async {
              await insertActiveCode(ActiveCodesLocal(
                  dateOfActivation: e['date_of_activation'],
                  endDate: DateTime.parse(e['date_of_activation'])
                      .add(Duration(days: e["expiry_time"]))
                      .toString(),
                  name: e['code_name'],
                  expiryTime: e["expiry_time"],
                  id: e['id'],
                  isActive: e["is_active"],
                  subjectId: element["id"],
                  userId: e["user_id"]));
            });
          }
          // if( element["coupons"]!=null){
          //       element["coupons"].forEach((e) async {
          //       await insertActiveCode(ActiveCodesLocal(
          //           dateOfActivation: e['date_of_activation'],
          //           endDate: DateTime.parse(e['date_of_activation'])
          //               .add(Duration(days: e["expiry_time"]))
          //               .toString(),
          //           name: e['coupon_content'],
          //           expiryTime: e["expiry_time"],
          //           id: e['id'],
          //           isActive: e["is_active"],
          //           subjectId: element["id"],
          //           userId: e["user_id"]));
          //     });
          // }
        });
        return subjects;
      } catch (e) {}
    } else {
      Get.defaultDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
    }
  }

  Future<Subject?> get_Subject(int subjectID) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId, "token": token});

    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/subject/get-subject/$subjectID'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        Subject subject = Subject.fromJson((jsonDecode(response.body)), false);

        return subject;
      } catch (e) {}
    } else {
      Get.defaultDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
    }
  }

  Future<List<SubSubject>> get_Sub_Subjects_of_subjects(int? id) async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId!, "token": token});
    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse(
                '${baseUrl}houdix/seen/app/sub-subject/get-subs-of-subject/$id'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        List<SubSubject?>? localSubSubject = await getSubSubjects();
        List<SubSubject> subSubjects = (json.decode(response.body))
            .map<SubSubject>((ele) => SubSubject.fromJson(
                  ele,
                  false,
                ))
            .toList();

        subSubjects.map((ele) async {
          if (ele.isLatex!) {
            print("object");
          }
          print("${ele.isLatex!}");
          await deleteSubSubjects(ele.id!);
          await insertSubsubject(ele);
        }).toList();

        return subSubjects;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      Get.defaultDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: 'لا يوجد اتصال',
        titleStyle: ownStyle(Colors.red, 16.5),
        content: Text(
          'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
          textAlign: TextAlign.center,
          style: ownStyle(Get.theme.primaryColor, 14.5),
        ),
      );
      return [];
    }
  }

  Future<List<SubSubject?>?> get_AllSub_Subjects() async {
    int uId = textController.pref!.getInt('u_id')!;
    String token = textController.pref!.getString('token')!;
    var encodedBody = json.encode({"user_id": uId!, "token": token});
    if (await checkConnection()) {
      try {
        var response = await http.put(
            Uri.parse('${baseUrl}houdix/seen/app/user/get-user-subs/$uId'),
            headers: {'Content-Type': 'application/json'},
            body: encodedBody);

        List<SubSubject?>? localSubSubject = await getSubSubjects();

        try {
          List<SubSubject> subSubjects =
              (json.decode(response.body)).map<SubSubject>((ele) {
            return SubSubject.fromJson(ele, false);
          }).toList();

          deleteAllSubSubjects();
          await Future.forEach(subSubjects, (ele) async {
            SubSubject? sub = subSubjects.firstWhereOrNull(
                (element) => (element!.fatherId == ele.id) && ele.isUnlocked!);
            var subTemp = subID.firstWhereOrNull(
              (element) => element['id'] == ele.id,
            );
            if (subTemp != null) {
              ele.isUnlocked = subTemp['is_unlocked'];

              if (await checkQuestionWithAnswersForSubSubject(ele.id!) == 1) {
                SubSubject temp = ele;
                temp.open_sub_subject = true;
                temp.has_data = true;
                temp.isUnlocked = true;
                await insertSubsubject(temp);
              } else {
                SubSubject temp = ele;
                temp.open_sub_subject = true;
                temp.has_data = false;
                temp.isUnlocked = true;

                await insertSubsubject(temp);
              }
            } else {
              if (await checkQuestionWithAnswersForSubSubject(ele.id!) == 1) {
                SubSubject temp = ele;
                temp.open_sub_subject = true;
                temp.has_data = true;
                if (sub != null) {
                  temp.isUnlocked = true;
                }
                await insertSubsubject(temp);
              } else {
                SubSubject temp = ele;
                temp.open_sub_subject = true;
                temp.has_data = false;
                if (sub != null) {
                  temp.isUnlocked = true;
                }

                await insertSubsubject(temp);
              }
            }

            return ele;
          });

          return subSubjects;
        } catch (e) {
          debugPrint(e.toString());
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {}
  }
}
