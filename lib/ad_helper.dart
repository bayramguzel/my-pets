import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2100987662328122/3617207886';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2100987662328122/3617207886';
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }
}
