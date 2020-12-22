//
//  KCLiveStreamPresenter.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN
@class MSWeakTimer;
@class KCLiveStreamAdapter;
@class KCLiveStreamGiftBanner;
@class KCLiveStreamGiftChannelMessage;

@protocol KCLiveStreamPresenterDeleagte <NSObject>

@optional
// 构建视图
- (void)buildLiveStreamViewWithAdapter:(KCLiveStreamAdapter *)adpter;


- (KCLiveStreamGiftBanner *)getTopBanner;
- (KCLiveStreamGiftBanner *)getBottomBanner;
- (BOOL)hasFreeSpaceToPlayNormalGift;
- (void)playGiftAnimation:(KCLiveStreamGiftChannelMessage *)giftMsg;
- (void)fireHeartWithColorId:(NSNumber *)colorId;


- (void)showGiftSelectionView:(BOOL)show;
- (void)showShareView:(BOOL)show;
- (void)showInputView:(BOOL)show;

- (void)startLikeAnimating;
- (void)stopLikeAnimating;
// 发送礼物
- (void)sendGiftWithIndex:(int)index;

// 返回首页
- (void)gotoHomeController;

// 键盘出现 or 消失
- (void)adjustTalkViewOnKeyboardHide:(NSNotification *)notification;
- (void)adjustTalkViewOnKeyboardShow:(NSNotification *)notification;

@end

@interface KCLiveStreamPresenter : KCBasePresenter
//for gift category
@property (nonatomic, strong) MSWeakTimer               *giftReceiveTimer;
@property (nonatomic, strong) NSMutableArray            *giftQueue;
@end

NS_ASSUME_NONNULL_END
