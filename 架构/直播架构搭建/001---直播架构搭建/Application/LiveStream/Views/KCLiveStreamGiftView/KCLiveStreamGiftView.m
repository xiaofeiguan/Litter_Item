//
//  KCLiveStreamGiftView.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamGiftView.h"
#import "KCLiveStreamGiftBanner.h"
#import "KCLiveStreamGiftChannelMessage.h"

@interface KCLiveStreamGiftView ()
@property (nonatomic, strong) KCLiveStreamGiftBanner *topBanner;
@property (nonatomic, strong) KCLiveStreamGiftBanner *bottomBanner;

@end

@implementation KCLiveStreamGiftView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor randomColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initCustomView {
	
}


#pragma mark - normal gifts
- (void)showGeneralGiftAnimation:(KCLiveStreamGiftChannelMessage *)giftMsg {
    
    if (giftMsg.tapCount == 0) {
        return;
    }
    
    if ([self hasFreeSpace] == false) {
        return;
    }
    
    int bannerWidth = [KCLiveStreamGiftBanner bannerWidth];
    int bannerHeight = [KCLiveStreamGiftBanner bannerHeight];
    
    int bottomMargin = 80 + 300;
    int originY = SCREEN_HEIGHT - bottomMargin - bannerHeight;
    int padding = 20;
    int line = 2;
    
    if (_bottomBanner == nil) {
        //
    }
    else if(_topBanner == nil)
    {
        originY -= (padding + bannerHeight);
        line = 1;
    }
    
    KCLiveStreamGiftBanner *giftBanner = [[KCLiveStreamGiftBanner alloc] initWithFrame:CGRectMake(0, originY, bannerWidth, bannerHeight)];
    [self addSubview:giftBanner];
    [giftBanner initWithGiftMsg:giftMsg showLine:line];
    
    if (line == 1) {
        self.topBanner = giftBanner;
    }
    else if (line == 2)
    {
        self.bottomBanner = giftBanner;
    }
    
    [giftBanner showWithAnimationFinishBlock:^(int line) {
        
        if (line == 2) {
            self.bottomBanner = nil;
        }
        else if (line == 1)
        {
            self.topBanner = nil;
        }
        
    }];
    
}

- (KCLiveStreamGiftBanner *)getTopBanner
{
    return _topBanner;
}

- (KCLiveStreamGiftBanner *)getBottomBanner
{
    return _bottomBanner;
}

- (BOOL)hasFreeSpace
{
    return _topBanner == nil || _bottomBanner == nil;
}


@end
