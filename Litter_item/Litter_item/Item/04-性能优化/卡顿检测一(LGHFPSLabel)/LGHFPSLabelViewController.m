//
//  LGHFPSLabelViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/1.
//

#import "LGHFPSLabelViewController.h"
#import "LGHFPSLabel.h"
#import "LGHBaseTableDataSource.h"
#import "YYFPSLabel.h"
@interface LGHFPSLabelViewController ()
@property (nonatomic, strong) LGHFPSLabel * fpsLabel;
//@property (nonatomic, strong) YYFPSLabel * fpsLabel;

@property (nonatomic, strong) LGHBaseTableDataSource * dataSource;
@end

@implementation LGHFPSLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.fpsLabel = [[LGHFPSLabel alloc]initWithFrame:CGRectMake(LGHScreenWidth/2.0, LGHScreenHeight/2.0, 0, 0)];
    
//    self.fpsLabel = [[YYFPSLabel alloc]initWithFrame:CGRectMake(LGHScreenWidth/2.0, LGHScreenHeight/2.0, 0, 0)];
    
    [self.view addSubview:self.fpsLabel];
    
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
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [array addObject:@{@"title":[NSString stringWithFormat:@"这是第%d个cell",i]}];
    }
    
    self.datas = [@[array]mutableCopy];
    
    [self.dataSource dataWithArray:[self.datas copy]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}



-(void)dealloc{
}

@end
