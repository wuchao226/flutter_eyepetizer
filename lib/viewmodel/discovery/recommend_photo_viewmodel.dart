import 'package:eyepetizer/viewmodel/base_change_notifier.dart';

class RecommendPhotoViewModel extends BaseChangeNotifier {
  int currentIndex = 1;

  void changeIndex(int index) {
    this.currentIndex = index + 1;
    notifyListeners();
  }
}
