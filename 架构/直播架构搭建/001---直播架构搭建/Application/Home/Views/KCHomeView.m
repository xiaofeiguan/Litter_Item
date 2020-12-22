//
//  KCHomeView.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCHomeView.h"
#import "KCChannelProfile.h"
#import "KCHomeAdapter.h"

@interface KCHomeView ()
@property (nonatomic, strong) UITableView   *tableView;
@end


@implementation KCHomeView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)buildHomeView:(KCHomeAdapter *)adapter {
    
    CGRect frame = self.bounds;
    frame.origin.y = 20;
    frame.size.height -= (20+44);
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.clipsToBounds = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    _tableView.delegate = adapter;
    _tableView.dataSource = adapter;
    
//    //prepare test data
//    NSMutableArray* dataArray = @[].mutableCopy;
//    for (int i = 0; i < 20; i ++) {
//        KCChannelProfile* channel = [KCChannelProfile new];
//        channel.ownerName       = @"Logic";
//        channel.title           = @"姿势从未如此性感,学习从未如此快乐";
//        channel.ownerLocation   = @"湖南逻辑教育";
//        channel.userCount       = @(10000);
//
//        if (i%3 == 0) {
//            channel.ownerCover  = @"publicPicture";
//        }else if (i%3 == 1){
//            channel.ownerCover  = @"adance";
//        }else{
//            channel.ownerCover  = @"reverse";
//        }
//        [dataArray addObject:channel];
//    }
//
//    [adapter setAdapterArray:dataArray];
//    [_tableView reloadData];
    
    
 
}

- (void)reloadUIWithData{

    [_tableView reloadData];
}


@end
