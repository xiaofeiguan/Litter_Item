//
//  KCLiveStreamPresenter+Gift.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/24.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamPresenter.h"
#import "KCLiveStreamChannelMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCLiveStreamPresenter (Gift)
- (void)prepareGiftQueue;
- (void)destroyGiftQueue;

- (void)onReceiveGiftMsg:(KCLiveStreamChannelMessage*)gift;

@end

NS_ASSUME_NONNULL_END
