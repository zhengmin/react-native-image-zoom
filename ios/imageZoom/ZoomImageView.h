//
//  ZoomImageView.h
//  zapda
//
//  Created by 郑章民 on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>

@interface ZoomImageView : UIView

@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) RCTBubblingEventBlock onTap;

@end
