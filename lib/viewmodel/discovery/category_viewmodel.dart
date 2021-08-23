import 'package:eyepetizer/http/Url.dart';
import 'package:eyepetizer/http/http_manager.dart';
import 'package:eyepetizer/model/discovery/category_model.dart';
import 'package:eyepetizer/utils/toast_util.dart';
import 'package:eyepetizer/viewmodel/base_viewmodel.dart';
import 'package:eyepetizer/widget/loading_state_widget.dart';

/// 发现页->分类页 ViewModel
class CategoryViewModel extends BaseViewModel {
  List<CategoryModel> list = [];

  @override
  void refresh() async {
    HttpManager.getData(
      Url.categoryUrl,
      success: (result) {
        list = (result as List)
            .map((model) => CategoryModel.fromJson(model))
            .toList();
        viewState = ViewState.done;
      },
      fail: (e) {
        ToastUtils.showError(e.toString());
        viewState = ViewState.error;
      },
      complete: () => notifyListeners(),
    );
  }
}
