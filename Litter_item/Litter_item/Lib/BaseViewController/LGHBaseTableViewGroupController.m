//
//  LGHBaseTableViewGroupController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/24.
//

#import "LGHBaseTableViewGroupController.h"

@interface LGHBaseTableViewGroupController ()

@end

@implementation LGHBaseTableViewGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
}

@end
