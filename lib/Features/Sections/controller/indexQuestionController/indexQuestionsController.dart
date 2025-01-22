import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:seen/core/functions/localDataFunctions/CurrentSession.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/model/LocalDataSource.dart/LocalData.dart';

class IndexQuestionController extends GetxController {
  ItemScrollController itemScrollController = ItemScrollController();
  SharedPreferences? prefrences;
  int index = 0;
  scrollToIndex({int? sc}) {
    if (index < 3) {
      if (sc != null) {
        itemScrollController.scrollTo(
            curve: Curves.linear,
            index: 0,
            duration: const Duration(milliseconds: 310));
      }
    } else {
      itemScrollController.scrollTo(
          curve: Curves.linear,
          index: index,
          duration: const Duration(milliseconds: 310));
      index = 0;
    }
  }

  bool showHint_Note(bool has, bool show) {
    if (has) {
      show = !show;

      update();
      return show;
    } else {
      update();
      return false;
    }
  }

  saveSession({
    required int? subjectid,
    required int? subid,
    required int? prevId,
    required String choice,
    required int qid,
    required int index,
    required int a_index,
    required bool correctness,
    required String a_content,
    required int correct_index,
    required bool alreadyChecke,
    required bool isRandom,
    required bool isPrev,
    required bool isFav,
    required bool isWrong,
    required bool isAllFav,
    required bool isAllWrong,
  }) async {
    await insertCurrentSession({
      csSubjectID: subjectid,
      cspreviousIdCol: prevId,
      isPrevious: isPrev ? 1 : 0,
      'choice': choice,
      question_id: qid,
      questionIndex: index,
      csSubId: subid,
      answer_index: a_index,
      answerContent: a_content,
      correctIndex: correct_index,
      alreadyChecked: alreadyChecke ? 1 : 0,
      correctnessColumn: correctness ? 1 : 0,
      isRandomize: isRandom ? 1 : 0,
      isWrongness: isWrong ? 1 : 0,
      isfav: isFav ? 1 : 0,
      isAllWrongness: isAllWrong ? 1 : 0,
      isAllfav: isAllFav ? 1 : 0
    });
  }

  @override
  void onInit() async {
    // prefrences = await SharedPreferences.getInstance();
    // index = prefrences!.getInt('indexes') ?? 0;
    // if (prefrences!.getInt('indexes') != null) {
    //   scrollToIndex(index);
    // }
    super.onInit();
  }
}
