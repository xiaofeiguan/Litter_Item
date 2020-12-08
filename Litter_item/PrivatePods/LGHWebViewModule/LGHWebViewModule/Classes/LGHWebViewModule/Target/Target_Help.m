//
//  Target_Help.m
//  Help
//
//  Created by gamesirDev on 9/4/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import "Target_Help.h"
#import "GSSubHelpViewController.h"
#import "GSSubHelpDetailViewController.h"
#import "GSHelpDetailViewController.h"
#import "GSHelpViewController.h"
#import "GSTool.h"
#import "DeviceTool.h"
#import <ModuleConst/Const.h>

@implementation Target_Help

static GSSubHelpViewController* kSubHelpViewController;
static GSHelpViewController* kHelpViewController;

//- (void)dealloc {
//    kSubHelpViewController = nil;
//    kHelpViewController = nil;
//}

- (UIViewController *)ModuleHelp_nativeAHelpViewController:(NSDictionary *)param {
    GSHelpViewController* helpVC = [[GSHelpViewController alloc] init];
    kHelpViewController = helpVC;
    return helpVC;
}

- (UIViewController *)ModuleHelp_nativeAHelpDetailViewController:(NSDictionary *)param {
    GSHelpDetailViewController* helpDetailVC = [[GSHelpDetailViewController alloc] initWithUrl:param[kModuleHelpParamKey_url]];
    return helpDetailVC;
}

- (UIViewController *)ModuleHelp_nativeASubHelpViewController:(NSDictionary *)param {
    GSSubHelpViewController* subHelpVC = [[GSSubHelpViewController alloc] initWithType:[param[kModuleHelpParamKey_type] integerValue]];
    kSubHelpViewController = subHelpVC;
    return subHelpVC;
}

- (UIViewController*)ModuleHelp_nativeASubHelpDetailViewController:(NSDictionary*)param {
    GSSubHelpDetailViewController* subHelpDetailVC = [[GSSubHelpDetailViewController alloc] initWithURLString:param[kModuleHelpParamKey_url]];
    return subHelpDetailVC;
}

- (void)ModuleHelp_nativeHideShareButtonOnSubHelpViewController:(NSDictionary *)param {
    if (kSubHelpViewController) {
        [kSubHelpViewController hideShareButton];
    }
}

- (NSString *)ModuleHelp_nativeGetRequestURLString:(NSDictionary *)param {
    NSString *shortName = [DeviceTool shortNameWithType:[param[kModuleHelpParamKey_type] integerValue]];
    NSString *URLString = [NSString stringWithFormat:@"https://helpgsw.vgabc.com/help.html?lang=%@&device=%@&platform=iosvtouch",[[GSTool shared] getLocalLanguage], shortName.uppercaseString];
    return URLString ;
}

- (void)ModuleHelp_nativeReloadWebViewInHelpViewController:(NSDictionary *)param {
    if (kHelpViewController) {
        [kHelpViewController reloadWebViewWithDeviceType:[param[kModuleHelpParamKey_type] integerValue]];
    }
}

- (void)ModuleHelp_nativePushToHelpDetailViewController:(NSDictionary *)param {
    GSHelpDetailViewController* helpDetailVC = [[GSHelpDetailViewController alloc] initWithUrl:param[kModuleHelpParamKey_url]];
    [GSGetCurrentViewController().navigationController pushViewController:helpDetailVC animated:YES];
}

/**
 *  获取当前的控制器
 */
static inline UIViewController * GSGetCurrentViewController() {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (viewController) {
        if (viewController.presentedViewController) {
            // Return presented view controller
            viewController = viewController.presentedViewController;
        } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
            // Return right hand side view controller
            UISplitViewController*splitViewController = (UISplitViewController *)viewController;
            if (splitViewController.viewControllers.count > 0) {
                viewController = splitViewController.viewControllers.lastObject;
            } else {
                return viewController;
            }
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            // Return top view controller
            UINavigationController *navViewController = (UINavigationController *)viewController;
            if (navViewController.viewControllers.count > 0) {
                viewController = navViewController.topViewController;
            } else {
                return viewController;
            }
        } else if ([viewController isKindOfClass:[UITabBarController class]]) {
            // Return visible view controller
            UITabBarController *tabViewController = (UITabBarController *)viewController;
            if (tabViewController.viewControllers.count > 0) {
                viewController = tabViewController.selectedViewController;
            } else {
                return viewController;
            }
        } else {
            // Unknown view controller type, return last child view controller
            return viewController;
        }
    }
    return viewController;
}

@end
