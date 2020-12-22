//
//  KCHomePresent.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCHomePresenter.h"
#import "KCChannelProfile.h"
#import "KCHomeAdapter.h"

@implementation KCHomePresenter


- (void)loadDataWithAdapter:(KCBaseAdapter *)adapter{
    //prepare test data

    for (int i = 0; i < 20; i ++) {
        KCChannelProfile* channel = [KCChannelProfile new];
        channel.ownerName       = @"Logic";
        channel.title           = @"姿势从未如此性感,学习从未如此快乐";
        channel.ownerLocation   = @"湖南逻辑教育";
        channel.userCount       = @(10000);
        
        if (i%3 == 0) {
            channel.ownerCover  = @"publicPicture";
        }else if (i%3 == 1){
            channel.ownerCover  = @"adance";
        }else{
            channel.ownerCover  = @"reverse";
        }
        [self.dataArray addObject:channel];
    }
    
    [adapter setAdapterArray:self.dataArray];
    
    KC(self.view, KCHomePresentDelegate, reloadUIWithData);
}

#pragma mark - lazy

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}

@end
