//
//  UIView+MBProgressHUD.h
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgressHUD)

- (void)showLoadingImage;       /** 加载动图 可以交互 */
- (void)showLoadingImageFull;   /** 全屏显示禁止交互 */
- (void)showLoadingImage_noInf; /** 禁止交互  */
- (void)hideLoadingImage;       /** 隐藏动图  */

- (void)showMBProgressMessage:(NSString *)message;       /** 显示文字在导航控制器上  */
- (void)showMBProgressMessageSelfVC:(NSString *)message; /** 显示文字在当前控制器  */
- (void)hideMBProgressText;                              /** 隐藏文字  */

/** 成功图标 */
- (void)showSuccessHud:(NSString *)msg; /* 默认3.5秒消失 */
- (void)showSuccessHud:(NSString *)msg afterDelay:(NSTimeInterval)delay;
@end
