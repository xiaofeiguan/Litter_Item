//
//  LGHBaseWKWebViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/17.
//

#import "LGHBaseWKWebViewController.h"

@interface LGHBaseWKWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSString * url;
@property (nonatomic, strong) UIProgressView  *loadProgressView;
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic, retain) UIButton*             shareButton;
@property (nonatomic, strong) NSString * currentAppstoreString;

@end

@implementation LGHBaseWKWebViewController


- (instancetype)initWithUrl:(NSString*)url {
    if (self = [super init]) {
        self.url = url;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setupProgressView{
    // loadProgressView 添加加载进度条
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.loadProgressView  = [[UIProgressView alloc]init];
    self.loadProgressView.tintColor = UIColorFromHex(0x0080ff);
    self.loadProgressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.loadProgressView];
    [self.loadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1.5f);
        make.top.mas_equalTo(statusHeight+44);
    }];
}

-(void)loadWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回（NO是禁止）
    _webView.allowsBackForwardNavigationGestures = NO;
    _webView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loadProgressView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupProgressView];
    [self loadWebView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)setupNavi{
    __weak typeof(self) weak_self = self;
    self.shareButton = [UIButton LGH_make:^(LGHButtonMaker *make) {
        make.image([UIImage imageNamed:@"help_share_gray"], UIControlStateNormal)
        .frame(CGRectMake(0, 0, 35, 35))
        .action(^(UIButton *button) {
            if (!weak_self.webView.title || !weak_self.webView.URL || ![UIImage imageNamed:@"gamesir_small"]) {// 防止添加到数组后崩溃
                return;
            }
            // 调用系统自带的分享界面
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[weak_self.webView.title, weak_self.webView.URL, [UIImage imageNamed:@"gamesir_small"]] applicationActivities:nil];
            // iPad必须通过popoverPresentationController才能弹出UIActivityViewController
            if ([activityController respondsToSelector:@selector(popoverPresentationController)]) {
                activityController.popoverPresentationController.sourceView = weak_self.shareButton;
            }
            [weak_self.navigationController presentViewController:activityController animated:YES completion:nil];
            // 分享回调
            activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                if (completed) {
                    NSLog(@"分享完成");
                }else {
                    NSLog(@"分享失败：%@", activityError);
                }
            };
        });
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
}

#pragma mark - Action/Tap
-(void)back{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView)
        {
            self.title = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey]doubleValue];
        self.loadProgressView.hidden = NO;
        [self.loadProgressView setProgress:newprogress animated:YES];
        NSLog(@"newprogress:%lf",newprogress);
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f animations:^{
                [self.loadProgressView setProgress:newprogress animated:YES];
            } completion:^(BOOL finished) {
                self.loadProgressView.hidden = YES;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKUIDelegate
// 创建一个新的WebView
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"收到响应后:%@",navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
    return;
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"发送请求之前:%@",navigationAction.request.URL.absoluteString);
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url hasPrefix:@"https://itunes.apple.com"]) {
        self.currentAppstoreString = url;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Jump to AppStore" delegate:self cancelButtonTitle:@"confirm" otherButtonTitles:@"cancel", nil];
        [alertView show];
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    return ;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.currentAppstoreString]];
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
