//
//  KCLiveStreamViewController.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamViewController.h"
#import "KCLiveStreamAdapter.h"

@interface KCLiveStreamViewController ()
@property (nonatomic, strong) KCLiveStreamAdapter *adapter;

@end

@implementation KCLiveStreamViewController

- (void)viewDidLoad {
    
    [self configMVP:@"LiveStream"];
    [super viewDidLoad];

    self.adapter = [KCLiveStreamAdapter new];
    self.context.presenter.adapter = self.adapter;
    
    
    KC(self.view, KCLiveStreamPresenterDeleagte, buildLiveStreamViewWithAdapter:self.adapter);
   
    KC(self.context.presenter, KCLiveStreamPresenterDeleagte, startLikeAnimating);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
    
    [Notif removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [Notif addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [Notif removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [Notif addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [Notif removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [Notif removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
}


#pragma mark-    Keyboard Event
- (void)keyboardWillShow:(NSNotification *)notification {
    KC(self.view, KCLiveStreamPresenterDeleagte, adjustTalkViewOnKeyboardShow:notification);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    KC(self.view, KCLiveStreamPresenterDeleagte, adjustTalkViewOnKeyboardHide:notification);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
