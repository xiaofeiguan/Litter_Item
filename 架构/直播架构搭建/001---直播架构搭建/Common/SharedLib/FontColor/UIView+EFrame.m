//
//  UIView+EFrame.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "UIView+EFrame.h"

@implementation UIView (EFrame)

- (void)setEOriginx:(CGFloat)eOriginx
{
    CGRect frame = self.frame;
    frame.origin.x = eOriginx;
    self.frame = frame;
}

- (CGFloat)eOriginx
{
    return self.frame.origin.x;
}

- (void)setEOriginy:(CGFloat)eOriginy
{
    CGRect frame = self.frame;
    frame.origin.y = eOriginy;
    self.frame = frame;
}

- (CGFloat)eOriginy
{
    return self.frame.origin.y;
}

- (void)setEWidth:(CGFloat)eWidth
{
    CGRect frame = self.frame;
    frame.size.width = eWidth;
    self.frame = frame;
}

- (CGFloat)eWidth
{
    return self.frame.size.width;
}

- (void)setEHeight:(CGFloat)eHeight
{
    CGRect frame = self.frame;
    frame.size.height = eHeight;
    self.frame = frame;
}

- (CGFloat)eHeight
{
    return self.frame.size.height;
}

- (void)setECenterx:(CGFloat)eCenterx
{
    CGPoint center = self.center;
    center.x = eCenterx;
    self.center = center;
}

- (CGFloat)eCenterx
{
    return self.center.x;
}

- (void)setECentery:(CGFloat)eCentery
{
    CGPoint center = self.center;
    center.y = eCentery;
    self.center = center;
}

- (CGFloat)eCentery
{
    return self.center.y;
}

@end
