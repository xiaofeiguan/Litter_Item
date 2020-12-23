//
//  LGHBaseViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHBaseViewController.h"

@interface LGHBaseViewController ()

@end

@implementation LGHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)dealloc{
    NSLog(@"dealloc:%@",[self class]);
}

@end
