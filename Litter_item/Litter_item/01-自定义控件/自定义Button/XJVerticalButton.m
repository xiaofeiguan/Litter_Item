//
//  XJVerticalButton.m
//  Test
//
//  Created by gamesirDev on 15/7/2019.
//  Copyright © 2019 gamesirDev. All rights reserved.
//

#import "XJVerticalButton.h"

@implementation XJVerticalButton

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.titleImagePadding = 0.;
        self.imageY = 0.;
        self.titleHeight = 11.;
        self.imageSize = CGSizeMake(12, 12);
    }
    
    return self;
}

- (instancetype)initWithImageY:(CGFloat)imageY titleImagePadding:(CGFloat)padding titleHeight:(CGFloat)titleHeight imageSize:(CGSize)imageSize {
    self = [super init];
    
    if (self) {
        self.imageView.backgroundColor = UIColor.clearColor;
        self.titleImagePadding = padding;
        self.imageY = imageY;
        self.titleHeight = titleHeight;
        self.imageSize = imageSize;
    }
    
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = contentRect.size.width;
    
    CGFloat toX = 0;
    // 根据当前图片的size来计算图片的位置
    UIImage* image = self.currentImage;
    
    // 优先使用设定的图片大小
    CGSize imageSize = self.imageSize;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        if (image) {
            imageSize = image.size;
        }
    }
    
    CGFloat toY = self.imageY+imageSize.height+self.titleImagePadding;
    CGFloat toWidth = width;
    CGFloat toHeight = self.titleHeight;
    
    return CGRectMake(toX, toY, toWidth, toHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat width = contentRect.size.width;
    
    // 根据当前图片的size来计算图片的位置
    UIImage* image = self.currentImage;
    
    // 优先使用设定的图片大小
    CGSize imageSize = self.imageSize;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        if (image) {
            imageSize = image.size;
        }
    }

    CGFloat toX = (width-imageSize.width)/2.+2.;
    CGFloat toY = self.imageY+2.;
    CGFloat toWidth = imageSize.width-4;
    CGFloat toHeight = imageSize.height-4;
    
    return CGRectMake(toX, toY, toWidth, toHeight);
}


//-(void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if (selected==YES) {
//        <#statements#>
//    }
//}

@end
