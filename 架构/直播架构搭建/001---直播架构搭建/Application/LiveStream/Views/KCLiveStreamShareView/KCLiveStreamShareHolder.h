//
//  KCLiveStreamShareHolder.h
//  001---直播架构搭建
//
//  Created by gao feng on 16/7/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCLiveStreamShareHolder : UIView

- (void)buildShare;

- (void)showWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;

@end
