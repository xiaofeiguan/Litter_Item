//
//  KCDaoEventUntil.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCDaoEventUntil : NSObject
+ (void)postNotification:(NSString*)tableName withEvent:(NSString*)rowEvent withData:(id)data;

@end

NS_ASSUME_NONNULL_END
