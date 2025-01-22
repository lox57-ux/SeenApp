import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seen/core/controller/theme_controller.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final ThemeController _themeController = Get.find();
  final double width;
  final double height;
  ShapeBorder? shapeBorder;
  Skeleton.rectangular({super.key, required this.width, required this.height}) {
    shapeBorder =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
  }
  Skeleton.circular(
      {super.key,
      required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: _themeController.isDarkMode.value
            ? Theme.of(context).cardColor
            : SeenColors.iconColor.withOpacity(0.5),
        highlightColor: Theme.of(context).canvasColor,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
              shape: shapeBorder!,
              color: _themeController.isDarkMode.value
                  ? Theme.of(context).cardColor
                  : SeenColors.iconColor.withOpacity(0.5)),
        ));
  }
}
