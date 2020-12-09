//
//  LGHTabbar02ViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import "LGHTabbar02ViewController.h"
#import "LGHTabBarOne.h"
@interface LGHTabbar02ViewController ()<UITabBarControllerDelegate,LGHTabBarOneDelegate>

@end

@implementation LGHTabbar02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self createControllers];
    // 设置tabBar
    LGHTabBarOne* tabBar = [LGHTabBarOne new];
    tabBar.delegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)createControllers {
    NSArray *classnameArray = @[@"LGHOneViewController", @"LGHTwoViewController", @"LGHThreeViewController"];
    for (NSInteger i = 0; i < classnameArray.count; i++) {
        Class class = NSClassFromString(classnameArray[i]);
        UIViewController *vc = nil;
        vc = [[class alloc]init];
        
        UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:vc];
        // 添加
        [self addChildViewController:navigationVc];
    }
}

#pragma mark - delegate

- (void)tabBar:(LGHTabBarOne*)tabBar didSelectIndex:(NSInteger)selectedIndex{
    
}



@end
