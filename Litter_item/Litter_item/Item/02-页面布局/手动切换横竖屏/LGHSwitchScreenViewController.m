//
//  LGHSwitchScreenViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/25.
//

#import "LGHSwitchScreenViewController.h"
#import <WebKit/WebKit.h>
@interface LGHSwitchScreenViewController ()

@property (nonatomic, strong) WKWebView * mainWebView;

@end

@implementation LGHSwitchScreenViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.
    
    self.mainWebView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainWebView];
    
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"Https://www.baidu.com"]]];
    
}



@end
