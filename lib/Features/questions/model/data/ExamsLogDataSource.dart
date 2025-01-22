// import 'dart:convert';

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import 'package:http/http.dart' as http;
// import 'package:seen/core/functions/QuestionFunction.dart';
// import 'package:seen/core/functions/localDataFunctions/AnsewrsFunction.dart';
// import 'package:seen/model/entites/AnswerModel.dart';
// import 'package:seen/model/entites/QuestionModel.dart';
// import 'package:sqflite/sqflite.dart';

// import '../../controller/text_controller.dart';
// import '../../core/Services/Network.dart';
// import '../../core/constants/TextStyles.dart';
// import '../../core/constants/url.dart';
// import '../../core/functions/ExamsLogFunction.dart';

// import '../LocalDataSource.dart/LocalData.dart';
// import '../entites/ExamsLog.dart';

// ///get previous from remote and insert into sql

// class ExamsLogDataSource {
//   TextController textController = Get.find();
//   Function eq = const ListEquality().equals;
//   static ExamsLogDataSource instance = ExamsLogDataSource();
//   Future<List<ExamsLog?>?> getAllExamsLog(List questionId) async {
//     int uId = textController.pref!.getInt('u_id')!;
//     String token = textController.pref!.getString('token')!;
//     var encodedBody = json.encode({"user_id": uId!, "token": token});
//     if (await checkConnection()) {
//       try {
//         var response = await http.put(
//             Uri.parse(
//                 '${baseUrl}houdix/seen/app/user/get-user-previouses/$uId'),
//             headers: {'Content-Type': 'application/json'},
//             body: encodedBody);

//         // List<ExamsLog?>? examslogLocal = await getAllExamLog();
//         // examslogLocal = examslogLocal == null ? [] : examslogLocal;

//         List<ExamsLog> examslog = (json.decode(response.body))
//             .map<ExamsLog>((ele) => ExamsLog.fromJson(ele))
//             .toList();

//         // if (eq(examslog, examslogLocal)) {
//         //   await clearExamsTable();

//         //   return <ExamsLog?>[];
//         // } else {
//         await clearExamsTable();
//         print(examslog);
//         await Future.forEach(examslog, (element) async {
//           print(element);
//           try {
//             await insertEX(ExamsLog(
//                 id: element.id,
//                 previousName: element.previousName,
//                 previousNotes: element.previousNotes,
//                 subjectId: element.subjectId));
//           } catch (e) {
//             debugPrint(e.toString());
//           }
//           for (var element2 in element.previousQuestions!) {
//             // if (questionId.contains(element2.question!.id) == false) {
//             List<AnswerForPrev> answer = [];
//             try {
//               await insertQ(
//                 QuestionModel(
//                     note: (element2.question!.notes == null ||
//                             element2.question!.notes!.isEmpty)
//                         ? null
//                         : element2.question!.notes!.first.note,
//                     isfavorite: 0,
//                     iswrong: 0,
//                     url: element2.question!.url,
//                     quesId: element2.question!.id!,
//                     quesContent: element2.question!.questionContent!,
//                     quesNotes: element2.question!.questionNotes,
//                     isMcq: element2.question!.isMcq! ? 1 : 0,
//                     subSubId: '${element.subjectId!}-',
//                     prevId: element.id),
//               );
//             } catch (e) {
//               debugPrint(e.toString());
//             }
//             answer = element2.question!.answer!;
//             for (var element3 in answer) {
//               await insertAnswer(AnswerModel(
//                 quesId: element2.question!.id,
//                 correctness: element3.correctness == true ? 1 : 0,
//                 ansNotes: element3.answerNotes,
//                 ansId: element3.id,
//                 url: element3.url,
//                 ansContent: element3.answerContent,
//               ));
//             }
//             // } else {
//             //   await updatePrevQ(element2.question!.id!, element.id!);
//             // }
//           }

//           return <ExamsLog?>[];
//         });
//       } catch (e) {
//         debugPrint(e.toString());

//         // return <ExamsLog?>[];
//       }
//     } else {}
//   }

//   // Future<List<ExamsLog>> getAllExamsLog(List questionId) async {
//   //   int uId = textController.pref!.getInt('u_id')!;
//   //   String token = textController.pref!.getString('token')!;
//   //   var encodedBody = json.encode({"user_id": uId!, "token": token});
//   //   if (await checkConnection()) {
//   //     try {
//   //       var response = await http.put(
//   //           Uri.parse(
//   //               '${baseUrl}houdix/seen/app/previous/get-previouses-of-subject/3'),
//   //           headers: {'Content-Type': 'application/json'},
//   //           body: encodedBody);
//   //       print(response.body);
//   //       List<ExamsLog?>? examslogLocal = await getAllExamLog();
//   //       List<ExamsLog> examslog = (json.decode(response.body))
//   //           .map<ExamsLog>((ele) => ExamsLog.fromJson(ele))
//   //           .toList();

//   //       if (eq(examslog, examslogLocal)) {
//   //         Get.defaultDialog(
//   //           contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
//   //           title: 'لا يوجد تغيير',
//   //           titleStyle: ownStyle(Colors.red, 16.5),
//   //           content: Text(
//   //             'لديك النسخة المحدثة',
//   //             textAlign: TextAlign.center,
//   //             style: ownStyle(Get.theme.primaryColor, 14.5),
//   //           ),
//   //         );
//   //       } else {
//   //         await clearExamsTable();
//   //         print('#########################');
//   //         print(examslog);
//   //         print('#########################');
//   //         for (var element in examslog) {
//   //           insertEX(ExamsLog(
//   //               id: element.id,
//   //               prevName: element.prevName,
//   //               prevNotes: element.prevNotes,
//   //               subjectId: element.subjectId));
//   //           for (var element2 in element.question!) {
//   //             if (questionId.contains(element2.id) == false) {
//   //               List<AnswerForPrev> answer = [];
//   //               insertQ(QuestionModel(
//   //                   isfavorite: 0,
//   //                   iswrong: 0,
//   //                   quesId: element2.id!,
//   //                   quesContent: element2.questionContent!,
//   //                   quesNotes: element2.questionNotes,
//   //                   isMcq: element2.isMcq! ? 1 : 0,
//   //                   subSubId: element.subjectId ?? 2,
//   //                   prevId: element.id));
//   //               answer = element2.answer!;
//   //               for (var element3 in answer) {
//   //                 insertAnswer(AnswerModel(
//   //                     quesId: element2.id,
//   //                     correctness: element3.correctness == true ? 1 : 0,
//   //                     ansNotes: element3.answerNotes,
//   //                     ansId: element3.id,
//   //                     ansContent: element3.answerContent));
//   //               }
//   //             } else {
//   //               print('================= insert before ======================');
//   //             }
//   //           }
//   //         }
//   //       }

//   //       return examslog;
//   //     } catch (e) {
//   //       throw Exception(e);
//   //     }
//   //   } else {
//   //     Get.defaultDialog(
//   //       contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
//   //       title: 'لا يوجد اتصال',
//   //       titleStyle: ownStyle(Colors.red, 16.5),
//   //       content: Text(
//   //         'الرجاء التاكد من اتصالك والمحاولة مرة اخرى',
//   //         textAlign: TextAlign.center,
//   //         style: ownStyle(Get.theme.primaryColor, 14.5),
//   //       ),
//   //     );
//   //     return [];
//   //   }
//   // }
// }
