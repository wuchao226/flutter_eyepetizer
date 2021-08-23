import 'package:eyepetizer/viewmodel/base_viewmodel.dart';
import 'package:eyepetizer/widget/loading_state_widget.dart';
import 'package:eyepetizer/widget/provider_widget.dart';
import 'package:flutter/material.dart';

abstract class BaseState<M extends BaseViewModel, T extends StatefulWidget>
    extends State<T> with AutomaticKeepAliveClientMixin {
  //真实获取数据的仓库
  M get viewModel;

  //真实的分页控件
  Widget getContentChild(M model);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<M>(
      model: viewModel,
      onModelInit: (model) => model.refresh(),
      builder: (context, model, child) {
        return LoadingStateWidget(
          viewState: model.viewState,
          retry: model.retry,
          child: getContentChild(model),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
