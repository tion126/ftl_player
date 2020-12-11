#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import <TXLiteAVSDK_Player/TXLiteAVSDK.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface FtlPlayer : NSObject
/**
 * 播放器
 */
@property(nonatomic,strong) TXLivePlayer        *player;

/**
 * id
 */
@property(nonatomic,assign) int64_t textureId;
/**
 * 初始化
 */
- (instancetype)initWithConfigs:(NSDictionary *)configs registrar:(NSObject<FlutterPluginRegistrar> *)registrar;

@end

NS_ASSUME_NONNULL_END
