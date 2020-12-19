/// Stores stuff to assist with showing ads
library my_ad_helper;

import 'package:firebase_admob/firebase_admob.dart';

final String appIdForAdMob = "ca-app-pub-6687326312027109~4201385146";

BannerAd _bannerAd;

Future<void> showNewBannerAd() async {
  assert(_bannerAd==null);
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
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
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
