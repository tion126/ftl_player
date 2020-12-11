package com.example.ftl_player;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FtlPlayerPlugin
 */
public class FtlPlayerPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private MethodChannel orientationChannel;

    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins/ftl_player");
        channel.setMethodCallHandler(this);

        orientationChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins/ftl_player/orientation");
        orientationChannel.setMethodCallHandler(new OrientationMethodCallHandler(orientationChannel, flutterPluginBinding.getApplicationContext()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if ("init".equals(call.method)) {
            @SuppressWarnings("unchecked")
            FtlPlayer player = new FtlPlayer(flutterPluginBinding, (Map<String, Object>) call.arguments);
            result.success(player.getTextureId());
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        orientationChannel.setMethodCallHandler(null);
    }
}
