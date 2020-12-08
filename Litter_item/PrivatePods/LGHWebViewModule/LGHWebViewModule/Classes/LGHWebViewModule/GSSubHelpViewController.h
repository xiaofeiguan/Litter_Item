//
//  GSSubHelpViewController.h
//  GameSirOTA
//
//  Created by gamesirDev on 23/10/2019.
//  Copyright © 2019 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 教程类型
typedef NS_ENUM(NSInteger, GSTutorialType) {
    /// 首页-上手教程
    GSTutorialTypeGetStarted = 1,
    /// 连接设备教程
    GSTutorialTypeConnectDevice = 2,
    /// 固件升级教程
    GSTutorialTypeSpeacial = 3,
    /// VX-开镜教程
    GSTutorialTypeVXMirror = 4,
    /// VX-摇杆死区教程
    GSTutorialTypeVXRockerDeadArea = 5,
    /// VX2，PC升级教程
    GSTutorialTypeVX2PCUpdate = 6,
    /// VX2，USB升级教程
    GSTutorialTypeVX2USBUpdate = 7,
    /// 模糊点击教程
    GSTutorialTypeFuzzyTouch = 8
};
//使用此类文件，必须在此项目的.podspec文件的末尾添加依赖，否则提示找不到该文件

NS_ASSUME_NONNULL_BEGIN

/// 非首页帮助页，包括：VX的开镜教程、摇杆死区教程
@interface GSSubHelpViewController : UIViewController

- (instancetype)initWithType:(GSTutorialType)type;

/// 隐藏分享按钮。帮助的首页不需要分享按钮
- (void)hideShareButton;

@end

NS_ASSUME_NONNULL_END
