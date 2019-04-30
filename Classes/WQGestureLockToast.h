//
//  WQGestureLockToast.h
//  Demo2
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WQGestureLockToast : NSObject

/** 成功hud  */
+ (void)showHUD:(NSString *)msg inView:(UIView *)sView afterDelay:(NSTimeInterval)delay;

@end
