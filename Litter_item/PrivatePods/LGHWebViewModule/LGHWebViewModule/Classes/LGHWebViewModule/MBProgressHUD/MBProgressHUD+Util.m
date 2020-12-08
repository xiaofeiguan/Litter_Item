//
//  MBProgressHUD+Util.m
//  Dylib
//
//  Created by Xiaoji on 2017/2/28.
//  Copyright © 2017年 xugelei. All rights reserved.
//

#import "MBProgressHUD+Util.h"

@implementation MBProgressHUD (Util)

//static UIColor* kBackgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];

+ (void)showMsgIn:(UIView *)view text:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)showMsgWithtext:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)showMsgWithtext:(NSString *)text afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (void)showMsgIn:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.label.numberOfLines = 0;
        // 提示文字的颜色
        hud.label.textColor = [UIColor whiteColor];
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (void)showWaitingViewAfterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (void)showMsgIn:(UIView *)view atbText:(NSMutableAttributedString *)atbText {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.attributedText = atbText;
        hud.label.numberOfLines = 0;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)showMsgIn:(UIView *)view atbText:(NSMutableAttributedString *)atbText afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.attributedText = atbText;
        hud.label.numberOfLines = 0;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

/**
 显示菊花加载状态
 
 @param message 消息正文
 @param view 展示的view
 */
+ (instancetype)showActivityLoading:(nullable NSString *)message toView:(nullable UIView *)view
{
    if (view == nil) view = [[[UIApplication sharedApplication] delegate] window];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 默认
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = NO;

    if (message) {
        hud.label.text = message;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (instancetype)showActivityLoading:(nullable NSString *)message{
    return [self showActivityLoading:message toView:[UIApplication sharedApplication].keyWindow];
}

/**
 显示菊花加载状态
 
 @param message 消息正文
 @param afterDelay afterDelay
 */
+ (void)showActivityLoading:(nullable NSString *)message afterDelay:(NSTimeInterval)afterDelay{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        // 默认
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

@end
