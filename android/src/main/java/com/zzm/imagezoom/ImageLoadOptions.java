package com.zzm.imagezoom;

import com.nostra13.universalimageloader.core.DisplayImageOptions;

public class ImageLoadOptions {

	public static DisplayImageOptions mDefaultImgOptions = new DisplayImageOptions.Builder()
			.showImageForEmptyUri(R.drawable.icon_default_broken_3)
			.showImageOnFail(R.drawable.icon_default_broken_3)
			.showImageOnLoading(R.drawable.icon_loading_progress)
			.cacheInMemory(true).cacheOnDisk(true).considerExifParams(true)
			.build();
}
