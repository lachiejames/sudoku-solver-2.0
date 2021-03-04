/// Stores stuff to assist with showing ads
part of './constants.dart';

const String androidAdMobID = 'ca-app-pub-6687326312027109/8826669012';
const String iosAdMobID = 'ca-app-pub-6687326312027109~1539205939';

BannerAd _bannerAd;

Future<void> initialiseAdMob() async {
  if (Platform.isAndroid) {
    await FirebaseAdMob.instance.initialize(appId: androidAdMobID);
  } else {
    await FirebaseAdMob.instance.initialize(appId: iosAdMobID);
  }
}

String getAdMobID() {
  if (Platform.isAndroid) {
    return androidAdMobID;
  } else {
    return iosAdMobID;
  }
}

Future<void> showNewBannerAd() async {
  _bannerAd = BannerAd(
    adUnitId: getAdMobID(),
    size: AdSize.banner,
    targetingInfo: const MobileAdTargetingInfo(
      keywords: <String>['sudoku', 'puzzle', 'camera', 'solve', 'solver'],
    ),
    listener: (MobileAdEvent event) async {
      await logEvent('banner_ad_event_${_mapAdEventToString(event)}');
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
      return 'clicked';
    case MobileAdEvent.closed:
      return 'closed';
    case MobileAdEvent.failedToLoad:
      return 'failed_to_load';
    case MobileAdEvent.impression:
      return 'impression';
    case MobileAdEvent.leftApplication:
      return 'left_application';
    case MobileAdEvent.loaded:
      return 'loaded';
    case MobileAdEvent.opened:
      return 'opened';
  }
  return '';
}
