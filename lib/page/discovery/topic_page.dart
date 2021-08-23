import 'package:animations/animations.dart';
import 'package:eyepetizer/model/discovery/topic_model.dart';
import 'package:eyepetizer/page/discovery/topic_detail_page.dart';
import 'package:eyepetizer/state/base_list_state.dart';
import 'package:eyepetizer/utils/cache_image.dart';
import 'package:eyepetizer/viewmodel/discovery/topic_viewmodel.dart';
import 'package:flutter/material.dart';

/// 发现页——>专题页
class TopicPage extends StatefulWidget {
  @override
  TopicPageState createState() => new TopicPageState();
}

class TopicPageState
    extends BaseListState<TopicItemModel, TopicViewModel, TopicPage> {
  @override
  TopicViewModel get viewModel => TopicViewModel();

  @override
  Widget getContentChild(TopicViewModel model) {
    return ListView.separated(
      itemCount: model.itemList.length,
      itemBuilder: (context, index) {
        return OpenContainer(
          closedBuilder: (context, action) {
            return _closedWidget(model.itemList[index]);
          },
          openBuilder: (context, action) {
            return TopicDetailPage(detailId: model.itemList[index].data.id);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0.5,
        );
      },
    );
  }

  Widget _closedWidget(item) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        child: cacheImage(
          item.data.image,
          width: MediaQuery.of(context).size.width,
          height: 200,
        ), //充满容器，可能会被截断
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
