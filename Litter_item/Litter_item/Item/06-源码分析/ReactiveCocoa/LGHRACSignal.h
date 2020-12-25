//
//  LGHRACSignal.h
//  Litter_item
//
//  Created by 刘观华 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ReturnBlock)();

@interface LGHRACSignal : NSObject
@property(nonatomic,copy) ReturnBlock  returnBlock;

+(instancetype)createSingal:(ReturnBlock)block;

-(void)subscribe;

@end

NS_ASSUME_NONNULL_END
