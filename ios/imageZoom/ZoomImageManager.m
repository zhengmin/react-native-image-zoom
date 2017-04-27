//
//  ZoomImageManager.m
//  zapda
//
//  Created by 郑章民 on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ZoomImageManager.h"
#import "ZoomImageView.h"

@interface ZoomImageManager()

@end

@implementation ZoomImageManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [ZoomImageView new];
}

RCT_EXPORT_VIEW_PROPERTY(uri, NSString)
RCT_EXPORT_VIEW_PROPERTY(onTap, RCTBubblingEventBlock)

@end
