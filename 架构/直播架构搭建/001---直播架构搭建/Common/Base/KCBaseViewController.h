//
//  KCBaseViewController.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "ViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface KCBaseViewController : ViewController

@property (nonatomic, strong) CDDContext    *rootContext;
- (void)configMVP:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
