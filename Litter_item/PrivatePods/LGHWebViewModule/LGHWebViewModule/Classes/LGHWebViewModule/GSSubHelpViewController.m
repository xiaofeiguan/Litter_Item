//
//  GSSubHelpViewController.m
//  GameSirOTA
//
//  Created by gamesirDev on 23/10/2019.
//  Copyright © 2019 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import "GSSubHelpViewController.h"
#import <WebKit/WebKit.h>
#import "XJViewMakerHeader.h"
#import "Masonry.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DeviceTool.h"
#import "GSTool.h"
#import "Define.h"
#import "GSSubHelpDetailViewController.h"

@interface GSSubHelpViewController ()<WKNavigationDelegate>
@property (nonatomic, assign) GSTutorialType        helpType;
@property (nonatomic, assign) XJDeviceType          deviceType;
@property (nonatomic, strong) WKWebView*            webView;
/// iPhoneX横屏时，顶部的填充View
@property (nonatomic, retain) UIView*               iPhoneXTopFillView;
@property (nonatomic, retain) UIView*               navigationView;
@property (nonatomic, retain) UILabel*              titleLabel;
@property (nonatomic, retain) UIButton*             backButton;
@property (nonatomic, retain) UIButton*             rotateButton;
@property (nonatomic, retain) UIButton*             shareButton;
@end

@implementation GSSubHelpViewController

- (instancetype)initWithType:(GSTutorialType)type {
    if (self = [super init]) {
        self.helpType = type;
        self.view.backgroundColor = UIColorFromHex(0xe5e5e5);
        self.deviceType = [self getLastUsedDevice];
        [self commonInit];
        [self loadWebView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];// 不是监测UIDeviceOrientationDidChangeNotification
    }
    return self;
}

- (void)orientationDidChange:(NSNotification*)notify {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateNavigationView];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
            [weak_self.navigationController popViewControllerAnimated:YES];
//            [weak_self dismissViewControllerAnimated:YES completion:nil];
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
        make.width.mas_equalTo(kNavigationViewHeight).priorityMedium();
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
    
    [UIView animateWithDuration:0.4 animations:^{
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
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.equalTo(self.navigationView);
        make.bottom.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self getHelpRequestUrlStringWithXJDeviceType:self.deviceType]]];
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (NSString *)getHelpRequestUrlStringWithXJDeviceType:(XJDeviceType)deviceType {
    NSString *shortName = [DeviceTool shortNameWithType:deviceType];
    // VX2的开镜使用说明和摇杆死区的使用说明与VX的共享
    if (self.helpType == GSTutorialTypeVXMirror ||self.helpType == GSTutorialTypeVXRockerDeadArea) {
        shortName = [DeviceTool shortNameWithType:XJDeviceTypeVX];
    }
    NSString *urlString = [NSString stringWithFormat:@"https://helpgsw.vgabc.com/single.html?lang=%@&device=%@&platform=iosvtouch&type=%@", [[GSTool shared] getLocalLanguage], shortName.uppercaseString, @(self.helpType)];
    // G-Touch，设备帮助页链接：https://helpgsw.vgabc.com/single.html?lang=zh&device=G6&platform=iosvtouch&type=1
    if (self.helpType == GSTutorialTypeGetStarted) {
        urlString = [self getStartedURLWithDeviceType:deviceType];// https://helpgsw.vgabc.com/help.html?lang=zh&device=G6&platform=iosvtouch
    }
    return urlString ;
}

- (NSString *)getStartedURLWithDeviceType:(XJDeviceType)deviceType {
    NSString *shortName = [DeviceTool shortNameWithType:deviceType];
    NSString *urlString = [NSString stringWithFormat:@"https://helpgsw.vgabc.com/help.html?lang=%@&device=%@&platform=iosvtouch",[[GSTool shared] getLocalLanguage], shortName.uppercaseString];
    NSLog(@"手柄教程首页地址：%@",urlString);
    return urlString ;
}

- (void)pushToDetailViewController:(NSString *)url {
    GSSubHelpDetailViewController *vc = [[GSSubHelpDetailViewController alloc]initWithURLString:url];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", [self class]);
    self.webView.navigationDelegate = nil;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 首次打开这个页面，会多次调用此方法
    // 第一次请求：https://helpgsw.vgabc.com/single.html?lang=zh&device=VX&platform=iosvtouch&type=5
    // 第二次请求：http://doc.xiaoji.com/single.html?lang=zh&device=VX&platform=iosvtouch&type=5
    // 第三次请求：http://doc.xiaoji.com/detail/114.html
    
    NSString *URLString = navigationAction.request.URL.absoluteString;
    NSLog(@"%@",URLString);
    if ([URLString containsString:@"http"] && ([URLString containsString:@"single.html?lang="] || [URLString containsString:@"help.html?lang="])) {// 允许主Domain的导航栏动作
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        if ([URLString hasSuffix:@".html"]) {// 其他Domain，手动Push下一页
            [self pushToDetailViewController:URLString];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);// 拿到服务器的响应之后，允许导航栏动作
}

// 监测标题（如果添加了监测，必须实现该监测方法，否则会崩溃，且无提示！）
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.titleLabel.text = self.webView.title;
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)hideShareButton {
    [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.);
    }];
}

#pragma mark - 旋转屏幕

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:UIInterfaceOrientationMaskAllButUpsideDown forKey:@"GSDeviceSupportedOrientationMask"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    // 注意：进入此页面的方式有2种，分别是：从”调整配置“页面进入 和 从”帮助详情“页返回
    // 统一处理方法：根据当前屏幕的方向即可
    
    int val = UIInterfaceOrientationPortrait;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"GSDeviceSupportedOrientationMask"] == UIInterfaceOrientationMaskAllButUpsideDown) {// 如果支持横屏
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationPortrait) {// 如果屏幕是横屏，则根据这个横屏方向显示
            val = orientation;
        }
    }
    
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

- (void)setLastUsedDevice:(XJDeviceType)type {
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

@end

