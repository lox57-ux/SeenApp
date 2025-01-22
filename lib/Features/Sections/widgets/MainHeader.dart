import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:seen/Features/selectLevel/controller/select_level_controller.dart';
import 'package:seen/core/Services/Network.dart';

import '../../../shared/model/DataSource/BackgroundDataSource.dart';
import '../../../shared/model/DataSource/LinksDataSource.dart';
import '../../CodeManaging/controller/CodeManagingController.dart';
import '../../CodeManaging/model/data/CodeManagingDataSource.dart';
import '../../Splash/InitialNavigationController/RefreshController.dart';
import '../../questions/model/data/QuestionsDataSource.dart';
import '../controller/subjectController/CustomOptionController.dart';
import '../../CodeManaging/controller/QrCodeController.dart';
import '../../questions/Controller/SelectAnswerController/WrongAnswersController.dart';
import '../../../core/controller/nameController.dart';
import '../controller/subjectController/SubjectController.dart';
import '../../../core/controller/text_controller.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

import '../../../core/functions/QuestionFunction.dart';

import '../../../core/functions/localDataFunctions/userAnswerFunction.dart';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';

import '../../CodeManaging/Screens/CodeManagingScreen.dart';

import '../../../core/settings/screens/profile.dart';
import '../../../core/settings/screens/settings.dart';
import '../../../shared/InvokeWaitingDialog.dart';
import '../model/Data/SubjectDatatSource.dart';

class MainHeader extends StatelessWidget {
  MainHeader({
    super.key,
  });

  QrCodeController qrCodeController = Get.put(QrCodeController());
  CodeManagingController codeManagingController =
      Get.put(CodeManagingController());
  WrongAnswersCotroller _wrongAnswersController = Get.find();
  RefreshController refreshController = Get.find();
  SubjectController subjectController = Get.find();
  TextController textController = Get.find();
  NameController nameController = Get.find();
  CustomOptionController customOptionController =
      Get.put(CustomOptionController());
  double turns = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0.w),
              child: InkWell(
                onTap: () {
                  //     deleteSession();
                  Get.toNamed(Profile.routeName);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(500.r),
                          child: FastCachedImage(
                              fadeInDuration: Duration.zero,
                              fit: BoxFit.fill,
                              url:
                                  "${textController.pref!.getString('imageUrl') ?? 'https://'}",
                              loadingBuilder: (context, downloadProgress) =>
                                  Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress
                                            .progressPercentage.value,
                                        color: Theme.of(context).primaryColor),
                                  ),
                              errorBuilder: (context, url, error) =>
                                  Image.asset(
                                      'assets/settings/profile picture.png'))),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130.w,
                          child: Obx(() {
                            return Text(
                              nameController.name!.value
                                  ? "${textController.pref!.getString('fullName') ?? ''} "
                                  : "${textController.pref!.getString('fullName') ?? ''} ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ownStyle(
                                      Theme.of(context).primaryColor, 16.sp)!
                                  .copyWith(fontWeight: FontWeight.w500),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        Text(
                          "${textController.pref!.getString('section') ?? ''} "!,
                          style: ownStyle(SeenColors.iconColor, 11.sp)!
                              .copyWith(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(
                width: 100.w,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatefulBuilder(
                          builder: (BuildContext context, setState) {
                        return InkWell(
                            borderRadius: BorderRadius.circular(15.r),
                            onTap: () async {
                              setState(
                                () {
                                  subjectController.animationController!
                                      .forward(from: 0.0);
                                },
                              );

                              if (await checkConnection()) {
                                await BackgroundDataSource.instance
                                    .getChapter()
                                    .then((value) async {
                                  if (value != null && value == 401) {
                                    Get.snackbar(' غير مصرح بالدخول ',
                                        ' عذراً..انتهت صلاحية الجلسة',
                                        colorText: Colors.white,
                                        backgroundColor:
                                            Colors.redAccent.shade200,
                                        duration:
                                            const Duration(milliseconds: 1500));
                                    await Future.delayed(
                                        const Duration(milliseconds: 2400));

                                    Get.offAllNamed('/intro');
                                    Get.put(SelectLevelController());
                                    throw Exception();
                                  }
                                });

                                await SubjectDataSource.instance
                                    .get_All_Subjects();
                                subjectController.update();
                                InvokeWaitingDialog(context);
                                await SubjectDataSource.instance
                                    .get_AllSub_Subjects();

                                // await CodeManagingDataSource.instance
                                //     .getUserCode();
                                // await CodeManagingDataSource.instance
                                //     .getActiveUserCode();
                                await CodeManagingDataSource.instance
                                    .getActiveUserCoupon();
                                List? fav = await getAllFavoritesQuestionID();

                                List? notes = await getUserNote();

                                // if (notes != null && notes.isNotEmpty) {
                                //   await BackgroundDataSource.instance
                                //       .submitNote(notes);
                                // }

                                await QuestionDataSource.instance
                                    .getAllUserQuestions();
                                customOptionController.update();
                                subjectController.update();
                                await DefaultCacheManager().emptyCache();

                                // List<int?>? q = await getAllQuestionID();
                                // if (q != null && q.isNotEmpty) {
                                //   print(q);
                                //   await ExamsLogDataSource.instance
                                //       .getAllExamsLog(q!);
                                // }

                                await LinksDataSource.instance.getAllLinks();

                                await BackgroundDataSource.instance
                                    .submitNotesFavorites(fav, notes)
                                    .then((value) async {
                                  if (value != null && value.isNotEmpty) {
                                    await addAllFavorites(value);
                                  }
                                });

                                List? userAnswer = await getAllUseranswer();
                                if (userAnswer != null &&
                                    userAnswer.isNotEmpty) {
                                  await BackgroundDataSource.instance
                                      .submitAnswers(userAnswer ?? []);
                                }

                                subjectController.update();
                                refreshController.update();
                              } else {
                                Get.defaultDialog(
                                  backgroundColor: Get.theme.cardColor,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  title: 'لا يوجد اتصال',
                                  titleStyle: ownStyle(Colors.red, 16.5),
                                  content: Text(
                                    'الرجاء التأكد من اتصالك بالانترنت والمحاولة مرة أخرى',
                                    textAlign: TextAlign.center,
                                    style:
                                        ownStyle(Get.theme.primaryColor, 14.5),
                                  ),
                                );
                              }
                            },
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 5.0).animate(
                                  subjectController.animationController!),
                              child: Icon(
                                Icons.refresh_rounded,
                                color: SeenColors.iconColor,
                                size: 20.w,
                              ),
                            ));
                      }),
                      IconButton(
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          splashRadius: 2,
                          padding: EdgeInsets.all(0.w),
                          onPressed: () {
                            Get.toNamed(CodeManagingScreen.routeName);
                            refreshController.update();
                          },
                          icon: Icon(
                            Icons.qr_code,
                            color: SeenColors.iconColor,
                            size: 20.w,
                          )),
                      IconButton(
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          splashRadius: 2,
                          padding: EdgeInsets.all(2.w),
                          onPressed: () {
                            // getQuestion(2121);

                            Get.toNamed(Settings.routeName);
                          },
                          icon: Icon(
                            Icons.settings,
                            color: SeenColors.iconColor,
                            size: 20.w,
                          ))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
