//
//  KCLiveStreamInteractor.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamInteractor.h"

@implementation KCLiveStreamInteractor

- (void)gotoHomeController{
    
    KC(self.context.presenter, KCLiveStreamPresenterDeleagte, stopLikeAnimating);

    [self.baseController dismissViewControllerAnimated:YES completion:^{
        KCLog(@"退出直播间");
    }];
}
@end
