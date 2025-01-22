import 'package:flutter/foundation.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Features/CodeManaging/model/classes/ActiveCouponsLocal.dart';

Future<ActiveCouponsLocal> insertActiveCoupon(
    ActiveCouponsLocal activeCouponsLocal) async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.insert(tableActiveCoupons, activeCouponsLocal.toJson());

  if (kDebugMode) {}

  return activeCouponsLocal;
}

Future<List<ActiveCouponsLocal>?> getActiveCouponForSubject(int subId) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery(
      "SELECT * FROM $tableActiveCoupons  WHERE $subjectIdForCode=$subId");

  if (res.isNotEmpty) {
    return res
        .map<ActiveCouponsLocal>((e) => ActiveCouponsLocal.fromJson(e))
        .toList();
  }
  return null;
}

Future<List<ActiveCouponsLocal>?> isValidCoupon(int codeID) async {
  final db = await SubjectLocalDataSource.instance.dbe;
  var nowDate = DateTime.now().toLocal().toString();

  final res = await db!.rawQuery(
      "SELECT * FROM $tableActiveCoupons  WHERE $activeCodeId=$codeID AND '${nowDate}' < $endDate");
  if (res.isNotEmpty) {
    print(res);
    return res
        .map<ActiveCouponsLocal>((e) => ActiveCouponsLocal.fromJson(e))
        .toList();
  }
  return null;
}

Future<List<ActiveCouponsLocal?>?> getAllActiveCoupon() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  final res = await db!.rawQuery("SELECT * FROM $tableActiveCoupons");
  if (res.isNotEmpty) {
    return res
        .map<ActiveCouponsLocal>((e) => ActiveCouponsLocal.fromJson(e))
        .toList();
  }
  return null;
}
// Future<int> deleteSubjects(int subId) async {
//   final db = await SubjectLocalDataSource.instance.dbe;
//   return await db!
//       .delete(tableSubject, where: '$subjectId = ?', whereArgs: [subId]);
// }

Future deleteAllActiveCoupon() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.rawDelete("DELETE FROM $tableActiveCoupons");
}
