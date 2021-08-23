import 'dart:convert';

import 'package:eyepetizer/model/common_item.dart';
import 'package:eyepetizer/utils/cache_manager.dart';

/// 观看记录 数据存储及查询
class HistoryRepository {
  static const String watch_history_list_key = "watch_history_list";

  /// 存储观看记录  用于视频详情页面 VideoDetailPage
  static saveWatchHistory(Data data) async {
    List<String> watchList = loadHistoryData();

    var jsonParam = data.toJson();
    var jsonStr = json.encode(jsonParam);
    if (!watchList.contains(jsonStr)) {
      watchList.add(jsonStr);
      CacheManager.getInstance().set(watch_history_list_key, watchList);
    }
  }

  /// 查询观看记录
  static List<String> loadHistoryData() {
    List<dynamic> originList =
        CacheManager.getInstance().get<List<dynamic>>(watch_history_list_key);

    List<String> watchList;
    if (originList == null) {
      watchList = [];
    } else {
      watchList = originList.map((e) => e.toString()).toList();
    }
    return watchList;
  }

  static saveHistoryData(List<String> watchHistoryList) {
    CacheManager.getInstance().set(watch_history_list_key, watchHistoryList);
  }
}
