import 'package:eyepetizer/config/string.dart';
import 'package:eyepetizer/page/discovery/discovery_page.dart';
import 'package:eyepetizer/page/home/home_page.dart';
import 'package:eyepetizer/page/hot/hot_page.dart';
import 'package:eyepetizer/page/mine/mine_page.dart';
import 'package:eyepetizer/utils/toast_util.dart';
import 'package:eyepetizer/viewmodel/tab_navigation_viewmodel.dart';
import 'package:eyepetizer/widget/provider_widget.dart';
import 'package:flutter/material.dart';

class TabNavigation extends StatefulWidget {
  @override
  TabNavigationState createState() => new TabNavigationState();
}

class TabNavigationState extends State<TabNavigation> {
  //上次点击时间
  DateTime lastTime;
  int _currentIndex = 0;
  Widget _currentBody = Container(
    color: Colors.blue,
  );

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // 防止用户误碰
    return WillPopScope(
      child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              // 首页
              HomePage(),
              // 发现
              DiscoveryPage(),
              // 热门
              HotPage(),
              // 我的
              MinePage(),
            ],
          ),
          bottomNavigationBar: ProviderWidget<TabNavigationViewModel>(
            model: TabNavigationViewModel(),
            builder: (context, model, child) {
              return BottomNavigationBar(
                currentIndex: model.currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xff000000),
                unselectedItemColor: Color(0xff9a9a9a),
                items: _items(),
                // index 值为0，1，2，3
                onTap: (index) {
                  if (model.currentIndex != index) {
                    // 直接跳转不带动画，自动 setState
                    _pageController.jumpToPage(index);
                    model.changeBottomTabIndex(index);
                  }
                },
              );
            },
          )),
      onWillPop: _onWillPop,
    );
  }

  _onTap(int index) {
    switch (index) {
      case 0:
        _currentBody = Container(color: Colors.blue);
        break;
      case 1:
        _currentBody = Container(color: Colors.brown);
        break;
      case 2:
        _currentBody = Container(color: Colors.amber);
        break;
      case 3:
        _currentBody = Container(color: Colors.red);
        break;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  List<BottomNavigationBarItem> _items() {
    return [
      _bottomItem(StringConfig.home, 'images/ic_home_normal.png',
          'images/ic_home_selected.png'),
      _bottomItem(StringConfig.discovery, 'images/ic_discovery_normal.png',
          'images/ic_discovery_selected.png'),
      _bottomItem(StringConfig.hot, 'images/ic_hot_normal.png',
          'images/ic_hot_selected.png'),
      _bottomItem(StringConfig.mine, 'images/ic_mine_normal.png',
          'images/ic_mine_selected.png')
    ];
  }

  _bottomItem(String title, String normalIcon, String selectorIcon) {
    return BottomNavigationBarItem(
        icon: Image.asset(
          normalIcon,
          width: 24,
          height: 24,
        ),
        label: title,
        activeIcon: Image.asset(
          selectorIcon,
          width: 24,
          height: 24,
        ));
  }

  Future<bool> _onWillPop() async {
    if (lastTime == null ||
        DateTime.now().difference(lastTime) > Duration(seconds: 2)) {
      //两次点击间隔超过2秒则重新计时
      lastTime = DateTime.now();
      ToastUtils.showShip(StringConfig.exit_tip);
      return false;
    } else {
      // 自动出栈
      return true;
    }
  }
}
