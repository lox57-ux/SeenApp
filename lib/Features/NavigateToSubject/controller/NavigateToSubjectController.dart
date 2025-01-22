import 'package:get/state_manager.dart';

import '../../../shared/model/entites/CodeInfo.dart';
import '../../Sections/model/Data/NavigateToSubjectDataSource.dart';

class NavigateToSubjectController extends GetxController {
  List<Subject>? subjectsForYear = [];
  int? selectedSubject;
  setSubject(value) {
    selectedSubject = value;
    update();
  }

  setSubjectForyear(yearID) async {
    subjectsForYear = [];
    update();
    selectedSubject = null;
    subjectsForYear =
        await NavigateToSubjectDataSource.instance.getsubjectOfyear(yearID);
    update();
  }
}
