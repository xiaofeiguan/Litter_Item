//
//  KCHomeView.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import "KCHomeView.h"
#import "KCHomeAdapter.h"

@interface KCHomeView ()
@property (nonatomic, strong) UITableView * tableView;
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
}

-(void)reloadUIWithData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}



-(void)dealloc{
    
    NSLog(@"dealloc:%@",[self class]);
}



@end
