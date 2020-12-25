//
//  LGHTableWebTableViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/16.
//

#import "LGHTableWebTableViewController.h"

@interface LGHTableWebTableViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollViews;

@property (nonatomic , strong)UIView     *contentView;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSArray *urlStrings;

@property (nonatomic, assign) CGFloat webViewContentHeight;

@property (nonatomic, assign) CGFloat tableViewContentHeight;

@property (nonatomic ,strong) UITableView *recommendTableView;

@property (nonatomic, assign) CGFloat recommendTableViewContentHeight;

@property (nonatomic ,strong) NSMutableArray * recommends;

@end

@implementation LGHTableWebTableViewController


-(NSMutableArray *)recommends{
    if (!_recommends) {
        _recommends = [NSMutableArray arrayWithCapacity:0];
    }
    return _recommends;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.urlStrings = @[
     @"https://doc.xiaoji.com/en/info/544.html",
     @"https://doc.xiaoji.com/en/info/230.html",
     @"https://doc.xiaoji.com/en/info/228.html"
    ];
    _webViewContentHeight = self.view.lgh_height;
    
    _tableViewContentHeight = 348;
    
    _recommendTableViewContentHeight = 0.1;
    
    [self setupScrollView];
    
    [self setupTableView];
    
    [self setupWebView];
    
    [self setupRecommendTableView];
    
    [self addKVO];
    
}


-(void)setupScrollView{
    self.scrollViews = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollViews.delegate = self;
    self.scrollViews.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollViews];
    
    _contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.lgh_width, _webViewContentHeight + _tableViewContentHeight + _recommendTableViewContentHeight)];
    _contentView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollViews addSubview:self.contentView];
    
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.lgh_width, _tableViewContentHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.showsVerticalScrollIndicator = false;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemBankHeadCell" bundle:nil] forCellReuseIdentifier:@"ItemBankHeadCell"];
    [self.contentView addSubview:self.tableView];
}

-(void)setupWebView{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, _tableViewContentHeight, self.view.lgh_width, self.view.lgh_height) configuration:configuration];
    _webView.scrollView.scrollEnabled = NO;
    _webView.navigationDelegate = self;
    uint32_t index = arc4random()%3;
    NSURL *url = [NSURL URLWithString:self.urlStrings[index]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    _webView.scrollView.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:_webView];
}

-(void)setupRecommendTableView{
    self.recommendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _tableViewContentHeight+_webViewContentHeight, self.view.lgh_width, _recommendTableViewContentHeight) style:UITableViewStylePlain];
    self.recommendTableView.delegate = self;
    self.recommendTableView.dataSource = self;
    self.recommendTableView.scrollEnabled = NO;
    self.recommendTableView.showsVerticalScrollIndicator = NO;
    self.recommendTableView.showsHorizontalScrollIndicator = NO;
    self.recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recommendTableView.tableFooterView = [[UIView alloc]init];
    [self.recommendTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.recommendTableView.showsVerticalScrollIndicator = false;
    [self.contentView addSubview:self.recommendTableView];
    
}

#pragma  mark  - addKVO
-(void)addKVO{
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.recommendTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView && [keyPath isEqualToString:@"scrollView.contentSize"] && _webViewContentHeight != _webView.scrollView.contentSize.height) {
        NSLog(@"height = %lf",_webView.scrollView.contentSize.height);
        // 获取当前的_webView.scrollView的contentSize的高度
        _webViewContentHeight = _webView.scrollView.contentSize.height;
        [self updateContainerScrollViewContentSize];
    }else if(object == _tableView && [keyPath isEqualToString:@"contentSize"] && (_tableViewContentHeight != _tableView.contentSize.height) ) {
        // 获取当前的_tableView.contentSize的高度
        _tableViewContentHeight = _tableView.contentSize.height;
        [self updateContainerScrollViewContentSize];
    }else if (object == _recommendTableView && [keyPath isEqualToString:@"contentSize"] && (_recommendTableViewContentHeight != _recommendTableView.contentSize.height)){
        
        _recommendTableViewContentHeight = _recommendTableView.contentSize.height;
        [self updateContainerScrollViewContentSize];
        
    }
}


-(void)updateContainerScrollViewContentSize{
    //根据webView.contentSize和tableView.contentSize的大小来决定self.containerScrollView.contentSize
    self.scrollViews.contentSize = CGSizeMake(self.view.lgh_width, _tableViewContentHeight + _webViewContentHeight + _recommendTableViewContentHeight);
    
    //如果内容不满一屏，则webView、tableView高度为内容高，超过一屏则最大高为一屏高
    CGFloat tableViewContentHeight = _tableViewContentHeight < self.view.lgh_height ? _tableViewContentHeight : self.view.lgh_height;
    CGFloat webViewContentHeight = (_webViewContentHeight < self.view.lgh_height) ? _webViewContentHeight : self.view.lgh_height;
    
    CGFloat recommendViewContentHeight = _recommendTableViewContentHeight < self.view.lgh_height ? _recommendTableViewContentHeight : self.view.lgh_height;
    
    self.contentView.lgh_height = webViewContentHeight + tableViewContentHeight + recommendViewContentHeight;
    
    
    self.tableView.lgh_height = tableViewContentHeight;
    
    self.webView.lgh_y = tableViewContentHeight;
    self.webView.lgh_height = webViewContentHeight <= 0.1 ? 0.1:webViewContentHeight;
    
    self.recommendTableView.lgh_y = self.webView.lgh_y + self.webView.lgh_height ;
    self.recommendTableView.lgh_height = recommendViewContentHeight <= 0.1 ? 0.1:recommendViewContentHeight;
    
    
    
    //更新展示区域
    [self scrollViewDidScroll:self.scrollViews];
}

