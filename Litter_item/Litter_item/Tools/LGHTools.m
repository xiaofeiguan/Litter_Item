//
//  LGHTools.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/15.
//

#import "LGHTools.h"

@implementation LGHTools

+(BOOL)isPhoneXSeries{
    BOOL isPhoneX = NO;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (@available(iOS 11.0, *)) {
            isPhoneX = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom > 0.0;
        }
    }
    return isPhoneX;
}


@end
