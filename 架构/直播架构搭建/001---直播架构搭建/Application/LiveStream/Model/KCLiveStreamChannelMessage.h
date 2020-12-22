//
//  KCLiveStreamChannelMessage.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define  kChannelMsgType_Text       1 //普通文本
#define  kChannelMsgType_Like       2 //点赞
#define  kChannelMsgType_DANMAKU    3 //弹幕
#define  kChannelMsgType_Gift       4 //礼物

@class TYTextContainer;

@interface KCLiveStreamChannelMessage : NSObject

@property (nonatomic, retain) NSString *channelId;
@property (nonatomic, retain) NSNumber *fromuid;
@property (nonatomic, retain) NSString *fromnickname;
@property (nonatomic, retain) NSString *tonickname;
@property (nonatomic, retain) NSString *fromavatar;
@property (nonatomic, retain) NSString *msgUUID;
@property (nonatomic, retain) NSNumber *msgId;
@property (nonatomic, retain) NSNumber *rowid;
@property (nonatomic, retain) NSNumber *touid;
@property (nonatomic, retain) NSNumber *msgtype;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSNumber* msgsrvtime;

- (UIFont*)getNameFont;
- (UIFont*)getContentFont;
- (TYTextContainer*)createRichTextContainer;
- (TYTextContainer*)getRichTextContainer;
@end

NS_ASSUME_NONNULL_END
