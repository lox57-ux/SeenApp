import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seen/Features/selectLevel/controller/select_level_controller.dart';
import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/core/settings/screens/PrivacyPolicy.dart';
import 'package:seen/core/settings/screens/profile.dart';
import 'package:seen/shared/CustomizedButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/model/entites/Links.dart';
import '../../controller/nameController.dart';
import '../../controller/text_controller.dart';
import '../../controller/theme_controller.dart';
import '../../constants/Colors.dart';
import '../../functions/LinksFunction.dart';
import '../../functions/localDataFunctions/CurrentSession.dart';

import '../../../Features/NavigateToSubject/Screen/NavigateToSubjectScreen.dart';
import '../widget/custom_option.dart';
import 'CommonQuestions.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  static const routeName = '/settings';
  final ThemeController themeController = Get.put(ThemeController());
  TextController textController = Get.find();
  NameController nameController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50.w,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Get.theme.cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 5.w,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.w,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 85.w,
                            height: 85.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(200.r),
                              child:
                                  textController.pref!.getString('imageUrl') ==
                                          null
                                      ? Image.asset(
                                          'assets/settings/profile picture.png')
                                      : FastCachedImage(
                                          fit: BoxFit.fill,
                                          url:
                                              "${textController.pref!.getString('imageUrl')}",
                                          errorBuilder: (context, url, error) =>
                                              Image.asset(
                                                  'assets/settings/profile picture.png'),
                                        ),
                            )),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 145.w,
                              child: Obx(() {
                                return Text(
                                  nameController.name!.value
                                      ? "${textController.pref!.getString('Name')}" ??
                                          ''
                                      : "${textController.pref!.getString('Name')}" ??
                                          '',
                                  maxLines: 2,
                                  style:
                                      ownStyle(Get.theme.primaryColor, 20.sp),
                                );
                              }),
                            ),
                            Text(
                                textController.pref!.getString('section') ?? '',
                                style: ownStyle(SeenColors.iconColor, 16.sp)),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CustomOption(
                      txt: 'تعديل الملف الشخصي',
                      func: () {
                        Get.toNamed(Profile.routeName);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    CustomOption(
                      txt: 'حذف الإجابات السابقة',
                      func: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Get.theme.cardColor,
                                surfaceTintColor: Colors.white,
                                title: Center(
                                  child: Text(
                                    'حذف جميع الإجابات',
                                    style:
                                        ownStyle(Get.theme.primaryColor, 18.sp),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        'هل أنت متأكد من رغبتك في حذف جميع الإجابات في جميع المواد ؟',
                                        textAlign: TextAlign.center,
                                        style: ownStyle(
                                            SeenColors.iconColor, 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: [
                                  CustomizedButton(
                                    isCode: false,
                                    codeBack: true,
                                    color: Colors.grey,
                                    txt: 'إلغاء',
                                    fun: () {
                                      Get.back();
                                    },
                                    width: 100.w,
                                  ),
                                  CustomizedButton(
                                    isCode: true,
                                    codeBack: true,
                                    color: Get.theme.primaryColor,
                                    txt: 'موافق',
                                    fun: () async {
                                      await deleteAllSession()
                                          .then((value) => Get.back());
                                    },
                                    width: 100.w,
                                  ),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    CustomOption(
                      txt: 'انتقال إلى المادة',
                      func: () {
                        Get.lazyPut(() => SelectLevelController());
                        Get.toNamed(NavigateToSubject.routeName);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    CustomOption(
                      txt: 'تواصل مع الدعم التقني',
                      func: () async {
                        Links? link = await getLink('telegramtechnical');
                        if (link != null) {
                          final Uri url = Uri.parse(link.url!);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    CustomOption(
                      txt: 'تواصل مع الدعم العلمي',
                      func: () async {
                        Links? link = await getLink('telegraminformatice');
                        if (link != null) {
                          final Uri url = Uri.parse(link.url!);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    CustomOption(
                      txt: ' سياسة الاستخدام والخصوصية',
                      func: () {
                        Get.toNamed(PrivacyPolicy.routeName);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    CustomOption(
                      txt: 'الأسئلة الشائعة',
                      func: () {
                        Get.toNamed(CommonQuestions.routeName);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    Obx(() {
                      return CustomOption(
                        txt: 'الوضع الليلي',
                        func: () {},
                        icon: Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: SizedBox(
                            width: 20.w,
                            child: Switch(
                              activeColor: Get.theme.primaryColor,
                              value: themeController.isDarkMode.value,
                              onChanged: (value) {
                                themeController.toggleTheme();
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 60.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'تابعونا على',
                          style: ownStyle(Get.theme.primaryColor, 19.sp),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                Links? link = await getLink('telegram');
                                if (link != null) {
                                  final Uri url = Uri.parse(link.url!);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5.0.w),
                                child: FaIcon(
                                  FontAwesomeIcons.telegram,
                                  size: 30.sp,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Links? link = await getLink('instagram');
                                if (link != null) {
                                  final Uri url = Uri.parse(link.url!);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5.0.w),
                                child: SvgPicture.asset(
                                  'assets/settings/instagram icon.svg',
                                  width: 30.sp,
                                  colorFilter: ColorFilter.mode(
                                      Get.theme.primaryColor, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Links? link = await getLink('facebook');
                                if (link != null) {
                                  final Uri url = Uri.parse(link.url!);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5.0.w),
                                child: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 30.sp,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await getAllLinks();
                                Links? link = await getLink('youtube');
                                if (link != null) {
                                  final Uri url = Uri.parse(link.url!);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5.0.w),
                                child: FaIcon(
                                  FontAwesomeIcons.youtube,
                                  size: 30.sp,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'سين ${textController.packageInfo?.version}v ',
                          style: ownStyle(Get.theme.primaryColor, 19.sp),
                        )
                      ],
                    ),
                    SizedBox(height: 15.w),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.w),
        ],
      ),
    );
  }
}
