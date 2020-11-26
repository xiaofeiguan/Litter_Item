//
//  LGHTabBarOne.h
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGHTabBarOne;

/// 自定义TabBar的代理
@protocol LGHTabBarOneDelegate <NSObject>

/// 点击TabBar上的按钮，selectedIndex从0开始
- (void)tabBar:(LGHTabBarOne*)tabBar didSelectIndex:(NSInteger)selectedIndex;

@end

@interface LGHTabBarOne : UITabBar
@property (nonatomic,strong) NSMutableArray * buttons;
@property (nonatomic, weak) id<LGHTabBarOneDelegate>               delegate;

- (void)btnClicked:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
