//
//  LGHTableViewFoldController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/24.
//

#import "LGHTableViewFoldController.h"
#import "LGHBaseTableDataSource.h"
@interface LGHTableViewFoldController ()
@property (nonatomic, strong) LGHBaseTableDataSource * dataSource;
@end

@implementation LGHTableViewFoldController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray arrayWithArray:@[
        @{
            @"title":@"iOS优化篇之APP启动时间优化",
            @"url":@"https://juejin.im/post/6861917375382929415"},
        @{
            @"title":@"深入理解 iOS 启动流程和优化技巧",
            @"url":@"https://juejin.im/post/6891605418770956301"
        },
        @{
            @"title":@"抖音品质建设 - iOS启动优化《原理篇》",
            @"url":@"https://juejin.im/post/6887741815529832456"},
        @{
            @"title":@"基于二进制文件重排的解决方案 APP启动速度提升超15%",
            @"url":@"https://mp.weixin.qq.com/s?__biz=MzI1MzYzMjE0MQ==&mid=2247485101&idx=1&sn=abbbb6da1aba37a04047fc210363bcc9&scene=21&token=2051547505&lang=zh_CN"
        },
        @{
            @"title":@"利用Clang插桩，获取所有符号，实现二进制重排",
            @"url":@"http://note.youdao.com/s/CDN4dO76"}
        
    ]];
    
    self.dataSource = [[LGHBaseTableDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell* _Nonnull cell, NSDictionary*  _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    [self.dataSource dataWithArray:[NSArray arrayWithObject:[self.datas copy]]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}



@end
