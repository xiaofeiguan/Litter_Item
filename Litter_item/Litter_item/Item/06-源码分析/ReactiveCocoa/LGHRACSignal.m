//
//  LGHRACSignal.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/26.
//

#import "LGHRACSignal.h"

@implementation LGHRACSignal

+(instancetype)createSingal:(ReturnBlock)block{
    LGHRACSignal *signal = [[LGHRACSignal alloc]init];
    signal.returnBlock = [block copy];
    return signal;
}


-(void)subscribe{
    if (self.returnBlock) {
        self.returnBlock();
    }
}

@end
