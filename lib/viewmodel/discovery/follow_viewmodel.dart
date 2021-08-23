import 'package:eyepetizer/http/Url.dart';
import 'package:eyepetizer/model/common_item.dart';

import '../base_list_viewmodel.dart';
/// 发现页->关注页 ViewModel
class FollowViewModel extends BaseListViewModel<Item, Issue> {
  @override
  Issue getModel(Map<String, dynamic> json) {
    return Issue.fromJson(json);
  }

  @override
  String getUrl() {
    return Url.followUrl;
  }
}
