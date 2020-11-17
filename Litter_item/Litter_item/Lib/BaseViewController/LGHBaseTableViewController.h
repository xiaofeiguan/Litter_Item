//
//  LGHBaseTableViewController.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/17.
//

#import <UIKit/UIKit.h>
#import "LGHBaseWKWebViewController.h"
#import "LGHBaseTableDataSource.h"
NS_ASSUME_NONNULL_BEGIN

@interface LGHBaseTableViewController : UIViewController

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * datas;

@end

NS_ASSUME_NONNULL_END
