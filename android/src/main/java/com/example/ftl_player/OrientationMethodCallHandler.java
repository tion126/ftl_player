package com.example.ftl_player;

import android.content.Context;
import android.provider.Settings;
import android.view.OrientationEventListener;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class OrientationMethodCallHandler implements MethodChannel.MethodCallHandler {
    private static final int PORTRAIT_UP = 0;
    private static final int LANDSCAPE_LEFT = 1;
    private static final int PORTRAIT_DOWN = 2;
    private static final int LANDSCAPE_RIGHT = 3;
    private final OrientationEventListener eventListener;
    private int currentOrientation = PORTRAIT_UP;

    public OrientationMethodCallHandler(final MethodChannel channel, final Context appContext) {
        eventListener = new OrientationEventListener(appContext) {
            @Override
            public void onOrientationChanged(int orientation) {
                //手机平放时，检测不到有效的角度
                if (orientation == OrientationEventListener.ORIENTATION_UNKNOWN) {
                    return;
                }

                if (isScreenChangeLock(appContext)) {
                    return;
                }

                if (orientation > 340 || orientation < 20) {
                    currentOrientation = PORTRAIT_UP;
                    channel.invokeMethod("orientation", currentOrientation);
                } else if (orientation > 160 && orientation < 200) {
                    currentOrientation = PORTRAIT_DOWN;
                    channel.invokeMethod("orientation", currentOrientation);
                } else if (orientation > 70 && orientation < 110) {
                    currentOrientation = LANDSCAPE_RIGHT;
                    channel.invokeMethod("orientation", currentOrientation);
                } else if (orientation > 250 && orientation < 290) {
                    currentOrientation = LANDSCAPE_LEFT;
                    channel.invokeMethod("orientation", currentOrientation);
                }
            }
        };
    }

    private boolean isScreenChangeLock(Context context) {
        try {
            // 重力感应 1 表示已开启 0表示未开启
            return Settings.System.getInt(context.getContentResolver(), Settings.System.ACCELEROMETER_ROTATION) == 0;
        } catch (Exception e) {
            return true;
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "start":
                eventListener.enable();
                result.success(currentOrientation);
                break;
            case "stop":
                eventListener.disable();
                result.success(currentOrientation);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
