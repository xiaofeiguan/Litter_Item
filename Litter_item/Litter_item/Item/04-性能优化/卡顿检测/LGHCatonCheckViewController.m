//
//  LGHCatonCheckViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/1.
//

#import "LGHCatonCheckViewController.h"
#import "LGHBaseTableDataSource.h"
@interface LGHCatonCheckViewController ()
@property (nonatomic, strong) LGHBaseTableDataSource * dataSource;
@end

@implementation LGHCatonCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

-(void)setupTableView{
    __weak typeof(self) weakSelf = self;
    self.dataSource = [[LGHBaseTableDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell* _Nonnull cell, NSDictionary*  _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = model[@"title"];
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
        NSDictionary *data = weakSelf.datas[indexPath.section][indexPath.row];
        NSString *url = data[@"url"];
        if (url.length==0) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            LGHBaseWKWebViewController *webVC = [[LGHBaseWKWebViewController alloc]initWithUrl:url];
            if (weakSelf.navigationController) {
                [weakSelf.navigationController pushViewController:webVC animated:NO];
            }else{
                [weakSelf presentViewController:webVC animated:YES completion:^{
                    
                }];
            }
        });
        
    }];
    
    NSArray *array =  @[
        @{
            @"title":@"卡顿检测二(Runloop检测)",
            @"url":@"https://github.com/Tencent/matrix"
        },
        @{
            @"title":@"卡顿检测三(滴滴检测方案)",
            @"url":@"https://github.com/didi/DoraemonKit"
        },
    ];
    self.datas = [@[array]mutableCopy];
    
    [self.dataSource dataWithArray:[self.datas copy]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}

@end
