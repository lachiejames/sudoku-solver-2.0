/// Stores stuff to assist with showing ads
library my_ad_helper;

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

final String appIdForAdMob = "ca-app-pub-6687326312027109~4201385146";

BannerAd _bannerAd;

Future<void> showNewBannerAd() async {
  assert(_bannerAd == null);
  _bannerAd = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.banner,
    targetingInfo: MobileAdTargetingInfo(
      testDevices: <String>[appIdForAdMob],
      keywords: <String>['puzzle'],
      contentUrl: 'http://foo.com/bar.html',
      childDirected: false,
      nonPersonalizedAds: false,
    ),
    listener: (MobileAdEvent event) async {
      await my_values.firebaseAnalytics.logEvent(name: 'banner_ad_event_${_mapAdEventToString(event)}');
    },
  );
  await _bannerAd.load();
  await _bannerAd.show();
}

Future<void> disposeBannerAd() async {
  assert(await _bannerAd.isLoaded());
  await _bannerAd.dispose();
  _bannerAd = null;
}

String _mapAdEventToString(MobileAdEvent event) {
  switch (event) {
    case MobileAdEvent.clicked:
      return "clicked";
    case MobileAdEvent.closed:
      return "closed";
    case MobileAdEvent.failedToLoad:
      return "failed_to_load";
    case MobileAdEvent.impression:
      return "impression";
    case MobileAdEvent.leftApplication:
      return "left_application";
    case MobileAdEvent.loaded:
      return "loaded";
    case MobileAdEvent.opened:
      return "opened";
    default:
      return "";
  }
}
