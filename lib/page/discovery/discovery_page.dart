import 'package:eyepetizer/config/string.dart';
import 'package:eyepetizer/page/discovery/category_page.dart';
import 'package:eyepetizer/page/discovery/follow_page.dart';
import 'package:eyepetizer/page/discovery/news_page.dart';
import 'package:eyepetizer/page/discovery/recommend_page.dart';
import 'package:eyepetizer/page/discovery/topic_page.dart';
import 'package:eyepetizer/widget/app_bar.dart';
import 'package:eyepetizer/widget/tab_bar.dart';
import 'package:flutter/material.dart';

const TAB_LABEL = ['关注', '分类', '专题', '资讯', '推荐'];

/// 发现页
class DiscoveryPage extends StatefulWidget {
  @override
  DiscoveryPageState createState() => new DiscoveryPageState();
}

class DiscoveryPageState extends State<DiscoveryPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // vsync:ticker 驱动动画,每次屏幕刷新都会调用TickerCallback，
    _tabController = TabController(length: TAB_LABEL.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar(
        StringConfig.discovery,
        showBack: false,
        // TabBar 和 TabBarView 结合使用
        bottom: tabBar(
          controller: _tabController,
          tabs: TAB_LABEL.map((String label) {
            return Tab(text: label);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // 与标签个数一致
          // 关注页
          FollowPage(),
          // 分类页
          CategoryPage(),
          // 专题页
          TopicPage(),
          // 资讯
          NewsPage(),
          // 推荐
          RecommendPage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
