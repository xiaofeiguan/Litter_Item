//
//  LGHProxy.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




@interface LGHProxy : NSProxy
+ (instancetype)proxyWithTransformObject:(id)object;
@end

NS_ASSUME_NONNULL_END
