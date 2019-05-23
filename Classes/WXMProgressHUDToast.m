//
//  WQGestureLockToast.m
//  Demo2
//
//  Created by edz on 2019/4/28.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "WXMProgressHUDToast.h"

@implementation NSString (YDOUProgressHUDToast)

- (CGSize)fd_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

@end

@implementation WXMProgressHUDToast

+ (void)progressHUDToast:(NSString *)msg supView:(UIView *)sView afterDelay:(NSTimeInterval)delay {
    if (!msg.length) return;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 17, 15, 17);
    CGFloat spacing = 7; // label / imgView of spacing
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq_succeed"]];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.frame = CGRectMake(0, insets.top, 34, 34);
    
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [msg fd_sizeForFont:font size:CGSizeMake(225, 200) mode:NSLineBreakByCharWrapping];
    size = CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale);
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame) + spacing, size.width, size.height);
    label.font = font;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    CGSize hudSize = CGSizeMake(size.width + insets.left + insets.right,
                                size.height + spacing + imgView.frame.size.height + insets.top + insets.bottom);
    UIView *hud = [UIView new];
    hud.frame = CGRectMake(0, 0, hudSize.width, hudSize.height);
    hud.backgroundColor = [UIColor colorWithRed:23 / 255. green:23 / 255. blue:23 / 255. alpha:1];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 6;
    
    imgView.center = CGPointMake(hud.frame.size.width / 2, imgView.center.y);
    [hud addSubview:imgView];
    label.center = CGPointMake(hud.frame.size.width / 2, label.center.y);
    [hud addSubview:label];
    hud.center = CGPointMake(sView.frame.size.width / 2, sView.frame.size.height / 2);
    [sView addSubview:hud];
    
    hud.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{ hud.alpha = 1; }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.4 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) { [hud removeFromSuperview]; }];
    });
}

@end
