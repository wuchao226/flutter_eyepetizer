import 'package:eyepetizer/http/Url.dart';
import 'package:eyepetizer/model/discovery/topic_model.dart';
import 'package:eyepetizer/viewmodel/base_list_viewmodel.dart';

class TopicViewModel extends BaseListViewModel<TopicItemModel, TopicModel> {
  @override
  String getUrl() {
    return Url.topicsUrl;
  }

  @override
  TopicModel getModel(Map<String, dynamic> json) {
    return TopicModel.fromJson(json);
  }
}
