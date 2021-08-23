import 'dart:math';

import 'package:eyepetizer/model/discovery/recommend_model.dart';
import 'package:eyepetizer/widget/discovery/recommend_item_widget.dart';
import 'package:eyepetizer/widget/discovery/recommend_loading.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

/// 发现页——>推荐页
class RecommendPage extends StatefulWidget {
  @override
  RecommendPageState createState() => new RecommendPageState();
}

class RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  RecommendLoading _recommendLoading = RecommendLoading();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // RefreshIndicator：下拉刷新
      body: RefreshIndicator(
        onRefresh: _refresh,
        // LayoutBuilder：获取父组件的约束尺寸
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          // 交叉轴方向的个数最少两个
          final int crossAxisCount = max(
              // 父容器给的宽度 ~/ 屏幕宽度的一半
              // ~/返回一个整数值的除法 assert(5 ~/ 2 == 2); // 结果是一个整数
              constraints.maxWidth ~/ (MediaQuery.of(context).size.width / 2.0),
              2);
          // 加载更多
          return LoadingMoreList<RecommendItem>(
            ListConfig<RecommendItem>(
              // 扩展 WaterfallFlow(瀑布流) 等列表--默认flutter没有实现瀑布流
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, item, index) =>
                  RecommendItemWidget(item: item),
              sourceList: _recommendLoading,
              padding: const EdgeInsets.all(5.0),
              lastChildLayoutType: LastChildLayoutType.foot,
            ),
          );
        }),
      ),
    );
  }

  Future<void> _refresh() async {
    return _recommendLoading.refresh().whenComplete(() => null);
  }

  @override
  void dispose() {
    super.dispose();
    _recommendLoading.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
