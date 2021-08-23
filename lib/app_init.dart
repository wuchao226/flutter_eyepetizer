import 'package:eyepetizer/http/Url.dart';
import 'package:eyepetizer/utils/cache_manager.dart';
import 'package:eyepetizer/utils/logger_util.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

class AppInit {
  /// 私有构造方法
  AppInit._();

  static Future<void> init() async {
    Url.baseUrl = 'http://baobab.kaiyanapp.com/api/';
    LoggerUtil.init(isLog: true);
    await CacheManager.preInit();
    Future.delayed(Duration(milliseconds: 2000), () {
      FlutterSplashScreen.hide();
    });
  }
}
