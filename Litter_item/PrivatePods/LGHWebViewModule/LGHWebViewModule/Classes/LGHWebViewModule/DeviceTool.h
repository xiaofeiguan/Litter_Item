//
//  DeviceTool.h
//  Help
//
//  Created by gamesirDev on 28/5/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XJDeviceType) {
    XJDeviceTypeG6 = 0, // 改为1，出问题
    XJDeviceTypeVX,
    XJDeviceTypeG5,
    XJDeviceTypeX1,
    XJDeviceTypeZ1,
    XJDeviceTypeZ2,
    XJDeviceTypeT6,
    XJDeviceTypeDELUX,
    XJDeviceTypeGSB05,
    XJDeviceTypeI3,
    XJDeviceTypeF4,
    XJDeviceTypeG3,
    XJDeviceTypeG4,
    XJDeviceTypeVX2,
    XJDeviceTypeZ3,
    XJDeviceTypeG4Pro,
    XJDeviceTypeT4Pro,
    XJDeviceTypeUnknown
};

NS_ASSUME_NONNULL_BEGIN

@interface DeviceTool : NSObject

+ (NSString*)shortNameWithType:(XJDeviceType)type;
+ (NSString *)getRequestURLStringWithType:(XJDeviceType )type;
@end

NS_ASSUME_NONNULL_END
