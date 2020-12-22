//
//  KCBasePresenter.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCBasePresenter.h"

@interface KCBasePresenter ()
@property (nonatomic, strong) NSMutableDictionary   *eventMap;
@end

@implementation KCBasePresenter
#pragma mark- DB Notification methods
- (void)observeTable:(NSString*)table event:(NSString*)event selector:(SEL)sel
{
    if (self.eventMap == nil) {
        self.eventMap = [NSMutableDictionary new];
    }
    
    NSString* eventKey = [NSString stringWithFormat:@"%@_%@", table, event];
    [_eventMap setObject:NSStringFromSelector(sel) forKey:eventKey];
    
    [Notif removeObserver:self name:table object:nil];
    [Notif addObserver:self selector:@selector(detectDBChange:) name:table object:nil];
}

- (void)unobserveTable:(NSString*)table event:(NSString*)event
{
    NSString* eventKey = [NSString stringWithFormat:@"%@_%@", table, event];
    [_eventMap removeObjectForKey:eventKey];
}

- (void)detectDBChange:(NSNotification*)notif
{
    NSDictionary* info = notif.userInfo;
    NSString* table = info[@"table"];
    NSString* event = info[@"event"];
    id data = info[@"data"];
    
    NSString* eventKey = [NSString stringWithFormat:@"%@_%@", table, event];
    NSString* selectorName = [_eventMap objectForKey:eventKey];
    if (selectorName.length > 0) {
        [self performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:data waitUntilDone:false];
    }
}

- (void)postLoading {
    if (self.view) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)hideLoading {
    if (self.view) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)postToast:(NSString *)toast
{
    if (toast.length == 0) {
        return;
    }
}

- (void)postImageToast:(NSString *)toast
{
    if (toast.length == 0) {
        return;
    }
}

- (void)dealloc
{
    [Notif removeObserver:self];
}

@end
