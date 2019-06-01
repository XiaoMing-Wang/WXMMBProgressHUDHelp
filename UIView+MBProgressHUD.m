//
//  UIView+MBProgressHUD.m
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//
#define MB_SWidth [UIScreen mainScreen].bounds.size.width
#define MB_Indeterminate 10000
#define MB_HudModeTex 10001
#define MB_HudDelay 3.5f
#define MB_LabelFont 15.5
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "WXMProgressHUDToast.h"

@implementation UIView (MBProgressHUD)

/** 显示弹窗 */
- (void)showLoadingImage {
    [self hideMBProgressText];
    MBProgressHUD * interactionHUD = [self creatIndeterminateHudWithView:self];
    interactionHUD.userInteractionEnabled = NO;
    interactionHUD.tag = MB_Indeterminate;
}
- (void)showLoadingImage_noInf {
    [self hideMBProgressText];
    MBProgressHUD * interactionHUD = [self creatIndeterminateHudWithView:self];
    interactionHUD.userInteractionEnabled = YES;
    interactionHUD.tag = MB_Indeterminate;
}
- (void)showLoadingImageFull {
    [self hideMBProgressText];
    MBProgressHUD * interactionHUD = [self creatIndeterminateHudWithView:self];
    UIColor * color = [UIColor colorWithRed:(235)/255.0f green:(235)/255.0f blue:(235)/255.0f alpha:1];
    interactionHUD.backgroundColor = color;
    interactionHUD.userInteractionEnabled = YES;
    interactionHUD.tag = MB_Indeterminate;
}

/** 隐藏 */
- (void)hideLoadingImage {
    NSArray * hudArray = [MBProgressHUD allHUDsForView:self];
    [hudArray enumerateObjectsUsingBlock:^(MBProgressHUD *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == MB_Indeterminate) [obj hide:NO];
    }];
}
/** 显示在导航控制器上  */
- (void)showMBProgressMessage:(NSString *)message {
    [self hideLoadingImage];
    MBProgressHUD * hud = [self creatModeTextHudWithView:self message:message];
    hud.tag = MB_HudModeTex;
}
/** 显示在当前控制器  */
- (void)showMBProgressMessageSelfVC:(NSString *)message {
    MBProgressHUD * hud = [self creatModeTextHudWithView:self message:message];
    [hud hide:NO afterDelay:MB_HudDelay];
    hud.tag = MB_HudModeTex;
}
/** 隐藏文字  */
- (void)hideMBProgressText {
    NSArray * hudArray = [MBProgressHUD allHUDsForView:self];
    [hudArray enumerateObjectsUsingBlock:^(MBProgressHUD *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == MB_HudModeTex) [obj hide:NO];
    }];
}
/** 转圈 */
- (MBProgressHUD *)creatIndeterminateHudWithView:(UIView *)superView {
    NSArray * hudArray =[MBProgressHUD allHUDsForView:superView];
    MBProgressHUD *hud = nil;
    if (hudArray.count > 0) hud = hudArray.lastObject;
    else hud = [MBProgressHUD showHUDAddedTo:superView animated:NO];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    hud.dimBackground = NO;
    return hud;
}
/** text */
- (MBProgressHUD *)creatModeTextHudWithView:(UIView *)superView message:(NSString *)message {
    NSArray *hudArray = [MBProgressHUD allHUDsForView:superView];
    MBProgressHUD *hud = nil;
    if (hudArray.count > 0) hud = hudArray.lastObject;
    else hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];;
    hud.margin = 15;
    hud.yOffset = 0;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    /** 取消之前的隐藏动画 重新计时 */
    [NSObject cancelPreviousPerformRequestsWithTarget:hud selector:@selector(hide:) object:nil];
    [hud performSelector:@selector(hide:) withObject:nil afterDelay:MB_HudDelay];
    
    BOOL haveSpace = [message rangeOfString:@"\n"].location != NSNotFound;
    CGFloat width = [self getSizeWithString:message font:MB_LabelFont width:MB_SWidth].width;
    
    if ((width <= (MB_SWidth - 100)) && !haveSpace) {
        hud.mode = MBProgressHUDModeText;
        hud.minSize = CGSizeMake(140, 46.5);
        hud.labelText = message;
        hud.detailsLabelFont = [UIFont systemFontOfSize:MB_LabelFont];
        hud.detailsLabelColor = [UIColor whiteColor];
        hud.labelColor = [UIColor whiteColor];
        hud.labelFont = [UIFont systemFontOfSize:MB_LabelFont];
    } else {
        CGFloat height = [self getSizeWithString:message font:MB_LabelFont width:(MB_SWidth - 100)].height;
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MB_SWidth - 100, height)];
        UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, (MB_SWidth - 100), height)];
        [customView addSubview:customLabel];
        customLabel.text = message;
        customLabel.font = [UIFont systemFontOfSize:MB_LabelFont];
        customLabel.textColor = [UIColor whiteColor];
        customLabel.numberOfLines = 0;
        hud.customView = customView;
        hud.mode = MBProgressHUDModeCustomView;
    }
    return hud;
}

/** 成功 */
- (void)showSuccessHud:(NSString *)msg {
    [self showSuccessHud:msg afterDelay:MB_HudDelay];
}
- (void)showSuccessHud:(NSString *)msg afterDelay:(NSTimeInterval)delay {
    [self hideLoadingImage];
    [self hideMBProgressText];
    [WXMProgressHUDToast progressHUDToast:msg supView:self afterDelay:delay];
}
/** 根据高度度求 width */
- (CGSize)getSizeWithString:(NSString *)string font:(CGFloat)font width:(CGFloat) width {
    if (!font) font = [UIFont systemFontSize];
    NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:option
                                    attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:font] }
                                       context:nil];
    return rect.size;
}
@end
