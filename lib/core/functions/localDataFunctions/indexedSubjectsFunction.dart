import 'package:collection/collection.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Features/Sections/model/classes/IndexedSubjects.dart';
import '../../../Features/Sections/model/classes/SubjectModule.dart';

Future<List<IndexedSubject?>?> getIndexedSubjects() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $indexedSubjectTable");

  List<IndexedSubject?> list = res.isNotEmpty
      ? res
          .map((Map<String, dynamic> c) => IndexedSubject(
              id: c['id'],
              hasUnloackedSub: c[hasUnloacked] == 1 ? true : false,
              has_data: c[hasData] == 1 ? true : false,
              open_subject: c[openSubject] == 1 ? true : false,
              subjectName: c['subject_name'],
              language: c['language'],
              subject_code: c['subject_code'],
              subject_coupon: c[couponId],
              indexo: c['subjectIndex']))
          .toList()
      : [];

  if (list.isNotEmpty) {
    list.sort((a, b) => a!.indexo!.compareTo(b!.indexo!));

    return list;
  }
  return null;
}

Future<List<IndexedSubject?>?> getIndexedSubject(int id) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!
      .rawQuery("SELECT * FROM $indexedSubjectTable WHERE $subjectId=$id");

  List<IndexedSubject?> list = res.isNotEmpty
      ? res
          .map((Map<String, dynamic> c) => IndexedSubject(
              id: c['id'],
              subjectName: c['subject_name'],
              language: c['language'],
              subject_code: c['subject_code'],
              subject_coupon: c[couponId],
              indexo: c['subjectIndex']))
          .toList()
      : [];

  if (list.isNotEmpty) {
    list.sort((a, b) => a!.indexo!.compareTo(b!.indexo!));

    return list;
  }
  return null;
}

Future<int> deleteIndexedSubjects(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!
      .delete(indexedSubjectTable, where: '$subjectId = ?', whereArgs: [subId]);
}

Future deleteAllIndexedSubjects() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.rawDelete("DELETE FROM $indexedSubjectTable");
}

Future<Subject> insertIndexed(Subject subject, int i) async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.insert(indexedSubjectTable, {
    'id': subject.id,
    'subject_name': subject.subjectName,
    'language': subject.language,
    "subject_code": subject.subject_code,
    'subjectindex': i,
    subjectBacId: subject.bachelorId,
    hasData: subject.has_data! ? 1 : 0,
    hasUnloacked: subject.hasUnloackedSub! ? 1 : 0,
    openSubject: subject.open_subject! ? 1 : 0,
    couponId: subject.subject_coupon,
    subjectTerm: subject.term
  });

  return subject;
}

Future updateIndexedSubject(
  Subject subject,
) async {
  try {
    final db = await SubjectLocalDataSource.instance.dbe;

    return await db!.rawQuery(
      'UPDATE $indexedSubjectTable Set $subjectName ="${subject.subjectName}" , $subjectBacId =${subject.bachelorId} , $subjectTerm ="${subject.term}" , $subjectLang ="${subject.language}"  , $codeId =${subject.subject_code} , $couponId =${subject.subject_coupon} WHERE $subjectId=${subject.id}',
    );
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> updateIndex(IndexedSubject subject) async {
  final db = await SubjectLocalDataSource().dbe;
  List<IndexedSubject?>? subjectindex = await getIndexedSubjects();
//change the order of the quick access subject
  subjectindex!.where((element) =>
      element!.id != subject.id && element.indexo! < subject.indexo!);
  for (int i = 0; i < subjectindex.length; i++) {
    await db!.update(indexedSubjectTable,
        subjectindex[i]!.toJson(subjectindex[i]!.indexo! + 1),
        where: '$subjectId = ?', whereArgs: [subjectindex[i]!.id]);
  }

  return await db!.update(indexedSubjectTable, subject.toJson(0),
      where: '$subjectId = ?', whereArgs: [subject.id]);
}
