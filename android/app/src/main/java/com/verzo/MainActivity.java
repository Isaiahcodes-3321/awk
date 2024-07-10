package com.verzo;  // Replace with your actual package name

import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformViewRegistry;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        PlatformViewRegistry registry = flutterEngine.getPlatformViewsController().getRegistry();
        registry.registerViewFactory("VGSShowView", new VGSShowViewFactory());
    }
}

