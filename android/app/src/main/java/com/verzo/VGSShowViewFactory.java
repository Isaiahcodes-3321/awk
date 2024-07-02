package com.verzo;  // Replace with your actual package name

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;

public class VGSShowViewFactory extends PlatformViewFactory {

    public VGSShowViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int viewId, Object args) {
        return new VGSShowPlatformView(context);
    }
}
