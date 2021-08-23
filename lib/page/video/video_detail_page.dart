import 'package:eyepetizer/config/string.dart';
import 'package:eyepetizer/model/common_item.dart';
import 'package:eyepetizer/utils/cache_image.dart';
import 'package:eyepetizer/utils/date_util.dart';
import 'package:eyepetizer/utils/history_repository.dart';
import 'package:eyepetizer/utils/navigator_util.dart';
import 'package:eyepetizer/viewmodel/video/video_detail_viewmodel.dart';
import 'package:eyepetizer/widget/loading_state_widget.dart';
import 'package:eyepetizer/widget/provider_widget.dart';
import 'package:eyepetizer/widget/video/video_item_widget.dart';
import 'package:eyepetizer/widget/video/video_play_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const VIDEO_SMALL_CARD_TYPE = 'videoSmallCard';

/// 视频详情页面
class VideoDetailPage extends StatefulWidget {
  final Data videoData;

  VideoDetailPage({Key key, this.videoData}) : super(key: key);

  @override
  VideoDetailPageState createState() => new VideoDetailPageState();
}

class VideoDetailPageState extends State<VideoDetailPage>
    with WidgetsBindingObserver {
  // 允许element在树周围移动(改变父节点), 而不会丢失状态
  // GlobalKey 能够跨 Widget 访问状态
  // 在两个不同的屏幕上显示相同的widget，并保持状态相同。
  final GlobalKey<VideoPlayWidgetState> videoKey = GlobalKey();
  Data data;

  @override
  void initState() {
    super.initState();
    // TODO:获取路由传过来的数据
    data = widget.videoData == null ? arguments() : widget.videoData;
    // 监听页面可见与不可见状态
    WidgetsBinding.instance.addObserver(this);
    // 存储观看记录
    HistoryRepository.saveWatchHistory(data);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //AppLifecycleState当前页面的状态(是否可见)
    if (state == AppLifecycleState.paused) {
      // 页面不可见时,暂停视频
      // videoKey.currentState：树中当前具有此全局密钥的小部件的State对象
      videoKey.currentState.pause();
    } else if (state == AppLifecycleState.resumed) {
      videoKey.currentState.play();
    }
  }

  @override
  void dispose() {
    //移除监听页面可见与不可见状态
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<VideoDetailViewModel>(
      model: VideoDetailViewModel(),
      onModelInit: (model) => model.loadVideoData(data.id),
      builder: (context, model, child) {
        return _scaffold(model);
      },
    );
  }

  Widget _scaffold(VideoDetailViewModel model) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // AnnotatedRegion：改变状态栏内容的颜色
          AnnotatedRegion(
            // 设置状态栏的背景色为黑色
            child: _statusBar(),
            value: SystemUiOverlayStyle.light,
          ),
          //Hero动画--视频播放
          Hero(
            tag: '${data.id}${data.time}',
            child: VideoPlayWidget(
              key: videoKey,
              url: data.playUrl,
            ),
          ),
          // Expanded：强制填满剩余空间
          Expanded(
            flex: 1,
            child: LoadingStateWidget(
              viewState: model.viewState,
              retry: model.retry,
              child: Container(
                // 设置背景色
                decoration: _decoration(),
                // CustomScrollView结合Sliver可以防止滚动冲突
                // 自定义组合滑动
                child: CustomScrollView(
                  slivers: <Widget>[
                    // 基础控件
                    _sliverToBoxAdapter(),
                    // 推荐其他视频
                    _sliverList(model),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 设置状态栏的背景色为黑色
  _statusBar() {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: Colors.black,
    );
  }

  /// 设置背景色
  Decoration _decoration() {
    return BoxDecoration(
      image: DecorationImage(
        //背景图片
        fit: BoxFit.cover,
        // http://img.kaiyanapp.com/2129708dda66e25ae11490a2402603d5.jpeg?imageMogr2/quality/60/format/jpg}/thumbnail/300x600
        image: cachedNetworkImageProvider(
            '${data.cover.blurred}}/thumbnail/${MediaQuery.of(context).size.height}x${MediaQuery.of(context).size.width}'),
      ),
    );
  }

  /// SliverToBoxAdapter：与CustomScrollView配合使用，包含普通组件（CustomScrollView只能包含sliver系列组件）
  Widget _sliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 视频标题
          _videoTitle(),
          // 视频分类及上架时间
          _videoTime(),
          // 视频描述
          _videoDescription(),
          // 视频的状态：点赞，转发，评论
          _videoState(),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Divider(height: 0.5, color: Colors.white)),
          // 视频作者等介绍
          _videoAuthor(),
          Divider(height: 0.5, color: Colors.white),
        ],
      ),
    );
  }

  /// 视频标题
  _videoTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Text(
        data.title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 视频分类及上架时间
  Widget _videoTime() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Text(
        '#${data.category} / ${formatDateMsByYMDHM(data.author.latestReleaseTime)}',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  /// 视频描述
  Widget _videoDescription() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Text(
        data.description,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  /// 视频的状态：点赞，转发，评论
  Widget _videoState() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10),
      // 水平 LinearLayout
      child: Row(
        children: <Widget>[
          _row('images/ic_like.png', '${data.consumption.collectionCount}'),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: _row(
                'images/ic_share_white.png', '${data.consumption.shareCount}'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: _row(
                'images/icon_comment.png', '${data.consumption.replyCount}'),
          ),
        ],
      ),
    );
  }

  Widget _row(String image, String text) {
    return Row(
      children: <Widget>[
        Image.asset(
          image,
          height: 22,
          width: 22,
        ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }

  /// 视频作者等介绍
  Widget _videoAuthor() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: ClipOval(
            child: cacheImage(data.author.icon, height: 40, width: 40),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(data.author.name,
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  data.author.description,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5),
            child: Text(
              StringConfig.add_follow,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 推荐其他视频
  Widget _sliverList(model) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (model.itemList[index].type == VIDEO_SMALL_CARD_TYPE) {
            return VideoItemWidget(
              data: model.itemList[index].data,
              callBack: () {
                // 自己出栈
                Navigator.pop(context);
                // TODO:路由跳转
                toPage(VideoDetailPage(videoData: model.itemList[index].data));
              },
            );
          }
          // 推荐的视频属于那个类型
          return Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              model.itemList[index].data.text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          );
        },
        childCount: model.itemList.length,
      ),
    );
  }
}
