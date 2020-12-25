//
//  LGHSingalObject.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/1.
//

#import "LGHSingalObject.h"

@implementation LGHSingalObject

static LGHSingalObject * sharedInstance = nil;
static dispatch_once_t onceToken;

+ (LGHSingalObject *)shareManager {
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)tearDown {
    sharedInstance = nil;
    onceToken = 0l;
}

@end
