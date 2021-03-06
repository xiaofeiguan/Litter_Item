//
//  KCLiveStreamGiftView.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftChannelMessage;
@class KCLiveStreamGiftBanner;

@interface KCLiveStreamGiftView : UIView

- (void)initCustomView;

- (void)showGeneralGiftAnimation:(GiftChannelMessage*)giftMsg;
- (KCLiveStreamGiftBanner *)getTopBanner;
- (KCLiveStreamGiftBanner *)getBottomBanner;

- (BOOL)hasFreeSpace;


@end
