import 'package:eyepetizer/config/color.dart';
import 'package:eyepetizer/config/string.dart';
import 'package:flutter/material.dart';

enum ViewState { loading, done, error }

class LoadingStateWidget extends StatelessWidget {
  // 加载状态
  final ViewState viewState;

  // 重试
  final VoidCallback retry;

  // 加载成功后显示的内容
  final Widget child;

  LoadingStateWidget({
    Key key,
    this.viewState,
    this.retry,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewState == ViewState.loading) {
      return _loadingView;
    } else if (viewState == ViewState.error) {
      return _errorView;
    } else {
      return child;
    }
  }

  /// 加载中 view
  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  /// 加载失败 view
  Widget get _errorView {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/ic_error.png',
            width: 100,
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              StringConfig.net_request_fail,
              style: TextStyle(
                color: ColorConfig.hitTextColor,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: OutlinedButton(
              onPressed: retry,
              child: Text(
                StringConfig.reload_again,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
