//
//  UIControl+LGHCategory.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (LGHCategory)
/// 点击事件响应的时间间隔，不设置或者大于 0 时为默认时间间隔
@property (nonatomic, assign) NSTimeInterval clickInterval; // 默认是1.0
/// 是否忽略响应的时间间隔
@property (nonatomic, assign) BOOL isIgnoreClickInterval;  // 默认是NO

@end

NS_ASSUME_NONNULL_END
