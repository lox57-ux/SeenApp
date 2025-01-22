import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../shared/model/LocalDataSource.dart/LocalData.dart';
import '../../../Features/CodeManaging/model/classes/ActiveCodesLocal.dart';
import '../../../Features/CodeManaging/model/classes/ActiveCouponsLocal.dart';
import '../../../Features/CodeManaging/model/classes/UserCodes.dart';
import '../ActiveCodeFunction.dart';
import 'ActiveCoupon.dart';

///insert codes into table
Future<UserCodes> insertCodes(UserCodes code) async {
  final db = await SubjectLocalDataSource().dbe;

  await db!.insert(tableCodes, {
    'id': code.id,
    'code_content': code.codeContent,
    'code_name': code.codeName,
    'code_notes': code.codeNotes,
    'expiry_time': code.expiryTime,
    'date_of_activation': code.dateOfActivation,
    'is_active': code.isActive,
    'user_id': code.userId,
    iscoupon: 0
  });

  if (kDebugMode) {}

  return code;
}

///get all user code
Future<List<UserCodes?>?> getAllCodes() async {
  final db = await SubjectLocalDataSource().dbe;

  List<ActiveCouponsLocal?>? coupons = await getAllActiveCoupon();
  List<ActiveCodesLocal?>? c = await getAllActiveCode();
  List<UserCodes?> list = [];
  if (coupons != null && coupons!.isNotEmpty) {
    coupons.forEach((element) {
      UserCodes userCode = UserCodes(
        codeName: element!.name,
        expanded: false,
        iscoupon: true,
        expiryTime: element!.expiryTime,
        codeContent: element.name,
        dateOfActivation: element.activationDate,
        id: element.id,
      );

      if (list.contains(userCode)) {
      } else {
        list.add(UserCodes(
          codeName: element.name,
          expanded: false,
          iscoupon: true,
          expiryTime: element!.expiryTime,
          codeContent: element.name,
          dateOfActivation: element.activationDate,
          id: element.id,
        ));
      }
    });
  }
  if (c != null && c!.isNotEmpty) {
    c.forEach((element) {
      UserCodes userCode = UserCodes(
        codeName: element!.name,
        expanded: false,
        iscoupon: false,
        expiryTime: element.expiryTime,
        codeContent: element.name,
        dateOfActivation: element.dateOfActivation,
        id: element.id,
      );

      if (list.contains(userCode)) {
      } else {
        list.add(UserCodes(
          codeName: element.name,
          expanded: false,
          iscoupon: false,
          expiryTime: element!.expiryTime,
          codeContent: element.name,
          dateOfActivation: element.dateOfActivation,
          id: element.id,
        ));
      }
    });
  }
  if (list.isNotEmpty) {
    return list;
  }
  return [];
}

///delete all row from code table

Future deleteCodes() async {
  final db = await SubjectLocalDataSource.instance.dbe;
  return await db!.rawQuery("Delete FROM $tableCodes");
}
