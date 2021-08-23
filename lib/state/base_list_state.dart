import 'package:eyepetizer/model/paging_model.dart';
import 'package:eyepetizer/viewmodel/base_list_viewmodel.dart';
import 'package:eyepetizer/widget/loading_state_widget.dart';
import 'package:eyepetizer/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseListState<L, M extends BaseListViewModel<L, PagingModel<L>>,
        T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  //真实获取数据的仓库
  M get viewModel;

  //真实的分页控件
  Widget getContentChild(M model);

  // 下拉刷新
  bool enablePullDown = true;

  // 上来加载
  bool enablePullUp = true;

  // 初始化操作
  void init() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    init();
    return ProviderWidget<M>(
      model: viewModel,
      onModelInit: (model) => model.refresh(),
      builder: (context, model, child) {
        return LoadingStateWidget(
          viewState: model.viewState,
          retry: model.retry,
          child: Container(
            color: Colors.white,
            child: SmartRefresher(
              controller: model.refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              enablePullUp: enablePullUp,
              enablePullDown: enablePullDown,
              // 显示的界面
              child: getContentChild(model),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
