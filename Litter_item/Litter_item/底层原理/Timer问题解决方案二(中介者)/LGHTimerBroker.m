//
//  LGHTimerBroker.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHTimerBroker.h"

@interface LGHTimerBroker()

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL lghSelector;

@property (nonatomic, strong) NSTimer *timer;



@end


@implementation LGHTimerBroker

-(instancetype)lgh_initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)aSelector userInfo:(nullable id)userInfo  repeats:(BOOL)isRepeats{
    if (self == [super init]) {
        
    }
    return  self;
}

@end
