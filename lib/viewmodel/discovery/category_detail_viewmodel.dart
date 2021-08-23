import 'package:eyepetizer/http/Url.dart';
import 'package:eyepetizer/model/common_item.dart';
import 'package:eyepetizer/viewmodel/base_list_viewmodel.dart';

class CategoryDetailViewModel extends BaseListViewModel<Item, Issue> {
  // 区分点击的那个分类，必须传
  int categoryId;
  List<Item> itemList = [];

  CategoryDetailViewModel(this.categoryId);

  @override
  String getUrl() {
    return Url.categoryVideoUrl +
        "id=$categoryId&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=Android";
  }

  @override
  String getNextUrl(Issue model) {
    return model.nextPageUrl +
        "&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=Android";
  }

  @override
  Issue getModel(Map<String, dynamic> json) => Issue.fromJson(json);
}
