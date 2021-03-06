//
//  UIViewController+MBProgressHUD.h
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MBProgressHUD)

/** YES表示当前Controller 1s内不可显示菊花 */
@property (nonatomic, assign) BOOL hideErrorProgressHUD;

- (void)showLoadingImage;       /** 加载动图 可以交互 */
- (void)showLoadingImageFull;   /** 禁止交互(全屏) */
- (void)showLoadingImage_noInf; /** 禁止交互(非全屏)  */
- (void)hideLoadingImage;       /** 隐藏动图  */

/** 显示hud并且关闭手势  */
- (void)showLoadingForbid;
- (void)hideLoadingForbid;

/** 成功图标 */
- (void)showSuccessHud:(NSString *)msg;
- (void)showSuccessHud:(NSString *)msg afterDelay:(NSTimeInterval)delay;

- (void)showMBProgressMessage:(NSString *)message;       /** 显示文字在导航控制器上  */
- (void)showMBProgressMessageSelfVC:(NSString *)message; /** 显示文字在当前控制器  */
- (void)hideMBProgressText;                              /** 隐藏文  */
- (void)hideMBProgressAllText;                           /** 隐藏所有  */
@end
