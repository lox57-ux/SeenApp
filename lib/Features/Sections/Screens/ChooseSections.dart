import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:seen/core/constants/Colors.dart';
import 'package:seen/core/constants/TextStyles.dart';
import 'package:seen/Features/Sections/widgets/NotMemberWidget.dart';

import '../widgets/ExamsLogList.dart';
import '../widgets/FavoritesList.dart';

import '../widgets/SectionsList.dart';
import '../widgets/WrongAnswersList.dart';

class ChooseSections extends StatefulWidget {
  ChooseSections({
    super.key,
    required this.arg,
  });
  var arg;

  @override
  State<ChooseSections> createState() => _ChooseSectionsState();
}

class _ChooseSectionsState extends State<ChooseSections>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onPanUpdate: (details) {
      //   if (details.delta.dx < 0) {
      //     Get.nestedKey(1)!.currentState!.pop();
      //   }
      // },

      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                DefaultTabController(
                  length: 4,
                  key: Get.nestedKey(5),
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        padding: EdgeInsets.zero,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorPadding: const EdgeInsets.all(5),
                        unselectedLabelColor: SeenColors.iconColor,
                        unselectedLabelStyle:
                            ownStyle(SeenColors.iconColor, 14.sp)!
                                .copyWith(fontWeight: FontWeight.w400),
                        labelColor: Get.theme.primaryColor,
                        labelPadding: EdgeInsets.zero,
                        labelStyle:
                            ownStyle(Theme.of(context).primaryColor, 14.sp)!
                                .copyWith(fontWeight: FontWeight.w400),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            text: "التصنيفات",
                          ),
                          Tab(
                            text: "التكرار المُتباعِد",
                          ),
                          Tab(
                            text: "المفضلة",
                          ),
                          Tab(
                            text: "الدورات",
                          )
                        ],
                      ),
                      SizedBox(
                          height: 560.h,
                          child:
                              TabBarView(controller: _tabController, children: [
                            SectionsList(
                              tabController: _tabController!,
                              subjectid: widget.arg['id'],
                              isLockedSubject: widget.arg['isLocked'],
                            ),
                            // arg['isLocked']
                            //     ? NotMemberScreen()
                            //     :
                            WrongAnswersList(
                                tabController: _tabController!,
                                subjectName: widget.arg['subject_name'],
                                s_id: widget.arg['id']),
                            // arg['isLocked']
                            //     ? NotMemberScreen()
                            //     :
                            FavoriteList(
                                tabController: _tabController!,
                                subjectName: widget.arg['subject_name'],
                                s_id: widget.arg['id']),
                            widget.arg['isLocked']
                                ? NotMemberScreen(
                                    tabController: _tabController,
                                    isLock: true,
                                  )
                                : ExamsLogList(
                                    tabController: _tabController!,
                                    s_id: widget.arg['id'],
                                  )
                          ]))
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
