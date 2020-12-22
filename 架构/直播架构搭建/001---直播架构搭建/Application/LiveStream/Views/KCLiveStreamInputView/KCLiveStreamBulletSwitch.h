//
//  KCLiveStreamBulletSwitch.h
//  001---直播架构搭建
//
//  Created by gao feng on 16/7/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCLiveStreamBulletSwitchDelegate <NSObject>

- (void)didClickBulletSwitch;
- (void)switchOnBullet;

@end


@interface KCLiveStreamBulletSwitch : UIButton

@property (nonatomic, weak) id<KCLiveStreamBulletSwitchDelegate>                 switchDelegate;

- (void)buildViews;

@end
