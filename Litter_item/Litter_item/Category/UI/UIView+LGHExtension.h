//
//  UIView+LGHExtension.h
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LGHExtension)
@property (assign, nonatomic) CGFloat lgh_x;
@property (assign, nonatomic) CGFloat lgh_y;
@property (assign, nonatomic) CGFloat lgh_width;
@property (assign, nonatomic) CGFloat lgh_height;
@property (assign, nonatomic) CGFloat lgh_centerX;
@property (assign, nonatomic) CGFloat lgh_centerY;
@property (assign, nonatomic) CGSize  lgh_size;
@property (assign, nonatomic) CGPoint lgh_origin;
@property (assign, nonatomic) CGFloat lgh_top;
@property (assign, nonatomic) CGFloat lgh_bottom;
@property (assign, nonatomic) CGFloat lgh_left;
@property (assign, nonatomic) CGFloat lgh_right;

- (void)willMoveToSuperview:(UIView *)newSuperview;

@end

NS_ASSUME_NONNULL_END
