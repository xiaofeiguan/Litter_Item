//
//  LGHTimerBroker.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHTimerBroker.h"
#import <objc/message.h>
@interface LGHTimerBroker()

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL lghSelector;

@property (nonatomic, strong) NSTimer *timer;



@end


@implementation LGHTimerBroker

-(instancetype)lgh_initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)aSelector userInfo:(nullable id)userInfo  repeats:(BOOL)isRepeats{
    if (self == [super init]) {
        self.target = target;
        self.lghSelector = aSelector;
        if ([self.target respondsToSelector:self.lghSelector]) {
            Method method    = class_getInstanceMethod([self.target class], aSelector);
            const char *type = method_getTypeEncoding(method);
            // 给类添加动态的方法
//            class_addMethod([self class], aSelector, class_getMethodImplementation([self class], @selector(fireHomeBroker:)), type);
            
            class_addMethod([self class], aSelector, (IMP)fireHomeBroker, type);
            
            self.timer  = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:aSelector userInfo:userInfo repeats:isRepeats];
        }
    }
    return  self;
}

void fireHomeBroker(LGHTimerBroker * broker){
    if (broker.target) { // 当vc未释放时，消息发送
        void (*lg_msgSend)(void *,SEL, id) = (void *)objc_msgSend;
        lg_msgSend((__bridge void *)(broker.target), broker.lghSelector,broker.timer);
    }else{
        // 当vc释放，执行[broker.timer invalidate]
        [broker.timer invalidate];
        broker.timer = nil;
    }
}

- (void)lgh_invalidate{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
