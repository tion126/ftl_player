package com.example.ftl_player;

import android.content.Context;
import android.os.Bundle;
import android.view.Surface;

import androidx.annotation.NonNull;
import androidx.collection.ArrayMap;

import com.tencent.rtmp.ITXLivePlayListener;
import com.tencent.rtmp.TXLiveConstants;
import com.tencent.rtmp.TXLivePlayConfig;
import com.tencent.rtmp.TXLivePlayer;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.TextureRegistry;

public class FtlPlayer implements ITXLivePlayListener, MethodChannel.MethodCallHandler {
    private TXLivePlayer mLivePlayer;
    private final long textureId;
    private final TextureRegistry.SurfaceTextureEntry textureEntry;
    private final Surface surface;

    private final MethodChannel channel;
    /**
     * 当前播放状态
     */
    private int mCurrentPlayState = PlayerConst.PLAYSTATE_PLAYING;

    private boolean enableHWAcceleration;
    private final TXLivePlayConfig playConfig;
    private final Context context;

    public FtlPlayer(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, Map<String, Object> configParam) {
        TextureRegistry.SurfaceTextureEntry textureEntry = flutterPluginBinding.getTextureRegistry().createSurfaceTexture();
        textureId = textureEntry.id();
        this.textureEntry = textureEntry;
        surface = new Surface(textureEntry.surfaceTexture());

        this.context = flutterPluginBinding.getApplicationContext();
        playConfig = createConfig(configParam);

        init();

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins/ftl_player" + textureId);
        channel.setMethodCallHandler(this);
    }

    public long getTextureId() {
        return textureId;
    }

    private void init() {
        mLivePlayer = new TXLivePlayer(context);
        mLivePlayer.setConfig(playConfig);
        mLivePlayer.setRenderMode(TXLiveConstants.RENDER_MODE_ADJUST_RESOLUTION);
        mLivePlayer.setRenderRotation(TXLiveConstants.RENDER_ROTATION_PORTRAIT);
        mLivePlayer.setPlayListener(this);
        enableHWAcceleration = mLivePlayer.enableHardwareDecode(enableHWAcceleration);
        mLivePlayer.setSurface(surface);
    }

    private TXLivePlayConfig createConfig(Map<String, Object> param) {
        Float cacheTime = (Float) param.get("cacheTime");
        Boolean isAutoAdjustCacheTime = (Boolean) param.get("bAutoAdjustCacheTime");
        Float maxAutoAdjustCacheTime = (Float) param.get("maxAutoAdjustCacheTime");
        Float minAutoAdjustCacheTime = (Float) param.get("minAutoAdjustCacheTime");
        Integer videoBlockThreshold = (Integer) param.get("videoBlockThreshold");
        Integer connectRetryCount = (Integer) param.get("connectRetryCount");
        Integer connectRetryInterval = (Integer) param.get("connectRetryInterval");
        Boolean enableHWAcceleration = (Boolean) param.get("enableHWAcceleration");

        TXLivePlayConfig playConfig = new TXLivePlayConfig();
        if (cacheTime != null) {
            playConfig.setCacheTime(cacheTime);
        }
        if (isAutoAdjustCacheTime != null) {
            playConfig.setAutoAdjustCacheTime(isAutoAdjustCacheTime);
        }
        if (maxAutoAdjustCacheTime != null) {
            playConfig.setMaxAutoAdjustCacheTime(maxAutoAdjustCacheTime);
        }
        if (minAutoAdjustCacheTime != null) {
            playConfig.setMinAutoAdjustCacheTime(minAutoAdjustCacheTime);
        }
        if (videoBlockThreshold != null) {
            playConfig.setVideoBlockThreshold(videoBlockThreshold);
        }
        if (connectRetryCount != null) {
            playConfig.setConnectRetryCount(connectRetryCount);
        }
        if (connectRetryInterval != null) {
            playConfig.setConnectRetryInterval(connectRetryInterval);
        }
        if (enableHWAcceleration != null) {
            this.enableHWAcceleration = enableHWAcceleration;
        }
        return playConfig;
    }

