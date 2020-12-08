//
//  DeviceTool.m
//  Help
//
//  Created by gamesirDev on 28/5/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import "DeviceTool.h"
#import "GSTool.h"
@implementation DeviceTool

+ (NSString *)shortNameWithType:(XJDeviceType)type {
    NSString * shortName = nil;
    
    switch (type) {
        case XJDeviceTypeG6:
            shortName = @"g6";
            break;
        case XJDeviceTypeVX:
            shortName = @"vx";
            break;
        case XJDeviceTypeG5:
            shortName = @"g5";
            break;
        case XJDeviceTypeX1:
            shortName = @"x1";
            break;
        case XJDeviceTypeZ1:
            shortName = @"z1";
            break;
        case XJDeviceTypeZ2:
            shortName = @"z2";
            break;
        case XJDeviceTypeT6:
            shortName = @"t6";
            break;
        case XJDeviceTypeDELUX:
            shortName = @"s2";
            break;
        case XJDeviceTypeGSB05:
            shortName = @"b05";
            break;
        case XJDeviceTypeI3:
            shortName = @"i3";
            break;
        case XJDeviceTypeF4:
            shortName = @"f4";
            break;
        case XJDeviceTypeG3:
            shortName = @"g3";
            break;
        case XJDeviceTypeG4:
            shortName = @"g4";
            break;
        case XJDeviceTypeVX2:
            shortName = @"vx2";
            break;
        case XJDeviceTypeZ3:
            shortName = @"z3";
            break;
        case XJDeviceTypeG4Pro:
            shortName = @"g4pro";
            break;
        case XJDeviceTypeT4Pro:
            shortName = @"t4pro";
            break;
        default:
            shortName = @"g6";
            break;
    }
    return shortName;
}


+ (NSString *)getRequestURLStringWithType:(XJDeviceType )type {
    NSString *shortName = [self shortNameWithType:type];
    NSString *URLString = [NSString stringWithFormat:@"https://helpgsw.vgabc.com/help.html?lang=%@&device=%@&platform=iosvtouch",[[GSTool shared] getLocalLanguage], shortName.uppercaseString];
    return URLString ;
}
@end
