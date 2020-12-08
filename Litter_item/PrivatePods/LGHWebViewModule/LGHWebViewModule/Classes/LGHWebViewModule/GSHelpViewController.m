//
//  GSHelpViewController.m
//  CTMediator
//
//  Created by gamesirDev on 14/4/2020.
//

#import "GSHelpViewController.h"
#import "GSCombineButton.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "GSBaseNoDataView.h"
#import "GSTool.h"
#import "Define.h"
#import <WebKit/WebKit.h>
#import "GSCombineButton.h"
#import "Masonry.h"
#import "MBProgressHUD+Util.h"
#import "GSHelpDetailViewController.h"

#define GSNaviTopHeight ([[NSUserDefaults standardUserDefaults] boolForKey:@"GSCurrentDeviceIsIPhoneXSeries"] ? 88 : 64)
#define GSTabBarBottomHeight ([[NSUserDefaults standardUserDefaults] boolForKey:@"GSCurrentDeviceIsIPhoneXSeries"] ? (49 + 34) : 49)

@interface GSHelpViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) GSCombineButton * leftButton;
@property (nonatomic,strong) WKWebView * mainWebView;
@property (nonatomic,assign) XJDeviceType  currentType;
@property (nonatomic, retain) UIButton*             shareButton;
@property (nonatomic, strong) UIProgressView  *loadProgressView;
@property (nonatomic, strong) GSBaseNoDataView * noneNetworkView;
@end

@implementation GSHelpViewController

- (void)reloadWebViewWithDeviceType:(XJDeviceType)type {
    if(type != self.currentType){
        self.currentType = type;
        NSString *shortName = [DeviceTool shortNameWithType:self.currentType];
        self.leftButton.title = [shortName isEqualToString:@"i3"]?shortName:shortName.uppercaseString;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[ DeviceTool getRequestURLStringWithType:self.currentType]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        [self.mainWebView loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 重新加载网页。原因：初次启动App后，点击TabBar的「帮助」按钮，如果此时webView加载完毕，只显示了占位图，而不是正确的图片。（原因未知）
        [self.mainWebView reload];
    });
}

- (void)handleBadNetwork {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GSCurrentNetworkStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noneNetworkView.hidden = NO;
        [self.view bringSubviewToFront:self.noneNetworkView];
    });
}

- (void)handleGoodNetwork {
    dispatch_async(dispatch_get_main_queue(), ^{
        _noneNetworkView.hidden = YES;
        [self.view sendSubviewToBack:_noneNetworkView];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GSCurrentNetworkStatus"] == NO) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[DeviceTool getRequestURLStringWithType:self.currentType]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
            [self.mainWebView loadRequest:request];
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GSCurrentNetworkStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBadNetwork) name:@"GSNetworkStatusBadNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGoodNetwork) name:@"GSNetworkStatusGoodNotification" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectTabBarItem:) name:@"XJDidSelectTabBarNotificaton" object:nil];

    self.view.backgroundColor = UIColor.clearColor;
    self.currentType = [self getLastUsedDevice];
    
    //禁用全局返回手势
    self.fd_interactivePopDisabled = YES;
    
    [self setupNavi];
}

- (void)setLastUsedDevice:(XJDeviceType)type{
    NSUserDefaults *manager = [NSUserDefaults standardUserDefaults];
    [manager setValue:@(type) forKey:@"LAST_USED_DEVICE"];
    [manager synchronize];
}

- (XJDeviceType)getLastUsedDevice {
    NSUserDefaults *manager = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [manager valueForKey:@"LAST_USED_DEVICE"];
    if (!num) {
        [self setLastUsedDevice:XJDeviceTypeG6];
        return XJDeviceTypeG6;
    }
    XJDeviceType type = num.integerValue;
    return type;
}

- (UIProgressView *)loadProgressView {
    if (_loadProgressView == nil) {
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
         _loadProgressView  = [[UIProgressView alloc]init];
         _loadProgressView.tintColor = UIColorFromHex(0x0080ff);
         _loadProgressView.trackTintColor = [UIColor whiteColor];
         [self.view addSubview:_loadProgressView];
         [_loadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.right.mas_equalTo(0);
             make.height.mas_equalTo(1.5f);
             make.top.mas_equalTo(statusHeight+44);
         }];
    }
    return _loadProgressView;
}

- (void)setupNavi {
    self.leftButton = [[GSCombineButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBarButtonTarget)];
    [self.leftButton addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    XJDeviceType device = [self getLastUsedDevice];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentType = device;
    });
    
    /* 注释原因：帮助首页不需要分享功能 2019年10月29日15:35:26
     @weakify(self);
     self.shareButton = [UIButton xj_make:^(XJButtonMaker *make) {
     make.image([UIImage imageByName:@"help_share_gray"], UIControlStateNormal)
     .frame(CGRectMake(0, 0, 35, 35))
     //        .backgroundColor(UIColor.purpleColor)
     .action(^(UIButton *button) {
     [weak_self shareBoardBySelfDefined];
     });
     }];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
     */
}

