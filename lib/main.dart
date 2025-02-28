// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/Features/Splash/InitialNavigationController/SplachScreenController.dart';
import 'package:seen/Features/Sections/controller/subjectController/SubjectController.dart';
import 'package:seen/core/functions/ActiveCodeFunction.dart';
import 'package:seen/core/functions/QuestionFunction.dart';
import 'package:seen/Features/CodeManaging/Screens/CodeManagingScreen.dart';
import 'package:seen/Features/NavigateToSubject/Screen/NavigateToSubjectScreen.dart';
import 'package:seen/Features/NavigateToSubject/Screen/SubsubjectsForNavigateToLanding.dart';
import 'package:seen/Features/Sections/Screens/ChooseSubject.dart';
import 'package:seen/Features/Sections/widgets/NotMemberWidget.dart';
import 'package:seen/Features/introPages/Screens/IntroLanding.dart';
import 'package:seen/Features/selectLevel/Screens/select_level.dart';
import 'package:seen/core/settings/screens/CommonQuestions.dart';
import 'package:seen/core/settings/screens/PrivacyPolicy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'core/functions/localDataFunctions/ActiveCoupon.dart';
import 'core/functions/localDataFunctions/CurrentSession.dart';
import 'core/functions/localDataFunctions/SubjectFunctions.dart';
import 'core/functions/localDataFunctions/SubsubjectsFunction.dart';
import 'core/functions/localDataFunctions/indexedSubjectsFunction.dart';
import 'shared/model/DataSource/BackgroundDataSource.dart';
import 'shared/model/LocalDataSource.dart/LocalData.dart';
import 'Features/introPages/controller/Auth/SignUpwithGoogle.dart';

import 'core/controller/text_controller.dart';
import 'core/controller/theme_controller.dart';
import 'core/constants/SeenThem.dart';

import 'core/functions/localDataFunctions/userAnswerFunction.dart';

import 'Features/Randomize/Screens/RandomizeScreen.dart';

import 'Features/questions/model/data/WrongAnswerDataSource.dart';
import 'Features/questions/screens/MathQuestionsScreen.dart';
import 'Features/questions/screens/questions.dart';

import 'core/settings/screens/profile.dart';
import 'core/settings/screens/settings.dart';

import 'Features/update/UpdateScreen.dart';

Function eq = const ListEquality().equals;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      var pref = await SharedPreferences.getInstance();
      await SubjectLocalDataSource.instance.initializeDb();
      List? answers = await getAllUseranswer();
      DateTime tempdate = DateTime.parse(
          pref.getString('date_time') ?? DateTime.now().toString());
      DateTime date1 = DateTime(tempdate.year, tempdate.month, tempdate.day,
          tempdate.hour, tempdate.minute);
      DateTime date2 = DateTime.now();
      Duration difference = date2.difference(date1);
      bool isvalid = difference.inDays.abs() < 7;
      if (!isvalid) {
        if (answers != null && answers.isNotEmpty) {
          await BackgroundDataSource.instance
              .submitAnswers(answers!)
              .then((value) {});
        } else {
          await pref.remove('token');
          await pref.remove('isFirstTime');
          await deleteAllActiveCodes();
          await deleteAllActiveCoupon();
          await deleteAllSession();
          await deleteAllIndexedSubjects();
          await deleteAllSubjects();
          await deleteAllSubSubjects();
          await clearQuestionTable();
        }
        return Future.value(true);
      }

      List? notes = await getUserNote();
      List? fav = await getAllFavoritesQuestionID();

      if (answers != null && answers.isNotEmpty) {
        await BackgroundDataSource.instance.submitAnswers(answers);
        // await BackgroundDataSource.instance.submitNote(notes ?? []);
        await WrongAnswerDataSource.instace.getAllWrongAnswers();
        await BackgroundDataSource.instance.submitFavorites(fav ?? []);
        await BackgroundDataSource.instance.getFavorites();
        await BackgroundDataSource.instance.getChapter();

        return Future.value(true);
      } else {
        await BackgroundDataSource.instance.getChapter();

        return Future.value(true);
      }
    },
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  TextController textController = Get.put(TextController());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Get.theme.brightness,
  ));
  await SubjectLocalDataSource.instance.initializeDb();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
      "periodic-task-identifier", "Sync_User_Answers",
      constraints: Constraints(
          requiresCharging: false,
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false));
  await langdetect.initLangDetect();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 100));
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  NavigationController navigationController = Get.put(NavigationController());

  final ThemeController themeController = Get.put(ThemeController());

  GoogleSignUpController googleSignUpController =
      Get.put(GoogleSignUpController());

  SubjectController subjectController = Get.put(SubjectController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return Obx(() {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale('ar'),
          getPages: [
            GetPage(
                name: SelectLevel.routeName,
                page: () => SelectLevel(),
                arguments: Get.arguments,
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                name: ChooseSubject.routeName,
                page: () => ChooseSubject(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                name: '/intro',
                page: () => IntroLanding(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: '/Questions',
                page: () => Questionss(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: MathQuestionScreen.routeName,
                page: () => MathQuestionScreen(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                name: CodeManagingScreen.routeName,
                page: () => CodeManagingScreen(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                name: Settings.routeName,
                page: () => Settings(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                name: RandomizeScreen.routeName,
                page: () => RandomizeScreen(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad),
            GetPage(
                name: Profile.routeName,
                page: () => Profile(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                name: NavigateToSubject.routeName,
                page: () => NavigateToSubject(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: SubsubjectsForNavigateToLanding.routeName,
                page: () =>
                    SubsubjectsForNavigateToLanding(data: Get.arguments),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: NotMemberScreen.routeName,
                page: () => NotMemberScreen(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: PrivacyPolicy.routeName,
                page: () => PrivacyPolicy(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: CommonQuestions.routeName,
                page: () => CommonQuestions(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
            GetPage(
                arguments: Get.arguments,
                name: UpdateSceen.routeName,
                page: () => UpdateSceen(),
                transition: Transition.leftToRight,
                transitionDuration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad),
          ],
          title: 'سين',
          theme: themeController.isDarkMode.value
              ? SeenTheme.darkTheme()
              : SeenTheme.lightTheme(),
          home: navigationController.home,
        );
      });
    });
  }
}
