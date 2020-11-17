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
            @"url":@"https://juejin.im/post/6887741815529832456"}
    ]];
    
    self.dataSource = [[LGHBaseTableDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell* _Nonnull cell, NSDictionary*  _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        cell.textLabel.text = model[@"title"];
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
        NSDictionary *data = self.datas[indexPath.row];
        NSString *url = data[@"url"];
        dispatch_async(dispatch_get_main_queue(), ^{
            LGHBaseWKWebViewController *webVC = [[LGHBaseWKWebViewController alloc]initWithUrl:url];
            if (self.navigationController) {
                [self.navigationController pushViewController:webVC animated:NO];
            }else{
                [self presentViewController:webVC animated:YES completion:^{
                    
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
