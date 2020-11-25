//
//  LGHTimer01ViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHTimer01ViewController.h"
#import "LGHPushViewController.h"
@interface LGHTimer01ViewController ()

@property (nonatomic, strong) NSTimer * timer;


@property (nonatomic, assign)  NSInteger num;

@end




@implementation LGHTimer01ViewController


/*
 * self.timer加入到[NSRunLoop currentRunLoop]，造成了runloop对timer的强持有，runloop不释放，导致timer不释放，
 
     只有[self.timer invalidate]才能打破runloop对timer的强持有
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 0;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(fireHomeTime:) userInfo:@(1) repeats:YES];
    // 加入到[NSRunLoop currentRunloop]
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[[LGHPushViewController alloc]init] animated:YES];
}

-(void)fireHomeTime:(NSTimer *)timer{
    self.num++;
    NSLog(@"num=%ld userInfo=%@",self.num,timer.userInfo);
}


- (void)didMoveToParentViewController:(UIViewController *)parent{
    // 无论push 进来 还是 pop 出去 正常跑
    // 就算继续push 到下一层 pop 回去还是继续
    if (parent == nil) {
       [self.timer invalidate];
        self.timer = nil;
        NSLog(@"timer 走了");
    }
}



-(void)dealloc{
    NSLog(@"%@:%s",[self class],__func__);
}



@end
