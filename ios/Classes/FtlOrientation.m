

#import "FtlOrientation.h"

@interface FtlOrientation()

@property ( strong , nonatomic) FlutterMethodChannel *channel;
@end

@implementation FtlOrientation

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([@"start" isEqualToString:call.method]) {
        [self start];
    }else if([@"stop" isEqualToString:call.method]){
        [self stop];
    }else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)start{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationWillChange:(NSNotification *)notification{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSInteger value = 1;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            value = 0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            value = 2;
            break;
        case UIDeviceOrientationLandscapeLeft:
            value = 3;
            break;
        case UIDeviceOrientationLandscapeRight:
            value = 1;
            break;
        default:
            return;
            break;
    }
    
    [self.channel invokeMethod:@"orientation" arguments:@(value)];

}

- (void)stop {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"plugins/ftl_player/orientation"
                                     binaryMessenger:[registrar messenger]];
    
    FtlOrientation * instance = [[FtlOrientation alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

@end
