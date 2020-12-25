//
//  LGHPodModuleViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/9.
//

#import "LGHPodModuleViewController.h"
#import "LGHWebViewModule.h"
@interface LGHPodModuleViewController ()

@end

@implementation LGHPodModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    GSSubHelpViewController  *helpVC = [[GSSubHelpViewController alloc]initWithType:GSTutorialTypeGetStarted];
    [self.navigationController pushViewController:helpVC animated:YES];
}

@end
