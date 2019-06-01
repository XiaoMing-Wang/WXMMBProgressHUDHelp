//
//  UIViewController+MBProgressHUD.m
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//
#define MB_HidenAll @"MB_HIDENALL"
#define MB_SWidth [UIScreen mainScreen].bounds.size.width
#define MB_Indeterminate 10000
#define MB_HudModeTex 10001
#define MB_HudDelay 3.5f
#define MB_LabelFont 15.5

#import <objc/runtime.h>
#import "UIViewController+MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "WXMProgressHUDToast.h"

@implementation UIViewController (MBProgressHUD)

/** 显示弹窗 */
- (void)showLoadingImage {
    [self hideMBProgressText];
    if (self.navigationController) [self.navigationController hideMBProgressText];
    MBProgressHUD * interactionHUD = [self creatIndeterminateHudWithView:self.view];
    interactionHUD.userInteractionEnabled = NO;
    interactionHUD.tag = MB_Indeterminate;
}

- (void)showLoadingImage_noInf {
    [self hideMBProgressText];
    if (self.navigationController) [self.navigationController hideMBProgressText];
    MBProgressHUD * interactionHUD = [self creatIndeterminateHudWithView:self.view];
    interactionHUD.userInteractionEnabled = YES;
    interactionHUD.tag = MB_Indeterminate;
}

- (void)showLoadingImageFull {
    [self hideMBProgressText];
    if (self.navigationController) [self.navigationController hideMBProgressText];
    MBProgressHUD * interactionHUD = [self creatIndeterminateHudWithView:self.view];
    interactionHUD.backgroundColor = [UIColor whiteColor];
    interactionHUD.userInteractionEnabled = YES;
    interactionHUD.tag = MB_Indeterminate;
}

/** 隐藏 */
- (void)hideLoadingImage {
    NSArray * hudArray = [MBProgressHUD allHUDsForView:self.view];
    [hudArray enumerateObjectsUsingBlock:^(MBProgressHUD *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == MB_Indeterminate) [obj hide:NO];
    }];
}

/** 显示在导航控制器上  */
- (void)showMBProgressMessage:(NSString *)message {
    if (self.hideErrorProgressHUD) return;
    [self hideLoadingImage];
    if (self.navigationController) [self.navigationController hideLoadingImage];
    UIView * supView = self.navigationController ? self.navigationController.view : self.view;
    MBProgressHUD * hud = [self creatModeTextHudWithView:supView message:message];
    hud.tag = MB_HudModeTex;
    [self addNotificationCenter];
}

/** 显示在当前控制器  */
- (void)showMBProgressMessageSelfVC:(NSString *)message {
    if (self.hideErrorProgressHUD) return;
    [self hideLoadingImage];
    MBProgressHUD * hud = [self creatModeTextHudWithView:self.view message:message];
    [hud hide:NO afterDelay:MB_HudDelay];
    hud.tag = MB_HudModeTex;
    [self addNotificationCenter];
}

/** 隐藏文字  */
- (void)hideMBProgressText {
    NSArray * hudArray = [MBProgressHUD allHUDsForView:self.view];
    NSArray * hudArrayNavigation = [MBProgressHUD allHUDsForView:self.navigationController.view];
    [hudArray enumerateObjectsUsingBlock:^(MBProgressHUD *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == MB_HudModeTex) [obj hide:NO];
    }];
    [hudArrayNavigation enumerateObjectsUsingBlock:^(MBProgressHUD *obj, NSUInteger idx, BOOL*stop) {
        if (obj.tag == MB_HudModeTex) [obj hide:NO];
    }];
}

/** 添加通知 */
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MB_HidenAll object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMBProgressText)
                                                 name:MB_HidenAll object:nil];
}

/** 隐藏所有  */
- (void)hideMBProgressAllText {
    [[NSNotificationCenter defaultCenter] postNotificationName:MB_HidenAll object:nil];
}

/** 显示成功 */
- (void)showSuccessHud:(NSString *)msg {
    [self showSuccessHud:msg afterDelay:MB_HudDelay];
}
- (void)showSuccessHud:(NSString *)msg afterDelay:(NSTimeInterval)delay {
    UIView * supView = self.view;
    [self hideLoadingImage];
    [self hideMBProgressText];
    if (self.navigationController) {
        supView = self.navigationController.view;
        [self.navigationController hideLoadingImage];
        [self.navigationController hideMBProgressText];
    }
    [WXMProgressHUDToast progressHUDToast:msg supView:supView afterDelay:delay];
}

/** 显示hud并且关闭手势  */
static const int forbid;
- (void)showLoadingForbid {
    [self showLoadingImage_noInf];
    if (self.navigationController){
        BOOL inte = self.navigationController.interactivePopGestureRecognizer.enabled;
        objc_setAssociatedObject(self, &forbid, @(inte), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)hideLoadingForbid {
    [self hideLoadingImage];
    if (self.navigationController){
        BOOL inte = [objc_getAssociatedObject(self, &forbid) boolValue];
        self.navigationController.interactivePopGestureRecognizer.enabled = inte;
    }
}

/** 转圈 */
- (MBProgressHUD *)creatIndeterminateHudWithView:(UIView *)superView {
    NSArray *hudArray = [MBProgressHUD allHUDsForView:superView];
    MBProgressHUD *hud = nil;
    if (hudArray.count > 0) hud = hudArray.lastObject;
    else hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];;
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
        CGFloat ws = (MB_SWidth - 100);
        CGFloat height = [self getSizeWithString:message font:MB_LabelFont width:ws].height;
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ws, height)];
        UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, ws, height)];
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

/** 是否隐藏显示ProgressHUD */
- (void)setHideErrorProgressHUD:(BOOL)hideErrorProgressHUD {
    BOOL show = hideErrorProgressHUD;
    SEL sel = @selector(hideErrorProgressHUD);
    if (hideErrorProgressHUD) [self hideMBProgressAllText];
    objc_setAssociatedObject(self, sel, @(show), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue , ^{
        objc_setAssociatedObject(self, sel, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

- (BOOL)hideErrorProgressHUD {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

+ (void)load {
    Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod(self, @selector(mb_dealloc));
    method_exchangeImplementations(method1, method2);
}

- (void)mb_dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MB_HidenAll object:nil];
    } @catch (NSException *exception) {} @finally {}
    [self mb_dealloc];
}
@end
