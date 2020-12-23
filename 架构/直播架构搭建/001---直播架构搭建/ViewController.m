//
//  ViewController.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "ViewController.h"
#import "KCHomeViewController.h"
@interface ViewController ()
//@property (nonatomic, strong) KCHomeViewController * homeVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)gotoLiveLists:(UIButton *)sender {
    KCHomeViewController *homeVC = [[KCHomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
    
}

@end
