//
//  GSTool.m
//  Help
//
//  Created by gamesirDev on 14/4/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import "GSTool.h"

@implementation GSTool

+ (instancetype)shared {
    static GSTool* tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[GSTool alloc] init];
    });
    return tool;
}

- (NSString*)getLocalLanguage {
    if ([NSLocale preferredLanguages].count > 0) {
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *appLang = @"en";
        if ([language rangeOfString:@"zh"].location != NSNotFound) {
            appLang = @"zh";
        }
        if ([language rangeOfString:@"ja"].location != NSNotFound) {
            appLang = @"ja";
        }
        return appLang;
    }else {
        NSString * language = [[NSLocale currentLocale] localeIdentifier];;
        NSString *appLang = @"en";
        if ([language rangeOfString:@"zh"].location != NSNotFound) {
            appLang = @"zh";
        }
        if ([language rangeOfString:@"ja"].location != NSNotFound) {
            appLang = @"ja";
        }
        return appLang;
    }
}

@end
