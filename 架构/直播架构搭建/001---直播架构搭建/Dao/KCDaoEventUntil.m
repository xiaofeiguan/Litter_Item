//
//  KCDaoEventUntil.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCDaoEventUntil.h"

@implementation KCDaoEventUntil

+ (void)postNotification:(NSString*)tableName withEvent:(NSString*)rowEvent withData:(id)data
{
    // status -> 数据 ->
    NSMutableDictionary *info = [NSMutableDictionary new];
    info[@"data"] = data;
    info[@"table"] = tableName;
    info[@"event"] = rowEvent;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:tableName object:nil userInfo:info];
    });
}

@end
