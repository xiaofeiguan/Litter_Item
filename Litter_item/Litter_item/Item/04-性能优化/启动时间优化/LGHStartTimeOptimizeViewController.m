//
//  LGHStartTimeOptimizeViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/17.
//

/*
  启动时间优化: 
 
 */

#import "LGHStartTimeOptimizeViewController.h"

@interface LGHStartTimeOptimizeViewController ()
@property (nonatomic, strong) LGHBaseTableDataSource * dataSource;
@end

@implementation LGHStartTimeOptimizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [@[
        @[
            @{
                @"title":@"利用Clang插桩，获取所有符号，实现二进制重排",
                @"url":@"http://note.youdao.com/s/CDN4dO76"}
            
        ],
        @[
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
                @"title":@"iOS 优化篇 - 启动优化之Clang插桩实现二进制重排",
                @"url":@"https://juejin.cn/post/6844904130406793224"},
            @{
                @"title":@"iOS优化篇之App启动时间优化",
                @"url":@"https://www.jianshu.com/p/bae1e9bddcc9"}
        ]
    ] mutableCopy ];
    NSLog(@"%ld",self.tableView.style);
    
    __weak typeof(self) weakSelf = self;
    self.dataSource = [[LGHBaseTableDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell* _Nonnull cell, NSDictionary*  _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = model[@"title"];
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
        NSDictionary *data = strongSelf.datas[indexPath.section][indexPath.row];
        NSString *url = data[@"url"];
        if (url.length==0) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            LGHBaseWKWebViewController *webVC = [[LGHBaseWKWebViewController alloc]initWithUrl:url];
            if (strongSelf.navigationController) {
                [strongSelf.navigationController pushViewController:webVC animated:NO];
            }else{
                [strongSelf presentViewController:webVC animated:YES completion:^{
                    
                }];
            }
        });
        
    }];
    
    [self.dataSource dataWithArray:[self.datas copy]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
    
}


@end
