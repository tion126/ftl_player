#import "FtlPlayerPlugin.h"
#import "FtlPlayer.h"
#import "FtlOrientation.h"

@interface FtlPlayerPlugin()

@property ( weak , nonatomic)  NSObject<FlutterPluginRegistrar> *registrar;

@end

@implementation FtlPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"plugins/ftl_player"
                                     binaryMessenger:[registrar messenger]];
    
    FtlPlayerPlugin* instance = [[FtlPlayerPlugin alloc] init];
    instance.registrar = registrar;
    [registrar addMethodCallDelegate:instance channel:channel];
    [FtlOrientation registerWithRegistrar:registrar];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    if (!args || ![args isKindOfClass:NSDictionary.class]) {
        args = @{};
    }
    
    if ([@"init" isEqualToString:call.method]) {
        FtlPlayer *player = [[FtlPlayer alloc] initWithConfigs:call.arguments registrar:self.registrar];
        result(@(player.textureId));
    }else {
        result(FlutterMethodNotImplemented);
    }
}

@end
