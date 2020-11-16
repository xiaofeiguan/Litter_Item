//
//  LGHWebTableViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/15.
//

#import "LGHWebTableViewController.h"

@interface LGHWebTableViewController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _webViewContentHeight;
    CGFloat _tableViewContentHeight;
}

@property (nonatomic, strong) WKWebView  *webView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) NSArray   *dataArr;

@property (nonatomic, copy) NSArray   *urlStrings;

@end

@implementation LGHWebTableViewController

// WkWebView + tableView
/*
 方案：
 采用【UIScrollView addSubView：WkWebView & tableView】，UIScrollView.contentSize = WKWebView.contentSize+tableView.contentSize;
 WKWebView和UITableView的最大高度为一屏高，并禁用scrollEnabled=NO，然后根据UIScrollView的滑动偏移量调整WKWebView和UITableView的展示区域contenOffset;
 
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.urlStrings = @[
     @"https://doc.xiaoji.com/en/info/544.html",
     @"https://doc.xiaoji.com/en/info/230.html",
     @"https://doc.xiaoji.com/en/info/228.html"
    ];
    [self setupUI];
    [self addKVO];
}

-(void)setupUI{
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.contentView];
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.tableView];
}


#pragma mark - Getter
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
        uint32_t index = arc4random()%3;
        NSURL *url = [NSURL URLWithString:self.urlStrings[index]];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        _webView.scrollView.backgroundColor = [UIColor brownColor];
    }
    return _webView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.lgh_height, self.view.lgh_width, self.view.lgh_height) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (UIScrollView *)containerScrollView{
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.lgh_x, self.view.lgh_y, self.view.lgh_width, self.view.lgh_height)];
        _containerScrollView.delegate = self;
        _containerScrollView.alwaysBounceVertical = YES;
    }
    return _containerScrollView;
}
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.lgh_width, self.view.lgh_height * 2)];
        _contentView.backgroundColor = [UIColor orangeColor];
    }
    return _contentView;
}

#pragma  mark  - addKVO
-(void)addKVO{
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView && [keyPath isEqualToString:@"scrollView.contentSize"] && _webViewContentHeight != _webView.scrollView.contentSize.height) {
        // 获取当前的_webView.scrollView的contentSize的高度
        _webViewContentHeight = _webView.scrollView.contentSize.height;
        [self updateContainerScrollViewContentSize];
    }else if(object == _tableView && [keyPath isEqualToString:@"contentSize"] && _tableViewContentHeight != _tableView.contentSize.height ) {
        // 获取当前的_tableView.contentSize的高度
        _tableViewContentHeight = _tableView.contentSize.height;
        [self updateContainerScrollViewContentSize];
    }
    
}

#pragma  mark - MethodTools

-(void)updateContainerScrollViewContentSize{
    //根据webView.contentSize和tableView.contentSize的大小来决定self.containerScrollView.contentSize
    self.containerScrollView.contentSize = CGSizeMake(self.view.lgh_width, _webViewContentHeight + _tableViewContentHeight);
    
    //如果内容不满一屏，则webView、tableView高度为内容高，超过一屏则最大高为一屏高
    CGFloat webViewHeight = (_webViewContentHeight < self.view.lgh_height) ? _webViewContentHeight : self.view.lgh_height ;
    CGFloat tableViewHeight = _tableViewContentHeight < self.view.lgh_height ? _tableViewContentHeight : self.view.lgh_height;
    
    self.contentView.lgh_height = webViewHeight + tableViewHeight;
    
    self.webView.lgh_height = webViewHeight <= 0.1 ?0.1 :webViewHeight;
    self.tableView.lgh_height = tableViewHeight;
    self.tableView.lgh_y = self.webView.lgh_height;
    
    //更新展示区域
    [self scrollViewDidScroll:self.containerScrollView];
}

#pragma  mark  - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Discuss" ofType:@"plist"];
    self.dataArr = [NSArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}


-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_containerScrollView != scrollView) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat webViewHeight = self.webView.lgh_height;
    CGFloat tableViewHeight = self.tableView.lgh_height;
    
    if (offsetY <= 0) {
        //顶部下拉
        self.contentView.lgh_y = 0;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < _webViewContentHeight - webViewHeight){
        //父scrollView偏移量的展示范围在webView的最大偏移量内容区域
        //contentView相对位置保持不动，调整webView的contentOffset
        self.contentView.lgh_y = offsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < _webViewContentHeight){
        //webView滑到了底部
        self.contentView.lgh_y = _webViewContentHeight - webViewHeight;
        self.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < _webViewContentHeight + _tableViewContentHeight - tableViewHeight){
        //父scrollView偏移量的展示范围到达tableView的最大偏移量内容区域
        //调整tableView的contentOffset
        self.contentView.lgh_y = offsetY - webViewHeight;
        self.tableView.contentOffset = CGPointMake(0, offsetY - _webViewContentHeight);
        self.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentHeight - webViewHeight);
    }else if(offsetY <= _webViewContentHeight + _tableViewContentHeight ){
        //tableView滑到了底部
        self.contentView.lgh_y = self.containerScrollView.contentSize.height - self.contentView.lgh_height;
        self.webView.scrollView.contentOffset = CGPointMake(0, _webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointMake(0, _tableViewContentHeight - tableViewHeight);
    }
}

#pragma  mark  - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    if (self.dataArr.count>0) {
        NSDictionary *dd = self.dataArr[indexPath.row];
        cell.textLabel.text = dd[@"user"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text = dd[@"content"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma  mark - dealloc
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}
@end
