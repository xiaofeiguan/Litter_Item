//
//  LGHReactiveCocoaViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/26.
//

#import "LGHReactiveCocoaViewController.h"
#import <RACSignal.h>
#import <RACSubscriber.h>
#import <RACDisposable.h>
#import "LGHRACSignal.h"
#import "LGHBaseTableDataSource.h"


/*
  RAC的原理：在我看来，就是用将订阅的内容保存在block上，等到执行subscribe的时候执行block
 */

@interface LGHReactiveCocoaViewController ()
@property(nonatomic,strong) RACSignal *signal;
@property(nonatomic,strong)LGHRACSignal * racSignal;

@property(nonatomic,strong)LGHBaseTableDataSource * dataSource;
@end

@implementation LGHReactiveCocoaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [@[
        @[
            @{
                @"title":@"关于ReactiveObjC原理及流程简介",
                @"url":@"https://www.jianshu.com/p/fecbe23d45c1"
            }
        ]
    ] mutableCopy];
    
    self.dataSource = [[LGHBaseTableDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell* _Nonnull cell, NSDictionary*  _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = model[@"title"];
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
        
        NSDictionary *data = self.datas[indexPath.section][indexPath.row];
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
    
    [self testRAC];
    
}

-(void)testRAC{
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"🍺🍺🍺🍺🍺🍺🍺"];
        [subscriber sendCompleted];
        return  [RACDisposable disposableWithBlock:^{
            NSLog(@"销毁了");
        }];
    } ];
    
    self.racSignal = [LGHRACSignal createSingal:^{
        NSLog(@"在这里subscribe");
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
    }];
    
    [self.racSignal subscribe];
    
}

@end
