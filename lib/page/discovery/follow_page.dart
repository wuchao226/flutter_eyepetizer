import 'package:eyepetizer/model/common_item.dart';
import 'package:eyepetizer/state/base_list_state.dart';
import 'package:eyepetizer/viewmodel/discovery/follow_viewmodel.dart';
import 'package:eyepetizer/widget/discovery/follow_item_widget.dart';
import 'package:flutter/material.dart';

/// 发现页——>关注页
class FollowPage extends StatefulWidget {
  @override
  FollowPageState createState() => new FollowPageState();
}

class FollowPageState extends BaseListState<Item, FollowViewModel, FollowPage> {
  @override
  Widget getContentChild(FollowViewModel model) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(height: 0.5);
      },
      itemCount: model.itemList.length,
      itemBuilder: (context, index) {
        return FollowItemWidget(item: model.itemList[index]);
      },
    );
  }

  @override
  FollowViewModel get viewModel => FollowViewModel();
}
