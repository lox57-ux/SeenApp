import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/TextStyles.dart';

class NotMemberCoustomButton extends StatefulWidget {
  const NotMemberCoustomButton(
      {super.key,
      required this.txt,
      this.value,
      required this.color,
      this.fun,
      required this.width});
  final String txt;
  final int? value;
  final double width;

  final Color color;
  final Function()? fun;

  @override
  State<NotMemberCoustomButton> createState() => _NotMemberCoustomButtonState();
}

class _NotMemberCoustomButtonState extends State<NotMemberCoustomButton> {
  bool animateIt = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 15.r,
      borderRadius: BorderRadius.circular(15.r),
      onTap: () async {
        setState(() {
          animateIt = !animateIt;
        });
        await Future.delayed(const Duration(milliseconds: 350));
        widget.fun!();
        setState(() {
          animateIt = !animateIt;
        });
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
                color: widget.color),
          ),
        ),
      ),
    );
    ;
  }
}
