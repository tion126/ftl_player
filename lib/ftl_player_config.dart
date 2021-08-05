

class TXLivePlayConfig{
  ///【字段含义】播放器缓存时间，单位秒，取值需要大于0，默认值：5
  double? cacheTime;
  ///【字段含义】是否自动调整播放器缓存时间，默认值：YES
/// YES：启用自动调整，自动调整的最大值和最小值可以分别通过修改 maxCacheTime 和 minCacheTime 来设置
/// NO：关闭自动调整，采用默认的指定缓存时间(1s)，可以通过修改 cacheTime 来调整缓存时间
  bool? bAutoAdjustCacheTime;
  ///【字段含义】播放器缓存自动调整的最大时间，单位秒，取值需要大于0，默认值：5
  double? maxAutoAdjustCacheTime;
  ///【字段含义】播放器缓存自动调整的最小时间，单位秒，取值需要大于0，默认值为1
  double? minAutoAdjustCacheTime;
  ///【字段含义】播放器视频卡顿报警阈值，单位毫秒
///【推荐取值】800
///【特别说明】只有渲染间隔超过这个阈值的卡顿才会有 PLAY_WARNING_VIDEO_PLAY_LAG 通知
  int? videoBlockThreshold;
///【字段含义】播放器遭遇网络连接断开时 SDK 默认重试的次数，取值范围1 - 10，默认值：3。
  int? connectRetryCount;
  ///【字段含义】网络重连的时间间隔，单位秒，取值范围3 - 30，默认值：3。
  int? connectRetryInterval;

  /// 硬解是否开启 默认 false。
  bool? enableHWAcceleration;

  /// headers
  Map?  headers;
  
  TXLivePlayConfig({this.cacheTime,this.bAutoAdjustCacheTime,this.maxAutoAdjustCacheTime,this.minAutoAdjustCacheTime,this.videoBlockThreshold,this.connectRetryCount,this.enableHWAcceleration = false,this.headers});
}
