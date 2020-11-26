//
//  LGHPerson.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGHPerson : NSObject
@property (nonatomic,copy,readonly) NSString * uuid;

@property (nonatomic,readonly,strong) NSString * name;

@property (nonatomic,readonly,assign) NSInteger classID;

@end

NS_ASSUME_NONNULL_END