#pragma  mark - UIScrollView



CGFloat oldOffsetY = 0;

BOOL    isReloadTable = NO;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_scrollViews != scrollView) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat webViewHeight = self.webView.lgh_height;
    CGFloat tableViewHeight = self.tableView.lgh_height;
    CGFloat recommedTableViewHeight = self.recommendTableView.lgh_height;
    
    NSLog(@"%@ - %lf",NSStringFromCGSize(scrollView.contentSize),offsetY);
    
    NSLog(@"%lf - %lf - %lf - %lf - %lf",offsetY,_tableViewContentHeight,tableViewHeight,_webViewContentHeight,webViewHeight);
    
    
    if (offsetY <= 0) {
        // 顶部下拉
        self.contentView.lgh_y = 0;
        self.tableView.contentOffset = CGPointZero;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.recommendTableView.contentOffset = CGPointZero;
    }else if (offsetY < _tableViewContentHeight - tableViewHeight){
        // 父scrollView偏移量的展示范围在tableView的最大偏移量内容区域
        self.contentView.lgh_y = offsetY;
        self.tableView.contentOffset = CGPointMake(0, offsetY);
        self.webView.scrollView.contentOffset = CGPointZero;
        self.recommendTableView.contentOffset = CGPointZero;
    }else if(offsetY < _tableViewContentHeight){
        //tableView滑到了底部
        self.contentView.lgh_y = _tableViewContentHeight - tableViewHeight;
        self.tableView.contentOffset = CGPointMake(0, _tableViewContentHeight - tableViewHeight);
        self.webView.scrollView.contentOffset = CGPointZero;
        self.recommendTableView.contentOffset = CGPointZero;
    }else if(offsetY < _tableViewContentHeight + _webViewContentHeight - webViewHeight){
        //父scrollView偏移量的展示范围到达webView的最大偏移量内容区域
        //调整webView的contentOffset
        self.contentView.lgh_y = offsetY - tableViewHeight;
    
        self.tableView.contentOffset = CGPointMake(0, _tableViewContentHeight - tableViewHeight);
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY - _tableViewContentHeight);
        
        self.recommendTableView.contentOffset = CGPointZero;
        
    }else if (offsetY <= _tableViewContentHeight + _webViewContentHeight){
        //WebView滑到了底部
        self.contentView.lgh_y = self.scrollViews.contentSize.height - self.contentView.lgh_height;
        
        
        self.tableView.contentOffset = CGPointMake(0, _tableViewContentHeight - tableViewHeight);
        
        self.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentHeight - webViewHeight);
        
        self.recommendTableView.contentOffset = CGPointZero;
    }else if (offsetY <= _tableViewContentHeight + _webViewContentHeight+_recommendTableViewContentHeight-recommedTableViewHeight){
        //父scrollView偏移量的展示范围到达_recommendTableView的最大偏移量内容区域
        self.contentView.lgh_y = offsetY - tableViewHeight - webViewHeight;
        
        self.tableView.contentOffset = CGPointMake(0, _tableViewContentHeight - tableViewHeight);
        self.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentHeight-webViewHeight);
        self.recommendTableView.contentOffset = CGPointMake(0, offsetY - _webViewContentHeight);
        
    }else if (offsetY <= _tableViewContentHeight+_webViewContentHeight+_recommendTableViewContentHeight){
        
        if ((offsetY-oldOffsetY)>0 && (offsetY>= (_tableViewContentHeight + _webViewContentHeight+_recommendTableViewContentHeight-recommedTableViewHeight +10)) && isReloadTable==NO) {
            isReloadTable = YES;
            [self.tableView reloadData];
        }
        
        self.contentView.lgh_y = self.scrollViews.contentSize.height - self.contentView.lgh_height;
        
        
        self.tableView.contentOffset = CGPointMake(0, _tableViewContentHeight - tableViewHeight);
        
        self.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentHeight - webViewHeight);
        
        self.recommendTableView.contentOffset = CGPointMake(0, _recommendTableViewContentHeight-recommedTableViewHeight);
    }
    
    oldOffsetY = offsetY;
    
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"webView: %@",webView);
    
    [self.recommends addObjectsFromArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Discuss" ofType:@"plist"]]];
    [self.recommendTableView reloadData];
    
}


#pragma  mark - UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.tableView) {
        return  1;
    }else{
        return self.recommends.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView==self.tableView) {
        static NSString *cellId = @"ItemBankHeadCell";
        ItemBankHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        }
        return cell;
    }else{
        
        static NSString *cellId = @"UITableViewCell";
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        if (self.recommends.count>0) {
            NSDictionary *dd = self.recommends[indexPath.row];
            cell.textLabel.text = dd[@"user"];
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.text = dd[@"content"];
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 348;
    }else{
        return 60;
    }
}

#pragma  mark - dealloc
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    [self.recommendTableView removeObserver:self forKeyPath:@"contentSize"];
}

@end
