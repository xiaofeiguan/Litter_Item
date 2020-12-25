//
//  LGHLeaksTestViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/1.
//

#import "LGHLeaksTestViewController.h"
#import "LGHLeaksView01.h"
#import "LGHLeaksView02.h"
#import "LGHSingalObject.h"
@interface LGHLeaksTestViewController ()
@property (nonatomic, strong) LGHLeaksView01 * view01;

@property (nonatomic, strong) LGHLeaksView01 * view02;
@end

@implementation LGHLeaksTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view01 = [[LGHLeaksView01 alloc]initWithFrame:CGRectMake(0, 0, LGHScreenWidth, LGHScreenHeight/2.0)];
    self.view01.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.view01];
    
    self.view02 = [[LGHLeaksView01 alloc]initWithFrame:CGRectMake(0, LGHScreenHeight/2.0, LGHScreenWidth, LGHScreenHeight/2.0)];
    self.view02.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.view02];
    
    [LGHSingalObject shareManager].view01 = _view01;
    [LGHSingalObject shareManager].view02 = _view02;
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    // 无论push 进来 还是 pop 出去 正常跑
    // 就算继续push 到下一层 pop 回去还是继续
    if (parent == nil) {
        [LGHSingalObject tearDown];
        NSLog(@"LGHSingalObject 走了");
    }
}

@end
