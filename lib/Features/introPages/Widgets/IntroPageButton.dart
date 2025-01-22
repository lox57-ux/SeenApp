// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/TextStyles.dart';

class IntroPageButton extends StatefulWidget {
  const IntroPageButton({
    super.key,
    required this.txt,
    PageController? pageController,
    this.value,
    this.isForward,
    required this.color,
    this.fun,
  }) : _pageController = pageController;
  final PageController? _pageController;
  final String txt;
  final int? value;
  final bool? isForward;
  final Color color;
  final Function()? fun;

  @override
  State<IntroPageButton> createState() => _IntroPageButtonState();
}

class _IntroPageButtonState extends State<IntroPageButton> {
  bool animateIt = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: widget._pageController == null
          ? widget.fun!
          : () async {
              if (widget.isForward!) {
                setState(() {
                  animateIt = !animateIt;
                });
                await Future.delayed(const Duration(milliseconds: 75));
                setState(() {
                  animateIt = !animateIt;
                });
                widget._pageController!.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              } else {
                setState(() {
                  animateIt = !animateIt;
                });
                await Future.delayed(const Duration(milliseconds: 75));
                setState(() {
                  animateIt = !animateIt;
                });
                widget._pageController!.animateToPage(3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              }
            },
      child: AnimatedContainer(
        duration: const Duration(seconds: 0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: AnimatedContainer(
          curve: Curves.linear,
          margin: const EdgeInsets.only(bottom: 5, left: 2, right: 2, top: 2),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          height: animateIt ? 42.w : 40.w,
          alignment: Alignment.center,
          width: animateIt ? 70.w : 65.w,
          duration: const Duration(milliseconds: 350),
          child: Text(
            widget.txt,
            style: introMsg()!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: widget._pageController != null
                    ? SeenColors.mainColor
                    : widget.color),
          ),
        ),
      ),
    );
  }
}
