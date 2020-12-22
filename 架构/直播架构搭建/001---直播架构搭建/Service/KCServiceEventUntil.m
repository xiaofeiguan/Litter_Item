//
//  KCServiceEventUntil.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCServiceEventUntil.h"
#import "KCDaoEventUntil.h"

@implementation KCServiceEventUntil
+ (void)postNotification:(NSString*)tableName withEvent:(NSString*)rowEvent withData:(id)data
{
    [KCDaoEventUntil postNotification:tableName withEvent:rowEvent withData:data];
}

@end
