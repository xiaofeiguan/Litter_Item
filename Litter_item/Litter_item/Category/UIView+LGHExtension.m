//
//  UIView+LGHExtension.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import "UIView+LGHExtension.h"

@implementation UIView (LGHExtension)

-(void)setLgh_x:(CGFloat)lgh_x{
    CGRect frame = self.frame;
    frame.origin.x = lgh_x;
    self.frame = frame;
}

- (CGFloat)lgh_x {
    return self.frame.origin.x;
}

- (void)setLgh_y:(CGFloat)lgh_y {
    CGRect frame = self.frame;
    frame.origin.y = lgh_y;
    self.frame = frame;
}

- (CGFloat)lgh_y {
    return self.frame.origin.y;
}

- (void)setLgh_width:(CGFloat)lgh_width {
    CGRect frame = self.frame;
    frame.size.width = lgh_width;
    self.frame = frame;
}

- (CGFloat)lgh_width {
    return self.frame.size.width;
}

- (void)setLgh_height:(CGFloat)lgh_height {
    CGRect frame = self.frame;
    frame.size.height = lgh_height;
    self.frame = frame;
}

- (CGFloat)lgh_height {
    return self.frame.size.height;
}

- (void)setLgh_centerX:(CGFloat)lgh_centerX {
    CGPoint center = self.center;
    center.x = lgh_centerX;
    self.center = center;
}

- (CGFloat)lgh_centerX {
    return self.center.x;
}

- (void)setLgh_centerY:(CGFloat)lgh_centerY {
    CGPoint center = self.center;
    center.y = lgh_centerY;
    self.center = center;
}

- (CGFloat)lgh_centerY {
    return self.center.y;
}

- (void)setLgh_origin:(CGPoint)lgh_origin {
    CGRect frame = self.frame;
    frame.origin = lgh_origin;
    self.frame = frame;
}

- (CGPoint)lgh_origin {
    return  self.frame.origin;
}

- (void)setLgh_size:(CGSize)lgh_size {
    CGRect frame = self.frame;
    frame.size = lgh_size;
    self.frame = frame;
}

- (CGSize)lgh_size {
    return self.frame.size;
}


// 从父类上移除时，会调用
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        // iOS 11-系统中，当左滑cell，该View是功能按钮的superview
        if ([self isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GSCreateCellEditButtonsBelowiOS11Notification" object:self];
        }
        
        // 问题：iOS 14系统不会调用这个方法，原因未知，因此注释
//        if ([self isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"GSCreateCellEditButtonsAboveiOS11Notification" object:self];
//        }
    }
}

@end
