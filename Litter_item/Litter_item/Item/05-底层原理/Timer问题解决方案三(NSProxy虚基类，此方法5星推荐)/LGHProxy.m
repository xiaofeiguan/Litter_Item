//
//  LGHProxy.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHProxy.h"


/*
 虚基类
 需要依赖子类实现
 
 */
@interface LGHProxy()
@property (nonatomic, weak) id object;
@end

@implementation LGHProxy
+ (instancetype)proxyWithTransformObject:(id)object{
    LGHProxy *proxy = [LGHProxy alloc];
    proxy.object = object;
    return proxy;
}


-(id)forwardingTargetForSelector:(SEL)aSelector{
    return  self.object;
}


@end
