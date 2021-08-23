import 'package:eyepetizer/config/color.dart';
import 'package:flutter/material.dart';
/// TabBar 是一排水平的标签，可以来回切换
TabBar tabBar({
  // 标签选择变化控制器
  TabController controller,
  // 一系列标签控件
  List<Widget> tabs,
  ValueChanged<int> onTap,
  double fontSize = 14,
  // 当前选中的标签字体颜色
  Color labelColor = Colors.black,
  // 未选中的标签字体颜色
  Color unselectedLabelColor = ColorConfig.hitTextColor,
  // 下划线的颜色,指示器颜色
  Color indicatorColor = Colors.black,
  // 下划线的大小,指示器长短，tab：和tab一样长，label：和标签label 一样长
  TabBarIndicatorSize indicatorSize = TabBarIndicatorSize.label,
}) {
  return TabBar(
    // tabBar是否可滚动，默认false
    isScrollable: false,
    tabs: tabs,
    controller: controller,
    onTap: onTap,
    // 标签颜色
    labelColor: labelColor,
    // 未选中标签颜色
    unselectedLabelColor: unselectedLabelColor,
    // 标签样式
    labelStyle: TextStyle(fontSize: fontSize),
    // 未选中标签样式
    unselectedLabelStyle: TextStyle(fontSize: fontSize),
    // 指示器颜色
    indicatorColor: indicatorColor,
    // 指示器长短，tab：和tab一样长，label：和标签label 一样长
    indicatorSize: indicatorSize,
  );
}
