//
//  LGHTimerBroker.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGHTimerBroker : NSObject

-(instancetype)lgh_initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)aSelector userInfo:(nullable id)userInfo  repeats:(BOOL)isRepeats;

@end

NS_ASSUME_NONNULL_END
