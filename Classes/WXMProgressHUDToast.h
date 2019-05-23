//
//  WQGestureLockToast.h
//  Demo2
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXMProgressHUDToast : NSObject

/** 成功hud  */
+ (void)progressHUDToast:(NSString *)msg supView:(UIView *)sView afterDelay:(NSTimeInterval)delay;

@end
