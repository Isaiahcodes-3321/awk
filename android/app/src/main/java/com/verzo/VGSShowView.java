package com.verzo;  // Replace with your actual package name

import android.content.Context;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import com.verygoodsecurity.vgsshow.VGSShow;
import com.verygoodsecurity.vgsshow.core.VGSEnvironment;

public class VGSShowView extends FrameLayout {

    private VGSShow vgsShow;

    public VGSShowView(@NonNull Context context) {
        super(context);
        init(context);
    }

    private void init(Context context) {
        vgsShow = new VGSShow(context, "tntpaxvvvet", new VGSEnvironment.Sandbox());
        // Add other initialization code here
    }

    public VGSShow getVgsShow() {
        return vgsShow;
    }
}
