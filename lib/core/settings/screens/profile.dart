import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seen/Features/selectLevel/controller/select_level_controller.dart';
import 'package:seen/core/controller/text_controller.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/Features/introPages/model/data/UsersDataSource.dart';
import 'package:seen/Features/selectLevel/Screens/select_level.dart';

import '../../../Features/questions/Controller/imageController.dart';
import '../../controller/nameController.dart';
import '../../constants/TextStyles.dart';
import '../../../shared/CustomizedButton.dart';

import '../widget/custon_text_field_with_labe.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  static const routeName = '/profile';
  TextController textController = Get.find();
  SelectLevelController selectLevelController =
      Get.put(SelectLevelController());
  NameController nameController = Get.find();
  ImageController imageController = Get.put(ImageController());
  final GlobalKey<FormState> _key = GlobalKey();
  File? image;
  Future pickImage() async {
    try {
      imageController.isLoading = true;
      imageController.update();
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        imageController.isLoading = false;
        imageController.update();
        return;
      }
      final imageTemp = File(image.path);
      this.image = imageTemp;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: this.image!.path,

        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9
        // ],
        uiSettings: [
          AndroidUiSettings(
              activeControlsWidgetColor: Get.theme.primaryColor,
              toolbarTitle: 'crop your photo',
              toolbarColor: Get.theme.primaryColor,
              toolbarWidgetColor: Colors.white,
              backgroundColor: Get.theme.primaryColor.withOpacity(0.6),
              hideBottomControls: false,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile == null) {
        imageController.isLoading = false;
        imageController.update();
        return;
      }
      this.image = File(croppedFile.path);
      await UserDataSource.instance.onUploadImage(this.image!)!.then((value) {
        if (value != null) {
          textController.pref!.setString('imageUrl', value);
          Get.snackbar('', '',
              backgroundColor: Colors.white,
              colorText: SeenColors.rightAnswer,
              titleText: Text(
                ' تم التعديل بنجاح ',
                style: ownStyle(const Color.fromARGB(207, 83, 169, 79), 18.sp),
              ),
              messageText: Text(
                ' الرجاء تحديث البيانات',
                style: ownStyle(const Color.fromARGB(207, 83, 169, 79), 15.sp),
              ),
              duration: const Duration(milliseconds: 1300));
        } else {
          Get.snackbar('', '',
              backgroundColor: Colors.white,
              colorText: SeenColors.rightAnswer,
              titleText: Text(
                ' عذراً..حدث خطأ',
                style: ownStyle(Colors.red, 18.sp),
              ),
              messageText: Text(
                ' الرجاء المحاولة مجدداً',
                style: ownStyle(Colors.red, 15.sp),
              ),
              duration: const Duration(milliseconds: 1300));
        }
        imageController.isLoading = false;
        imageController.update();
      });
    } on PlatformException {
      imageController.isLoading = false;
      imageController.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    textController.profileName.text =
        textController.pref!.getString('fullName')!;
    textController.phonController.text =
        textController.pref!.getString('phoneNumber') ?? '';

    selectLevelController.isloading.value = false;

    selectLevelController.selectedGender =
        textController.pref!.getString('gender');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('تعديل الملف الشخصي',
            style: ownStyle(Get.theme.primaryColor, 18.sp)),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_sharp,
            color: Get.theme.primaryColor,
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              SizedBox(
                height: 40.w,
              ),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 150.w,
                      height: 150.w,
                      child: GetBuilder<ImageController>(builder: (_) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(500.r),
                            child: FastCachedImage(
                                fit: BoxFit.fill,
                                url:
                                    "${textController.pref!.getString('imageUrl')}",
                                loadingBuilder: (context, downloadProgress) =>
                                    Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress
                                              .progressPercentage.value,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                errorBuilder: (context, url, error) =>
                                    Image.asset(
                                        'assets/settings/profile picture.png')));
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.circular(50.r)),
                          padding: const EdgeInsets.all(10),
                          child: GetBuilder<ImageController>(builder: (_) {
                            return SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: Center(
                                child: imageController.isLoading
                                    ? CircularProgressIndicator(
                                        strokeWidth: 4.w,
                                        color: Get.theme.cardColor,
                                      )
                                    : Icon(
                                        Icons.edit,
                                        color: Get.theme.cardColor,
                                      ),
                              ),
                            );
                          }),
                        ),
                        onTap: () async {
                          await pickImage();
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "${textController.pref!.getString('Name')!}@",
                style: ownStyle(Theme.of(context).primaryColor, 12.sp),
              ),
              SizedBox(
                height: 35.w,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomTextFieldWithlabel(
                  data: Icons.edit,
                  controller: textController.profileName,
                  label: textController.pref!.getString('fullName') ?? '',
                  keyboardType: TextInputType.name,
                  obscureText: false,
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomTextFieldWithlabel(
                  data: Icons.edit,
                  controller: textController.phonController,
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.number,
                  obscureText: false,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(15.r),
                  color: Theme.of(context).cardColor,
                ),
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                child: GetBuilder<SelectLevelController>(builder: (_) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(
                        '  الجنس',
                        style: ownStyle(SeenColors.iconColor, 13.sp),
                      )
                      // underline: null,
                      ,
                      dropdownColor: Theme.of(context).cardColor,
                      disabledHint: Text(
                        '  الجنس',
                        style: ownStyle(SeenColors.iconColor, 13.sp),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      // underline: null,
                      items: selectLevelController.genders
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e,
                                    style: ownStyle(
                                        Theme.of(context).primaryColor, 12.sp)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        selectLevelController.setGender(val);
                      },
                      value: selectLevelController.selectedGender,
                    ),
                  );
                }),
              ),
              TextButton(
                  onPressed: () {
                    Get.toNamed(SelectLevel.routeName, arguments: true);
                  },
                  child: Text(
                    'تعديل المستوى التعليمي ',
                    style: ownStyle(Theme.of(context).primaryColor, 18.sp),
                  )),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomizedButton(
                    codeBack: true,
                    color: SeenColors.iconColor,
                    isCode: false,
                    txt: 'إلغاء',
                    width: 80.w,
                    fun: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    width: 50.w,
                  ),
                  Obx(() {
                    return selectLevelController.isloading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomizedButton(
                            codeBack: true,
                            color: Theme.of(context).primaryColor,
                            isCode: true,
                            txt: 'حفظ',
                            width: 80.w,
                            fun: () async {
                              if (_key.currentState!.validate()) {
                                selectLevelController.isloading.value = true;
                                textController.pref!.setString('fullName',
                                    textController.profileName.text);
                                textController.pref!.setString('gender',
                                    selectLevelController.selectedGender!);
                                textController.pref!.setString('phoneNumber',
                                    textController.phonController.text);
                                await UserDataSource.instance.updateUser({
                                  "user_fullname":
                                      textController.profileName.text,
                                  "user_username":
                                      textController.pref!.getString('Name'),
                                  "user_phonenumber":
                                      textController.phonController.text,
                                  "sex": selectLevelController.selectedGender ==
                                          'ذكر'
                                      ? 'male'
                                      : 'female',
                                  "token":
                                      textController.pref!.getString('token')
                                }, textController.pref!.getInt('u_id')!).then(
                                    (value) {
                                  if (value != null) {
                                    if (value == 'done') {
                                      Get.snackbar(' ', '',
                                          backgroundColor: Colors.white,
                                          titleText: Text(
                                            ' تم التعديل بنجاح ',
                                            style: ownStyle(
                                                const Color.fromARGB(
                                                    207, 83, 169, 79),
                                                18.sp),
                                          ),
                                          messageText: Text(
                                            '',
                                            style: ownStyle(
                                                const Color.fromARGB(
                                                    207, 83, 169, 79),
                                                18.sp),
                                          ),
                                          colorText: SeenColors.rightAnswer,
                                          duration: const Duration(
                                              milliseconds: 3000));
                                    }
                                  } else {
                                    Get.snackbar(' ', '',
                                        backgroundColor: Colors.white,
                                        titleText: Text(
                                          ' حدث خطأ',
                                          style: ownStyle(
                                              const Color.fromARGB(
                                                  207, 218, 71, 71),
                                              18.sp),
                                        ),
                                        messageText: Text(
                                          'الرجاء التأكد من المعلومات ',
                                          style: ownStyle(
                                              const Color.fromARGB(
                                                  207, 218, 71, 71),
                                              18.sp),
                                        ),
                                        colorText: SeenColors.rightAnswer,
                                        duration:
                                            const Duration(milliseconds: 3000));
                                  }

                                  selectLevelController.isloading.value = false;
                                });
                                nameController.name!.value =
                                    !nameController.name!.value;
                              }
                            },
                          );
                  })
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
