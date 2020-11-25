//
//  LGHTimer02ViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHTimer02ViewController.h"
#import "LGHPushViewController.h"
@interface LGHTimer02ViewController ()
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation LGHTimer02ViewController

/*
 * self.timer加入到[NSRunLoop currentRunLoop]，造成了runloop对timer的强持有，runloop不释放，导致timer不释放，
 
 只有[self.timer ]
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(fireHomeTime) userInfo:nil repeats:YES];
    // 加入到[NSRunLoop currentRunloop]
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[[LGHPushViewController alloc]init] animated:YES];
}

static int num = 0;
-(void)fireHomeTime{
    num++;
    NSLog(@"num = %d",num);
}


-(void)dealloc{
    NSLog(@"%@:%s",[self class],__func__);
}

@end
