//
//  UIControl+LGHCategory.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/26.
//

#import "UIControl+LGHCategory.h"
#import <objc/message.h>

@interface UIControl ()
/// 是否可以点击
@property (nonatomic, assign) BOOL isIgnoreClick;
/// 上次按钮响应的方法名
@property (nonatomic, strong) NSString *oldSELName;

@end


@implementation UIControl (LGHCategory)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orignalSel = @selector(sendAction:to:forEvent:);
        SEL newSel = @selector(lgh_sendAction:to:forEvent:);
        Method oldMethod = class_getInstanceMethod(self, orignalSel);
        Method newMethod = class_getInstanceMethod(self, newSel);
        const char *type  = method_copyReturnType(newMethod);
        BOOL isAddMethod = class_addMethod([self class], newSel, method_getImplementation(newMethod), type);
        // 如果已经添加，返回NO
        if (isAddMethod) {
            class_replaceMethod([self class], newSel, method_getImplementation(oldMethod), type);
        }else{
            //交换
            method_exchangeImplementations(newMethod, oldMethod);
        }
    });
    
}

static double kDefaultInterval = 1.0;

-(void)lgh_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if ([self isKindOfClass:[UIButton class]]&& !self.isIgnoreClickInterval) {
        if (self.clickInterval<=0) {
            self.clickInterval = kDefaultInterval;
        }
        NSString *currentSELName = NSStringFromSelector(action);
        if (self.isIgnoreClick && [self.oldSELName isEqualToString:currentSELName]) {
            NSLog(@"不能连续点击");
            return;
        }
        if (self.clickInterval>0) {
            self.isIgnoreClick = YES;
            self.oldSELName = currentSELName;
            [self performSelector:@selector(lgh_changeStatus:) withObject:@(NO) afterDelay:self.clickInterval];
        }
    }
    
    [self lgh_sendAction:action to:target forEvent:event];
}

-(void)lgh_changeStatus:(NSNumber *)status{
    self.isIgnoreClick = status.boolValue;
    self.oldSELName = @"";
}



#pragma mark  - 关联对象
- (NSTimeInterval)clickInterval {
    
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setClickInterval:(NSTimeInterval)clickInterval {
    objc_setAssociatedObject(self, @selector(clickInterval), @(clickInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreClick {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsIgnoreClick:(BOOL)isIgnoreClick {
    objc_setAssociatedObject(self, @selector(isIgnoreClick), @(isIgnoreClick), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(BOOL)isIgnoreClickInterval{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


-(void)setIsIgnoreClickInterval:(BOOL)isIgnoreClickInterval{
    objc_setAssociatedObject(self, @selector(isIgnoreClickInterval), @(isIgnoreClickInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)oldSELName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOldSELName:(NSString *)oldSELName {
    objc_setAssociatedObject(self, @selector(oldSELName), oldSELName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
