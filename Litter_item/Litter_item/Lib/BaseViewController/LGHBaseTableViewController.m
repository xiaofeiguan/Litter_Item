//
//  LGHBaseTableViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/17.
//

#import "LGHBaseTableViewController.h"

@interface LGHBaseTableViewController ()

@end

@implementation LGHBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
}



@end
