//
//  XJVerticalButton.h
//  Test
//
//  Created by gamesirDev on 15/7/2019.
//  Copyright © 2019 gamesirDev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 按钮排序：图片在上，标题在下
@interface XJVerticalButton : UIButton

@property (nonatomic, assign) CGFloat               titleImagePadding;
@property (nonatomic, assign) CGFloat               imageY;
@property (nonatomic, assign) CGFloat               titleHeight;
@property (nonatomic, assign) CGSize                imageSize;

- (instancetype)initWithImageY:(CGFloat)imageY titleImagePadding:(CGFloat)padding titleHeight:(CGFloat)titleHeight imageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
