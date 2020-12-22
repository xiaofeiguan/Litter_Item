//
//  KCLiveStreamPresenter.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//


#import "DBConst.h"
#import "KCLiveStreamChannelMessage.h"
#import "KCLiveStreamGiftChannelMessage.h"
#import "KCLiveStreamPresenter+Gift.h"
#import "KCLiveStreamLikeChannelMessage.h"
#import "KCServiceEventUntil.h"

@interface KCLiveStreamPresenter ()
@property (nonatomic, strong) NSTimer*                              testTimer;
@property (nonatomic, strong) NSMutableDictionary*                  giftDic;

@end

@implementation KCLiveStreamPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self observeTable:Table_ChannelMessage event:Event_RowInsert selector:@selector(detectTableChannelMessageInsert:)];
        
        [self prepareGiftQueue];
        
        self.giftDic = @{}.mutableCopy;
    }
    return self;
}

#pragma mark- detect db table changes

- (void)detectTableChannelMessageInsert:(id)data
{
    KCLiveStreamChannelMessage* msg = data;
    if (msg == nil) {
        return;
    }
    // 播放礼物动画效果
    if (msg.msgtype.intValue == kChannelMsgType_Gift) {
        [self onReceiveGiftMsg:msg];
        return;
    }
    // 心心动画效果
    if (msg.msgtype.intValue == kChannelMsgType_Like) {
        KCLiveStreamLikeChannelMessage *likeMsg = (KCLiveStreamLikeChannelMessage *)msg;
        KC(self.context.view, KCLiveStreamPresenterDeleagte, fireHeartWithColorId:likeMsg.colorId);
        return;
    }
}

static int tapACount = 0;
static int tapBCount = 0;

- (void)startLikeAnimating
{
    //test receive gift
    tapACount = 0;
    tapBCount = 0;
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTestTimerTimeout) userInfo:nil repeats:true];
}

- (void)stopLikeAnimating
{
    [self.testTimer invalidate];
    self.testTimer = nil;
}



- (void)onTestTimerTimeout
{
    //    //test gift
    //    GiftChannelMessage* channelMsg = [GiftChannelMessage new];
    //    channelMsg.msgtype = @(kChannelMsgType_Gift);
    //    channelMsg.giftType = GiftChannelMessage_Star;
    //
    //    static int uid = 0;
    //    uid = uid%2;
    //    uid++;
    //
    //    channelMsg.fromuid = @(uid);
    //    channelMsg.fromnickname = [NSString stringWithFormat:@"User %d", uid];
    //    if (uid == 0) {
    //        channelMsg.tapCount = tapACount++;
    //    }
    //    else
    //    {
    //        channelMsg.tapCount = tapBCount++;
    //    }
    //    [EServiceEventUtil postNotification:Table_ChannelMessage withEvent:Event_RowInsert withData:channelMsg];
    
    
    //test heart
    KCLiveStreamLikeChannelMessage *likeMsg = [KCLiveStreamLikeChannelMessage new];
    likeMsg.fromuid = @(0);
    
    static int colorId = 0;
    colorId ++;
    colorId = colorId % 6;
    likeMsg.colorId = @(colorId);
    
    [KCServiceEventUntil postNotification:Table_ChannelMessage withEvent:Event_RowInsert withData:likeMsg];
}

- (void)sendGiftWithIndex:(int)index
{
    //
    KCLiveStreamGiftChannelMessage *channelMsg = [KCLiveStreamGiftChannelMessage new];
    channelMsg.msgtype = @(kChannelMsgType_Gift);
    channelMsg.giftType = index;
    channelMsg.fromuid = @(_OwnerID);
    channelMsg.fromnickname = [NSString stringWithFormat:@"cooci %d", _OwnerID];
    
    int tap = 0;
    if ([_giftDic objectForKey:@(index).stringValue] == nil) {
        [_giftDic setObject:@(0) forKey:@(index).stringValue];
    }
    tap = [[_giftDic objectForKey:@(index).stringValue] intValue];
    tap ++;
    [_giftDic setObject:@(tap) forKey:@(index).stringValue];
    
    channelMsg.tapCount = tap;
    
    //
    [KCServiceEventUntil postNotification:Table_ChannelMessage withEvent:Event_RowInsert withData:channelMsg];
}

@end
