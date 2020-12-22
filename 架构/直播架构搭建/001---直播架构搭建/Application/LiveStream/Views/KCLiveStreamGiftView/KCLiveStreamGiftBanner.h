//
//  KCLiveStreamGiftBanner.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCLiveStreamGiftChannelMessage.h"

typedef void (^GiftBannerAnimationBlock)(int line);

@interface KCLiveStreamGiftBanner : UIView

@property (nonatomic, strong) KCLiveStreamGiftChannelMessage *currentGiftMsg;
@property (nonatomic, strong) KCLiveStreamGiftChannelMessage *nextGiftMsg;

- (void)initWithGiftMsg:(KCLiveStreamGiftChannelMessage*)msg showLine:(int)line;

- (void)showWithAnimationFinishBlock:(GiftBannerAnimationBlock)block;
- (void)playNumberAnimationWithCount:(int)count;
- (void)hide;

- (void)btnAvatarClicked;

- (BOOL)isHiding;

+ (CGFloat)bannerHeight;
+ (CGFloat)bannerWidth;

@end
