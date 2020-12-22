//
//  KCBaseNavigationController.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCBaseNavigationController.h"

@interface KCBaseNavigationController ()

@end

@implementation KCBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* ctrl = [super popViewControllerAnimated:animated];
    
    return ctrl;
}




@end
