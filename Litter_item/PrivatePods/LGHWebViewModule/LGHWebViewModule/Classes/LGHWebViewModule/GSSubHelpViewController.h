//
//  GSSubHelpViewController.h
//  GameSirOTA
//
//  Created by gamesirDev on 23/10/2019.
//  Copyright © 2019 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
// 使用此类文件，必须在此项目的.podspec文件的末尾添加依赖，否则提示找不到该文件
#import <Help_Category/CTMediator+Help.h>

NS_ASSUME_NONNULL_BEGIN

/// 非首页帮助页，包括：VX的开镜教程、摇杆死区教程
@interface GSSubHelpViewController : UIViewController

- (instancetype)initWithType:(GSTutorialType)type;

/// 隐藏分享按钮。帮助的首页不需要分享按钮
- (void)hideShareButton;

@end

NS_ASSUME_NONNULL_END
