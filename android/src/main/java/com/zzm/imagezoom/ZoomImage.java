package com.zzm.imagezoom;

import android.support.annotation.Nullable;
import android.widget.ImageView;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.nostra13.universalimageloader.core.ImageLoader;

import uk.co.senab.photoview.PhotoView;

/**
 * Created by mags on 2016/11/22.
 */

public class ZoomImage extends SimpleViewManager<ZoomImage.PhotoViewWrapper> {
    ThemedReactContext reactContext = null;
    PhotoViewWrapper photoView;
    String uri = "";

    @Override
    public String getName() {
        return ZoomImage.class.getSimpleName();
    }

    @Override
    protected PhotoViewWrapper createViewInstance(final ThemedReactContext reactContext) {
        this.reactContext = reactContext;
        photoView = new PhotoViewWrapper(reactContext);
        photoView.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        return photoView;
    }

    @ReactProp(name = "uri")
    public void setUri(PhotoView photoViews, @Nullable String uri) {
        this.uri = uri;
        ImageLoader.getInstance().displayImage(uri, photoViews, ImageLoadOptions.mDefaultImgOptions);
    }

    public class PhotoViewWrapper extends PhotoView {

        public PhotoViewWrapper(ThemedReactContext context) {
            super(context);
        }

        @Override
        protected void onSizeChanged(int w, int h, int oldw, int oldh) {
            super.onSizeChanged(w, h, oldw, oldh);

            if (w > 0 && h > 0) {
                ImageLoader.getInstance().displayImage(uri, photoView, ImageLoadOptions.mDefaultImgOptions);
            }
        }
    }
}