    /**
     * 播放直播URL
     */
    public boolean play(String url, int playType) {
        if (mLivePlayer != null) {
            mLivePlayer.setPlayListener(this);
            // result返回值：0 success;  -1 empty url; -2 invalid url; -3 invalid playType;
            int result = mLivePlayer.startPlay(url, playType);
            if (result == 0) {
                mCurrentPlayState = PlayerConst.PLAYSTATE_PLAYING;
            } else {
                mCurrentPlayState = PlayerConst.PLAYSTATE_END;
            }
        } else {
            mCurrentPlayState = PlayerConst.PLAYSTATE_END;
        }
        return mCurrentPlayState == PlayerConst.PLAYSTATE_PLAYING;
    }

    private String url;
    private Integer type;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "start":
//                String url = call.argument("url");
//                Integer type = call.argument("type");
                 url = call.argument("url");
                 type = call.argument("type");
                result.success(play(url, type == null ? TXLivePlayer.PLAY_TYPE_VOD_HLS : type));
                break;
            case "pause":
                pause();
                updatePlayState(PlayerConst.PLAYSTATE_PAUSE);
                result.success(null);
                break;
            case "stop":
                stopPlay();
                updatePlayState(PlayerConst.PLAYSTATE_END);
                result.success(null);
                break;
            case "resume":
                resume();
                updatePlayState(PlayerConst.PLAYSTATE_PLAYING);
                result.success(null);
                break;
            case "dispose":
                dispose();
                result.success("dispose ok");

                channel.setMethodCallHandler(null);
                break;
            case "setEnableHWAcceleration":
                enableHWAcceleration = call.arguments();

                stopPlay();

                init();

                play(url, type == null ? TXLivePlayer.PLAY_TYPE_VOD_HLS : type);

                result.success(null);
                break;
            case "enableHWAcceleration":
                result.success(enableHWAcceleration);
                break;
            case "setMute":
                // 设置静音
                boolean isMute = call.arguments();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * 直播播放器回调
     * <p>
     * 具体可参考官网文档：https://cloud.tencent.com/document/product/881/20217
     *
     * @param event 事件id.id类型请参考 {@linkplain TXLiveConstants#PUSH_EVT_CONNECT_SUCC 播放事件列表}.
     * @param param 携带的信息键值对
     */
    @Override
    public void onPlayEvent(int event, Bundle param) {
        Map<String, Object> map = bundleToMap(param);
        map.put("playEvent", event);
        channel.invokeMethod("onPlayEvent", map);

        switch (event) {
            case TXLiveConstants.PLAY_EVT_VOD_PLAY_PREPARED: //视频播放开始
            case TXLiveConstants.PLAY_EVT_PLAY_BEGIN:
                updatePlayState(PlayerConst.PLAYSTATE_PLAYING);
                break;
            case TXLiveConstants.PLAY_ERR_NET_DISCONNECT:
            case TXLiveConstants.PLAY_EVT_PLAY_END:
                stopPlay();
                updatePlayState(PlayerConst.PLAYSTATE_END);
                break;
            case TXLiveConstants.PLAY_EVT_PLAY_LOADING:
                updatePlayState(PlayerConst.PLAYSTATE_LOADING);
                break;
            default:
                break;
        }
    }

    @Override
    public void onNetStatus(Bundle bundle) {
        Map<String, Object> map = bundleToMap(bundle);
        channel.invokeMethod("onNetStatus", map);
    }

    private Map<String, Object> bundleToMap(Bundle bundle) {
        Map<String, Object> map = new ArrayMap<>();
        for (String key : bundle.keySet()) {
            map.put(key, bundle.get(key));
        }
        return map;
    }

    private void dispose() {
        if (mLivePlayer != null) {
            mLivePlayer.setPlayListener(null);
            mLivePlayer.stopPlay(true);
        }
        textureEntry.release();
        if (surface != null) {
            surface.release();
        }
    }

    /**
     * 更新播放状态
     *
     * @param playState 播放状态
     */
    private void updatePlayState(int playState) {
        mCurrentPlayState = playState;
    }

    /**
     * 停止播放
     */
    private void stopPlay() {
        if (mLivePlayer != null) {
            mLivePlayer.setPlayListener(null);
            mLivePlayer.stopPlay(false);
        }
    }

    /**
     * 恢复播放
     */
    private void resume() {
        if (mLivePlayer != null) {
            mLivePlayer.resume();
        }
    }

    private void pause() {
        if (mLivePlayer != null) {
            mLivePlayer.pause();
        }
    }
}
