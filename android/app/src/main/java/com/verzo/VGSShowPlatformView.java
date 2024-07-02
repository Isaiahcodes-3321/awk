package com.verzo;  // Replace with your actual package name

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;

import io.flutter.plugin.platform.PlatformView;

public class VGSShowPlatformView implements PlatformView {

    private final VGSShowView vgsShowView;

    VGSShowPlatformView(@NonNull Context context) {
        vgsShowView = new VGSShowView(context);
    }

    @NonNull
    @Override
    public View getView() {
        return vgsShowView;
    }

    @Override
    public void dispose() {}
}
