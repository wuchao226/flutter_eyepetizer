import 'package:eyepetizer/model/common_item.dart';
import 'package:eyepetizer/state/base_list_state.dart';
import 'package:eyepetizer/viewmodel/hot/hot_list_viewmodel.dart';
import 'package:eyepetizer/widget/list_item_widget.dart';
import 'package:flutter/material.dart';

class HotListPage extends StatefulWidget {
  final String apiUrl;

  const HotListPage({Key key, this.apiUrl}) : super(key: key);

  @override
  HotListPageState createState() => new HotListPageState();
}

class HotListPageState
    extends BaseListState<Item, HotListViewModel, HotListPage> {
  void init() {
    enablePullUp = false;
  }

  @override
  HotListViewModel get viewModel => HotListViewModel(widget.apiUrl);

  @override
  Widget getContentChild(HotListViewModel model) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListItemWidget(item: model.itemList[index]);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Divider(height: 0.5),
        );
      },
      itemCount: model.itemList.length,
    );
  }
}
