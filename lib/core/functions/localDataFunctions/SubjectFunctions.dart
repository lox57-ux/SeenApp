import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Features/Sections/model/classes/SubjectModule.dart';

Future<Subject> insert(
  Subject subject,
) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  await db!.insert(tableSubject, subject.toJson());

  return subject;
}

Future<List<Subject?>?> getSubjects() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableSubject");

  List<Subject?>? list = res.isNotEmpty
      ? res
          .map((Map<String, dynamic> c) => Subject(
              id: c['id'],
              expand: false,
              open_subject: c['open_subject'] == 1 ? true : false,
              has_data: c['has_data'] == 1 ? true : false,
              subjectName: c['subject_name'],
              subjectNotes: c['subject_notes'],
              hasUnloackedSub: c['has_unloacked'] == 1 ? true : false,
              term: c['term'],
              language: c['language'],
              bachelorId: c['bachelor_id'],
              yearId: c['year_id'],
              subject_coupon: c['subject_coupon'],
              subject_code: c['subject_code']))
          .toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return null;
}

Future<List<int?>?> getSubjectsID() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT id FROM $tableSubject");

  List<int?>? list = res.isNotEmpty
      ? res.map((Map<String, dynamic> c) => c['id'] as int).toList()
      : [];

  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

Future<Subject?> getSubject(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  List<Map<String, dynamic>> maps = await db!.query(tableSubject,
      columns: [
        subjectId,
        subjectName,
        subjectNotes,
        subjectTerm,
        subjectLang,
        subjectBacId,
        subjectYearId,
        codeId,
        couponId
      ],
      where: '$subjectId = ?',
      whereArgs: [subId]);
  if (maps.isNotEmpty) {
    return Subject(
        id: maps.first['id'],
        expand: false,
        subjectName: maps.first['subject_name'],
        subjectNotes: maps.first['subject_notes'],
        term: maps.first['term'],
        language: maps.first['language'],
        bachelorId: maps.first['bachelor_id'],
        yearId: maps.first['year_id'],
        subject_coupon: maps.first['subject_coupon'],
        subject_code: maps.first['subject_code']);
  }
  return null;
}

Future<int> deleteSubjects(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!
      .delete(tableSubject, where: '$subjectId = ?', whereArgs: [subId]);
}

Future deleteAllSubjects() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.rawDelete("DELETE FROM $tableSubject");
}

Future<int> updateS(Subject subject) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.update(tableSubject, subject.toJson(),
      where: '$subjectId = ?', whereArgs: [subject.id]);
}

Future<dynamic> updateSubjectIfcontainsData(int id, int value) async {
  final db = await SubjectLocalDataSource.instance.dbe;

  return await db!.rawQuery(
      'UPDATE $tableSubject Set $hasData =$value WHERE $subjectId=$id');
}

Future<dynamic> updateSubjectStatus(int id, int value) async {
  final db = await SubjectLocalDataSource.instance.dbe;

  return await db!.rawQuery(
      'UPDATE $tableSubject Set $openSubject =$value WHERE $subjectId=$id');
}
