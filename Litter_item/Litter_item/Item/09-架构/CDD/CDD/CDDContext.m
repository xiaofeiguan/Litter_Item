//
//  CDDContext.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import "CDDContext.h"

@implementation CDDPresenter
@end

@implementation CDDInteractor
@end

@implementation CDDView
- (void)dealloc
{
    self.context = nil;
}
@end



@implementation CDDContext

- (void)dealloc
{
    NSLog(@"context being released");
}
@end
