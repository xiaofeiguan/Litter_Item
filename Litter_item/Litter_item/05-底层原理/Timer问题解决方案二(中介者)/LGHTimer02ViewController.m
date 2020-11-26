//
//  LGHTimer02ViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHTimer02ViewController.h"
#import "LGHPushViewController.h"
#import "LGHTimerBroker.h"
@interface LGHTimer02ViewController ()
@property (nonatomic, strong) LGHTimerBroker * timerBroker;

@property (nonatomic, assign)  NSInteger num;
@end

@implementation LGHTimer02ViewController

/*
 * self.timer加入到[NSRunLoop currentRunLoop]，造成了runloop对timer的强持有，runloop不释放，导致timer不释放，
 
 只有[self.timer ]
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // vc --> timerBroker  中介者
    // 可以让vc释放
    // 等到vc释放， 可以在timerBroker里面执行 [self.timer invalidate], 释放timer
    /*
    // 在LGHTimerBroker里面
     if (broker.target) {
        // ....
     }else{
     // 当vc释放，执行[broker.timer invalidate]
     [broker.timer invalidate];
     broker.timer = nil;
     }
     
     */
    
    self.timerBroker = [[LGHTimerBroker alloc]lgh_initWithTimeInterval:1 target:self selector:@selector(fireHomeTime) userInfo:nil repeats:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[[LGHPushViewController alloc]init] animated:YES];
}


-(void)fireHomeTime{
    self.num++;
    NSLog(@"num = %ld",self.num);
}


-(void)dealloc{
    NSLog(@"%@:%s",[self class],__func__);
}

@end
