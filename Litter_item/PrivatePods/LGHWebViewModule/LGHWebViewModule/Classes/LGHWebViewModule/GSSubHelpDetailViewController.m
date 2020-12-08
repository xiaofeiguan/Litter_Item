//
//  GSSubHelpDetailViewController.m
//  HelpDetail
//
//  Created by gamesirDev on 10/4/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import "GSSubHelpDetailViewController.h"
#import <WebKit/WebKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Masonry.h"
#import "XJViewMakerHeader.h"
#import "Define.h"

@interface GSSubHelpDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
//@property (nonatomic, retain) GSAssistanceDetailLandscapeView*               helpView;
@property (nonatomic,strong) NSString * URLString;
@property (nonatomic, strong) WKWebView*            webView;
/// iPhoneX横屏时，顶部的填充View
@property (nonatomic, retain) UIView*               iPhoneXTopFillView;
@property (nonatomic, retain) UIView*               navigationView;
@property (nonatomic, retain) UILabel*              titleLabel;
@property (nonatomic, retain) UIButton*             backButton;
@property (nonatomic, retain) UIButton*             rotateButton;
@property (nonatomic, retain) UIButton*             shareButton;
@end

@implementation GSSubHelpDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

    // 注释原因：此属性将阻止”强制屏幕转到指定方向“方法的执行
//    [[NSUserDefaults standardUserDefaults] setInteger:UIInterfaceOrientationMaskLandscape forKey:@"GSDeviceSupportedOrientationMask"];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    [self rotateToSupportOrientation];
    [self updateNavigationView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/// 旋转屏幕
- (void)rotateToSupportOrientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    // 注意：此页面的默认方向是当前屏幕方向，这也是这个页面存在的原因
    int val = (int)[UIApplication sharedApplication].statusBarOrientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}


- (instancetype)initWithURLString:(NSString *)URLString {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];// 不是监测UIDeviceOrientationDidChangeNotification
        
        self.URLString = URLString;
        self.view.backgroundColor = UIColorFromHex(0xe5e5e5);
        [self commonInit];
        [self loadWebView];
    }
    return self;
}

- (void)orientationDidChange:(NSNotification*)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateNavigationView];
    });
}

static CGFloat kNavigationViewHeight = 45.;
static CGFloat kNavigationViewTopConstraintOnIPhoneX = 30.;

- (void)commonInit {
    self.navigationView = [UIView xj_make:^(XJViewMaker *make) {
        make.addTo(self.view)
        .backgroundColor(UIColorFromHex(0x111a1f));
    }];
    
    self.titleLabel = [UILabel xj_make:^(XJLabelMaker *make) {
        make.addTo(self.navigationView)
        .backgroundColor(UIColor.clearColor)
        .textColor(UIColor.whiteColor)
        .font([UIFont fontWithName:@"PingFangSC-Regular" size:16.f])
        .textAlignment(NSTextAlignmentCenter);
    }];
    
    @weakify(self);
    self.backButton = [UIButton xj_make:^(XJButtonMaker *make) {
        make.addTo(self.navigationView)
        .image([UIImage imageNamed:@"arrow_left"], UIControlStateNormal)
        .action(^(UIButton *button) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GSPopFromAssistanceDetailLandscapeViewController"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weak_self.navigationController popViewControllerAnimated:YES];
        });
    }];
    
    self.rotateButton = [UIButton xj_make:^(XJButtonMaker *make) {
        make.addTo(self.navigationView)
        .image([UIImage imageNamed:@"device_transform_white"], UIControlStateSelected)
        .image([UIImage imageNamed:@"device_transform_portrait_white"], UIControlStateNormal)
        .action(^(UIButton *button) {
            button.selected = !button.selected;
            [weak_self switchOrientation];
            [weak_self updateNavigationView];
        });
    }];
    
    self.shareButton = [UIButton xj_make:^(XJButtonMaker *make) {
        make.addTo(self.navigationView)
        .image([UIImage imageNamed:@"help_share_white"], UIControlStateNormal)
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
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).priorityMedium();
        make.height.mas_equalTo(kNavigationViewHeight);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationView).offset(-10).priorityMedium();
        make.width.mas_equalTo(kNavigationViewHeight);
        make.top.equalTo(self.navigationView).offset(5.);
        make.bottom.equalTo(self.navigationView);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.navigationView);
        make.width.mas_equalTo(kNavigationViewHeight);
    }];
    
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareButton.mas_left).offset(-1);
        make.width.mas_equalTo(kNavigationViewHeight);
        make.top.equalTo(self.navigationView).offset(5.);
        make.bottom.equalTo(self.navigationView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationView);
        make.top.equalTo(self.navigationView);
        make.left.equalTo(self.backButton.mas_right).offset(0);
        make.right.equalTo(self.rotateButton.mas_left).offset(-0);
    }];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"GSCurrentDeviceIsIPhoneXSeries"]) {
        self.iPhoneXTopFillView = [UIView xj_make:^(XJViewMaker *make) {
            make.addTo(self.view)
            .backgroundColor(UIColorFromHex(0x111a1f));
        }];
        [self.iPhoneXTopFillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navigationView.mas_top);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(kNavigationViewTopConstraintOnIPhoneX);
        }];
    }
}

#pragma mark - 横竖屏切换

- (void)switchOrientation {
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;// 屏幕当前方向
    
    if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        [self rotateToOrientation:UIInterfaceOrientationPortrait];
    }else {
        [self rotateToOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

#pragma mark - 强制屏幕转到指定方向

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = (int)orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - 更新顶部的UI

- (void)updateNavigationView {
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self.view needsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4f animations:^{
        [self.navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (statusBarOrientation == UIInterfaceOrientationPortrait &&  [[NSUserDefaults standardUserDefaults] boolForKey:@"GSCurrentDeviceIsIPhoneXSeries"]) {// 适配iPhone X顶部
                make.top.equalTo(self.view).offset(kNavigationViewTopConstraintOnIPhoneX);
            }else {
                make.top.equalTo(self.view).offset(0.);
            }
        }];
        
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            if (statusBarOrientation == UIInterfaceOrientationPortrait) {// 竖屏时右侧宽度较小，把按钮置于边上
                make.right.equalTo(self.navigationView).offset(0.);
            }else {
                make.right.equalTo(self.navigationView).offset(-10.);
            }
        }];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)loadWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.titleLabel.text = self.webView.title;
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
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
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if ([navigationAction.request.URL.absoluteString hasSuffix:@".html"]&&(![navigationAction.request.URL.absoluteString isEqualToString:self.URLString])) {
        NSString *url = navigationAction.request.URL.absoluteString;
        [self pushToDetailViewController:url];
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)pushToDetailViewController:(NSString *)url {
    GSSubHelpDetailViewController *helpVC = [[GSSubHelpDetailViewController alloc] initWithURLString:url];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
