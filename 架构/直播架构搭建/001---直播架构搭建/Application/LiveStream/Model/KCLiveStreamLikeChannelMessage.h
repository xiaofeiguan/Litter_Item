//
//  KCLiveStreamLikeChannelMessage.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamChannelMessage.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KCLiveStreamLikeChannelMessageColorBlue = 0,
    KCLiveStreamLikeChannelMessageColorPink = 1,
    KCLiveStreamLikeChannelMessageColorGreen = 2,
    KCLiveStreamLikeChannelMessageColorOrange = 3,
    KCLiveStreamLikeChannelMessageColorPurple = 4,
    KCLiveStreamLikeChannelMessageColorYellow = 5,
    KCLiveStreamLikeChannelMessageColorCount = 6,
} KCLiveStreamLikeChannelMessageColorType;

@interface KCLiveStreamLikeChannelMessage : KCLiveStreamChannelMessage

@property (nonatomic, strong) NSNumber *colorId;
@property (nonatomic, assign) BOOL shouldShowInChats;

+ (KCLiveStreamLikeChannelMessageColorType)getRandomHeartColor;
+ (UIImage*)getHeartImageByType:(KCLiveStreamLikeChannelMessageColorType)type;


@end

NS_ASSUME_NONNULL_END
