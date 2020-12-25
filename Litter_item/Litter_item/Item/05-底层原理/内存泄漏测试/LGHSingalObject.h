//
//  LGHSingalObject.h
//  Litter_item
//
//  Created by 小肥观 on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import "LGHLeaksView01.h"
#import "LGHLeaksView02.h"
NS_ASSUME_NONNULL_BEGIN

@interface LGHSingalObject : NSObject
+ (LGHSingalObject *)shareManager;
+ (void)tearDown;
@property (nonatomic, strong) LGHLeaksView01 * view01;

@property (nonatomic, strong) LGHLeaksView01 * view02;
@end

NS_ASSUME_NONNULL_END
