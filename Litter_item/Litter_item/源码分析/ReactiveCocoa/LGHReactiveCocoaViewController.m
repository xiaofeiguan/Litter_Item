//
//  LGHReactiveCocoaViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/26.
//

#import "LGHReactiveCocoaViewController.h"
#import <RACSignal.h>
#import <RACSubscriber.h>
#import <RACDisposable.h>
@interface LGHReactiveCocoaViewController ()
@property(nonatomic,strong) RACSignal *signal;
@end

@implementation LGHReactiveCocoaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testRAC];
}

-(void)testRAC{
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"🍺🍺🍺🍺🍺🍺🍺"];
        [subscriber sendCompleted];
        return  [RACDisposable disposableWithBlock:^{
            NSLog(@"销毁了");
        }];
    } ];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
    }];
}

@end
