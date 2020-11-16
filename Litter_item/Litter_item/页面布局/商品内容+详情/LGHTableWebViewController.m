//
//  LGHTableWebViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/15.
//

#import "LGHTableWebViewController.h"
#import "ItemBankHeadCell.h"
@interface LGHTableWebViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong)WKWebView *webView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIScrollView *scrollViews;

@property (nonatomic, strong) NSArray *urlStrings;

@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, assign) CGFloat tableViewHeight;
@end

@implementation LGHTableWebViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.urlStrings = @[
     @"https://doc.xiaoji.com/en/info/544.html",
     @"https://doc.xiaoji.com/en/info/230.html",
     @"https://doc.xiaoji.com/en/info/228.html"
    ];
    _webViewHeight = 0.0;
    
    [self setupTableView];
    
    
}

-(void)setupTableView{
    self.dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
   [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = false;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemBankHeadCell" bundle:nil] forCellReuseIdentifier:@"ItemBankHeadCell"];
}





#pragma  mark - UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellId = @"ItemBankHeadCell";
    ItemBankHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    _tableViewHeight = 348;
    return _tableViewHeight;
}


@end