// leftBarButton点击响应事件
- (void)leftBarButtonTarget {
    // 使用通知的方式显示设备列表页面；等设备列表页面组件化之后，再使用跨组件化调用的方法代替。
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GSShowGamepadListNotification" object:@(self.currentType)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.mainWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey]doubleValue];
        self.loadProgressView.hidden = NO;
        [self.loadProgressView setProgress:newprogress animated:YES];
        NSLog(@"newprogress:%lf",newprogress);
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.1f animations:^{
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
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
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
    if (self.tabBarController.selectedIndex==1) {
    }
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didFailProvisionalNavigation");
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailNavigation");
}

-(void)webViewDidClose:(WKWebView *)webView{
    NSLog(@"webViewDidClose");
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"1>:%@",navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
    return;
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"2>:%@",navigationAction.request.URL.absoluteString);
    NSString *urlstring = navigationAction.request.URL.absoluteString;
    if ([urlstring containsString:@"http"]&&[urlstring containsString:@"help.html?lang="]) {
        /* 注释原因：当跳转到需要隐藏tabBar的VC，不能再弹出tabBar。
         [self.navigationController setNavigationBarHidden:NO animated:YES];
         self.tabBarController.tabBar.hidden = NO;
         */
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }else{
        if ([navigationAction.request.URL.absoluteString hasSuffix:@".html"]) {
            NSString *url = navigationAction.request.URL.absoluteString;
            [self pushToDetailPageWithURLString:url];
        }
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
}



#pragma mark - Tools

- (void)pushToDetailPageWithURLString:(NSString *)url {
    // 模拟后台控制跳转的页面-URL方式
//    [[CTMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:@"GameSirOTA://Help/pushToDetailViewController?url=https://doc.xiaoji.com/zh/info/30.html"] completion:^(NSDictionary *info) {
//    }];
#if 1
    GSHelpDetailViewController *helpDetailVC = [[GSHelpDetailViewController alloc]initWithUrl:url];
    [self.navigationController pushViewController:helpDetailVC animated:NO];
#endif
}

#pragma mark - Notification
//- (void)didSelectTabBarItem:(NSNotification *)noti {
//    NSInteger selectIndex = ((NSNumber*)noti.object).integerValue;
//    if (selectIndex == 1) {
//        //注释原因:只要首页设备更改，帮助页也出现对应的设备帮助
//        //        if ([GSDeviceManager sharedGamePad].connected) {
//        //        }
//        XJDeviceType type = [self getLastUsedDevice];
//        if(type != self.currentType){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.currentType = type;
//                NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[[CTMediator sharedInstance] Help_getRequestURLStringWithDeviceType:self.currentType]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
//                [self.mainWebView loadRequest:request];
//            });
//        }
//    }
//}

- (WKWebView *)mainWebView {
    if (_mainWebView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        _mainWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _mainWebView.UIDelegate = self;
        _mainWebView.navigationDelegate = self;
        _mainWebView.backgroundColor = UIColor.whiteColor;
        _mainWebView.allowsBackForwardNavigationGestures = NO;
        [self.view addSubview:_mainWebView];
        
        [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loadProgressView.mas_bottom).mas_offset(0);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-GSTabBarBottomHeight);
        }];
        NSString *loadString = [DeviceTool getRequestURLStringWithType:self.currentType];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:loadString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        [_mainWebView loadRequest:request];
        [_mainWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _mainWebView;
}

- (GSBaseNoDataView *)noneNetworkView {
    if (_noneNetworkView == nil) {
        _noneNetworkView = (GSBaseNoDataView*)[[UINib nibWithNibName:NSStringFromClass([GSBaseNoDataView class]) bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        _noneNetworkView.content = @"";
        _noneNetworkView.detailContent = i18n(@"NetworkIsError,PleaseCheckTheNetwork");
        _noneNetworkView.buttonTitle = i18n(@"Reload");
        _noneNetworkView.imageName = @"load_failed";
        [self.view addSubview:_noneNetworkView];
        
        [_noneNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_equalTo(GSNaviTopHeight);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(-[UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom);
            } else {
                make.bottom.mas_equalTo(0.f);
            }
        }];
        
        _noneNetworkView.buttonActionBlock = ^{
            [MBProgressHUD showWaitingViewAfterDelay:1.];// 只展示等待标志，等网络恢复，会自动刷新页面
        };
    }
    return _noneNetworkView;
}

- (void)setCurrentType:(XJDeviceType)currentType {
    _currentType = currentType;
    NSString *shortName = [DeviceTool shortNameWithType:currentType];
    if ([shortName isEqualToString:@"i3"]) {
        self.leftButton.title = shortName;
    }else if([shortName isEqualToString:@"f4"]){
        NSString *f4Name;
        if ([[[GSTool shared] getLocalLanguage] isEqualToString:@"zh"]) {
            f4Name = @"F4猎鹰";
        }else {
            f4Name = @"F4 FALCON";
        }
        self.leftButton.title = f4Name;
    }else if([shortName isEqualToString:@"g6"]){
        self.leftButton.title  = @"G6/G6s";
    }else{
        self.leftButton.title = shortName.uppercaseString;
    }
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mainWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    NSLog(@"dealloc %@",[self class]);
}

@end
