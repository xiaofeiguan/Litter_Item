//
//  GSHelpViewController.h
//  CTMediator
//
//  Created by gamesirDev on 14/4/2020.
//

#import <UIKit/UIKit.h>
#import "DeviceTool.h"

NS_ASSUME_NONNULL_BEGIN
/// 首页的帮助页面
@interface GSHelpViewController : UIViewController

- (void)reloadWebViewWithDeviceType:(XJDeviceType)type;

@end

NS_ASSUME_NONNULL_END
