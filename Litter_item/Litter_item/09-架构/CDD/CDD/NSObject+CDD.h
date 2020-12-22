//
//  NSObject+CDD.h
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CDDContext;

@interface NSObject (CDD)
@property (nonatomic, strong) CDDContext* context;

+ (void)swizzleInstanceSelector:(SEL)oldSel withSelector:(SEL)newSel;
@end

NS_ASSUME_NONNULL_END
