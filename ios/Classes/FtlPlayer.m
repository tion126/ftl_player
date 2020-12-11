

#import "FtlPlayer.h"
#import <libkern/OSAtomic.h>

@interface FtlPlayer()<TXLivePlayListener,FlutterTexture,TXVideoCustomProcessDelegate,FlutterPlugin>

@property ( weak , nonatomic)  NSObject<FlutterPluginRegistrar> *registrar;
@property ( strong , nonatomic) FlutterMethodChannel* channel;
@property ( strong , nonatomic) NSMutableDictionary * configs;
@property (  copy  , nonatomic) NSString            * url;
@property ( assign , nonatomic) TX_Enum_PlayType      type;
@end

@implementation FtlPlayer{
    CVPixelBufferRef volatile _latestPixelBuffer;
    CVPixelBufferRef _lastBuffer;
}

#pragma mark - init

-(instancetype)initWithConfigs:(NSDictionary *)configs registrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    if (self = [super init]) {
        
        self.registrar = registrar;
        self.textureId = [[registrar textures] registerTexture:self];
        self.channel = [FlutterMethodChannel
                        methodChannelWithName:[NSString stringWithFormat:@"plugins/ftl_player%lld",self.textureId]
                        binaryMessenger:[registrar messenger]];;
        [registrar addMethodCallDelegate:self channel:self.channel];
        [self initPlayer:configs];
    }
    return self;
}

- (void)initPlayer:(NSDictionary *)configs{
    
    if (self.player) {
        [self.player stopPlay];
        TXLivePlayer *livePlayer = [TXLivePlayer new];
        livePlayer.config = self.player.config;
        livePlayer.enableHWAcceleration = self.player.enableHWAcceleration;
        
        self.player = livePlayer;
        self.player.delegate = self;
        self.player.videoProcessDelegate = self;
        [self.player startPlay:self.url type:self.type];
    }else{
        self.player = [TXLivePlayer new];
        TXLivePlayConfig *livePlayConfig = [TXLivePlayConfig new];
        NSMutableDictionary *tmp = configs.mutableCopy;
        self.player.enableHWAcceleration = [tmp[@"enableHWAcceleration"] boolValue];
        [tmp removeObjectForKey:@"enableHWAcceleration"];
        [livePlayConfig setValuesForKeysWithDictionary:tmp];
        
        self.player.config = livePlayConfig;
        self.player.delegate = self;
        self.player.videoProcessDelegate = self;
    }
    
}


#pragma mark - FlutterTexture

- (CVPixelBufferRef)copyPixelBuffer {
    CVPixelBufferRef pixelBuffer = _latestPixelBuffer;
    while (!OSAtomicCompareAndSwapPtrBarrier(pixelBuffer, nil,
                                             (void **)&_latestPixelBuffer)) {
        pixelBuffer = _latestPixelBuffer;
    }
    return pixelBuffer;
}


#pragma mark - TXLivePlayListener

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    
    NSMutableDictionary *merge = [NSMutableDictionary dictionaryWithDictionary:param];
    merge[@"playEvent"] = @(EvtID);
    [self.channel invokeMethod:@"onPlayEvent" arguments:merge.copy];
}

- (void)onNetStatus:(NSDictionary *)param {
    [self.channel invokeMethod:@"onNetStatus" arguments:param];
}


#pragma mark - TXVideoCustomProcessDelegate

- (BOOL)onPlayerPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    
    if (_lastBuffer == nil) {
        _lastBuffer = CVPixelBufferRetain(pixelBuffer);
        CFRetain(pixelBuffer);
    } else if (_lastBuffer != pixelBuffer) {
        CVPixelBufferRelease(_lastBuffer);
        _lastBuffer = CVPixelBufferRetain(pixelBuffer);
        CFRetain(pixelBuffer);
    }
    
    CVPixelBufferRef newBuffer = pixelBuffer;
    
    CVPixelBufferRef old = _latestPixelBuffer;
    while (!OSAtomicCompareAndSwapPtrBarrier(old, newBuffer,
                                             (void **)&_latestPixelBuffer)) {
        old = _latestPixelBuffer;
    }
    
    if (old && old != pixelBuffer) {
        CFRelease(old);
    }
    [[self.registrar textures] textureFrameAvailable:self.textureId];
    return NO;
}

#pragma mark -  method channel call

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    if (!args || ![args isKindOfClass:NSDictionary.class]) {
        args = @{};
    }
    
    if ([@"start" isEqualToString:call.method]) {
        self.url = args[@"url"];
        self.type = [args[@"type"] integerValue];
        result(@([self start:self.url type:self.type]));
    }else if ([@"pause" isEqualToString:call.method]) {
        [self pause];
        result(nil);
    }else if ([@"stop" isEqualToString:call.method]) {
        [self stop];
        result(nil);
    }else if ([@"resume" isEqualToString:call.method]) {
        [self resume];
        result(nil);
    }else if ([@"setEnableHWAcceleration" isEqualToString:call.method]) {
        BOOL enable = [NSString stringWithFormat:@"%@",call.arguments].boolValue;
        [self setEnableHWAcceleration:enable];
        result(nil);
    }else if ([@"enableHWAcceleration" isEqualToString:call.method]) {
        result(@(self.player.enableHWAcceleration));
    }else if ([@"setMute" isEqualToString:call.method]) {
        BOOL mute = [NSString stringWithFormat:@"%@",call.arguments].boolValue;
        [self setMute:mute];
        result(nil);
    }else if ([@"dispose" isEqualToString:call.method]) {
        [self dispose];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(BOOL)start:(NSString *)url type:(TX_Enum_PlayType)type{
    return ![self.player startPlay:url type:type];
}

- (void)pause{
    [self.player pause];
}

- (void)resume{
    [self.player resume];
}

- (void)stop{
    [self.player stopPlay];
}

- (void)setEnableHWAcceleration:(BOOL)enable{
    [self.player setEnableHWAcceleration:enable];
    [self initPlayer:nil];
}

- (void)setMute:(BOOL)mute{
    [self.player setMute:mute];
}

- (void)dispose {
    [self.player stopPlay];
    CVPixelBufferRef old = _latestPixelBuffer;
    while (!OSAtomicCompareAndSwapPtrBarrier(old, nil,
                                             (void **)&_latestPixelBuffer)) {
        old = _latestPixelBuffer;
    }
    if (old) {
        CFRelease(old);
    }
    
    if (_lastBuffer) {
        CVPixelBufferRelease(_lastBuffer);
        _lastBuffer = nil;
    }
    
    [[self.registrar textures] unregisterTexture:self.textureId];
}


+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {}


@end
