//
//  KCBasePresenter.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDDContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCBasePresenter : CDDPresenter

- (void)observeTable:(NSString*)table event:(NSString*)event selector:(SEL)sel;
- (void)unobserveTable:(NSString*)table event:(NSString*)event;

- (void)postLoading;
- (void)hideLoading;

- (void)postImageToast:(NSString *)toast;
- (void)postToast:(NSString *)toast;

@end

NS_ASSUME_NONNULL_END
