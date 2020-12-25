//
//  LGHTimer03ViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHTimer03ViewController.h"
#import "LGHPushViewController.h"
#import "LGHProxy.h"
@interface LGHTimer03ViewController ()
@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, assign)  NSInteger num;

@property (nonatomic, strong) LGHProxy * proxy;
@end

@implementation LGHTimer03ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.proxy = [LGHProxy proxyWithTransformObject:self];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(fireHome) userInfo:nil repeats:YES];
    
    
    
    // 打破了 VC -/-> timer
    // 所以 释放vc时会执行dealloc
    // 在dealloc 里面执行[self.timer invalidate];
    // 可以打破runloop对timer的强持有。
    self.timer = [NSTimer timerWithTimeInterval:1 target:self.proxy selector:@selector(fireHome) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
}


-(void)fireHome{
    self.num++;
    NSLog(@"%ld",self.num);
}



-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"%@ %s",[self class],__func__);
}


@end
