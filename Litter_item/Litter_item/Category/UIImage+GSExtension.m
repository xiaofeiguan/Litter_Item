//
//  UIImage+GSExtension.m
//  GameSirOTA
//
//  Created by gamesirDev on 3/6/2020.
//  Copyright © 2020 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import "UIImage+GSExtension.h"

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
//#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

@implementation UIImage (GSExtension)

/** 纠正图片的方向 */
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            return self;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

/** 垂直翻转 */
- (UIImage *)flipVertical
{
    return [self rotate:UIImageOrientationDownMirrored];
}

/** 水平翻转 */
- (UIImage *)flipHorizontal
{
    return [self rotate:UIImageOrientationUpMirrored];
}

/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 将图片旋转角度degrees */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:kDegreesToRadian(degrees)];
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}



+ (UIImage *)imageByName:(NSString *)imageName {
    @autoreleasepool {
        if (!imageName || [imageName isEqualToString:@""]) {
            NSLog(@"图片名为空，已替换为透明图片");
            return [UIImage imageWithColor:UIColor.clearColor];
        }
        
        UIImage* image = [UIImage imageNamed:imageName];
        return image;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    @autoreleasepool {
        if (@available(iOS 10.0,*)) {
            UIGraphicsImageRendererFormat* renderFormat = [UIGraphicsImageRendererFormat defaultFormat];
            renderFormat.prefersExtendedRange = YES;
            UIGraphicsImageRenderer* render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:renderFormat];
            return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context, [color CGColor]);
                CGContextFillRect(context, rect);
            }];
        }else {
            CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [color CGColor]);
            CGContextFillRect(context, rect);
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return theImage;
        }
    }
}

+ (UIImage *)roundImageWithColor:(UIColor *)color size:(CGSize)size {
    @autoreleasepool {
        if (@available(iOS 10.0,*)) {
            UIGraphicsImageRendererFormat* renderFormat = [UIGraphicsImageRendererFormat defaultFormat];
            renderFormat.prefersExtendedRange = YES;
            UIGraphicsImageRenderer* render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:renderFormat];
            return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
                [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.width/2.] addClip];
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context, [color CGColor]);
                CGContextFillRect(context, rect);
            }];
        }else {
            CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.width/2.] addClip];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [color CGColor]);
            CGContextFillRect(context, rect);
            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return theImage;
        }
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [UIImage imageWithColor:color size:CGSizeMake(32, 32)];// 默认大小32s
}

+ (UIImage *)imageWithRadius:(CGFloat)radius text:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroudColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    @autoreleasepool {
        if (@available(iOS 10.0,*)) {
            UIGraphicsImageRendererFormat* renderFormat = [UIGraphicsImageRendererFormat defaultFormat];
            renderFormat.prefersExtendedRange = YES;
            UIGraphicsImageRenderer* render = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(radius*2, radius*2) format:renderFormat];
            return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGSize topSize = CGSizeMake(radius*2, radius*2);
                // 底层圆
                CGRect rect = CGRectMake(0, 0, topSize.width, topSize.height);
                [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
                CGContextRef context1 = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context1, borderColor.CGColor);
                CGContextFillRect(context1, rect);
                
                // 顶层圆
                CGFloat bottomRadius = (topSize.width-borderWidth*2)/2.0;
                CGRect rect2 = CGRectMake(borderWidth, borderWidth, bottomRadius*2, bottomRadius*2);
                [[UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:rect2.size.width/2.0] addClip];
                CGContextRef context2 = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context2, backgroudColor.CGColor);
                CGContextFillRect(context2, rect2);
                // 文字显示区域
                UIFont *font = [UIFont systemFontOfSize:fontSize];
                CGRect fontRect = [text boundingRectWithSize:rect2.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
                CGRect textRect = CGRectMake(borderWidth, borderWidth+(bottomRadius*2-fontRect.size.height)/2.0, bottomRadius*2, bottomRadius*2);
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                [text drawInRect:textRect withAttributes:@{NSFontAttributeName:font,
                                                           NSParagraphStyleAttributeName:paragraphStyle,
                                                           NSForegroundColorAttributeName:textColor}
                 ];
            }];
        }else {
            CGSize topSize = CGSizeMake(radius*2, radius*2);
            // 开始画图
            UIGraphicsBeginImageContextWithOptions(topSize, NO, [UIScreen mainScreen].scale);
            // 底层圆
            CGRect rect = CGRectMake(0, 0, topSize.width, topSize.height);
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
            CGContextRef context1 = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context1, borderColor.CGColor);
            CGContextFillRect(context1, rect);
            
            // 顶层圆
            CGFloat bottomRadius = (topSize.width-borderWidth*2)/2.0;
            CGRect rect2 = CGRectMake(borderWidth, borderWidth, bottomRadius*2, bottomRadius*2);
            [[UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:rect2.size.width/2.0] addClip];
            CGContextRef context2 = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context2, backgroudColor.CGColor);
            CGContextFillRect(context2, rect2);
            // 文字显示区域
            UIFont *font = [UIFont systemFontOfSize:fontSize];
            CGRect fontRect = [text boundingRectWithSize:rect2.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            CGRect textRect = CGRectMake(borderWidth, borderWidth+(bottomRadius*2-fontRect.size.height)/2.0, bottomRadius*2, bottomRadius*2);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [text drawInRect:textRect withAttributes:@{NSFontAttributeName:font,
                                                       NSParagraphStyleAttributeName:paragraphStyle,
                                                       NSForegroundColorAttributeName:textColor}
             ];
            // 生产图片
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            // 结束画图
            UIGraphicsEndImageContext();
            
            return image;
        }
    }
}

+ (UIImage *)getImageWithMapType:(NSString *)mapType {
    NSString* imageName = [mapType stringByReplacingOccurrencesOfString:@"item_" withString:@""];
    NSArray* types = [imageName componentsSeparatedByString:@","];
    
    UIImage* image = nil;
    if (types.count == 2) {// 组合键
        image = [UIImage getCombinationImageWithMapType:mapType];
    } else {// 常规键
        image = [UIImage getNormalImageWithMapType:mapType];
    }
    if (image) {
        return image;
    }
    
    return [UIImage imageByName:@""];
}




+ (UIImage *)getNormalImageWithMapType:(NSString *)mapType {
    return [UIImage imageByName:[self getNormalImageNameWithMapType:mapType]];
}

+ (UIImage *)resizeImage:(UIImage*)img withSize:(CGSize)newSize {
    @autoreleasepool {
        if (@available(iOS 10.0,*)) {// UIGraphicsImageRenderer 的内存占用比 UIGraphicsBeginImageContextWithOptions 少75%
            UIGraphicsImageRendererFormat* renderFormat = [UIGraphicsImageRendererFormat defaultFormat];
            renderFormat.prefersExtendedRange = YES;
            UIGraphicsImageRenderer* render = [[UIGraphicsImageRenderer alloc] initWithSize:newSize format:renderFormat];
            return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                [img drawInRect:render.format.bounds];
            }];
        }else {
            UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
            [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        }
    }
}

// TODO：把Image转NSData的方法 改为 将图片保存到沙盒
+ (NSData *)compressImage:(UIImage *)image {
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        return [[NSData alloc] init];
    }
    
    NSData* imageData = nil;
    if ([image containsTransparentPixel]) {
        imageData = UIImagePNGRepresentation(image);
    }else {
        imageData = UIImageJPEGRepresentation(image, 0.1);
    }
    
    return imageData;
}

#if 0 // 暂未完成
- (NSString*)saveImageToSandbox:(UIImage*)image {
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        NSLog(@"%@不是图片", image);
        return @"";
    }
    
    NSString* filePath = [NSHomeDirectory() stringByAppendingString:[NSUUID UUID].UUIDString];
    BOOL result = [UIImageJPEGRepresentation(image, 0.1) writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"图片已保存到沙盒，路径：%@", filePath);
        return filePath;
    }else {
        return @"";
    }
}

- (UIImage*)getImageFromSandboxWithFilePath:(NSString*)filePath {
    UIImage* image = nil;
    // TODO: 改为在子线程完成
    image = [UIImage imageWithContentsOfFile:filePath];
    if (!image) {
        image = [UIImage imageByName:@""];
        NSLog(@"找不到图片：%@", filePath);
    }
    return image;
}
#endif

- (BOOL)containsTransparentPixel {
    return NO;// 遍历像素的效率很低，暂时不用这个方法
    /*
    // 分配内存
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        uint8_t* ptr = (uint8_t*)pCurPtr;
        NSLog(@"像素参数： %d %d %d %d", ptr[0], ptr[1],ptr[2],ptr[3]);
        if (ptr[3] == 0) {
            NSLog(@"图片有透明背景");
            return YES;
        }
    }
    return NO;
     */
}

+ (UIImage *)clipCircleImage:(UIImage *)image toSize:(CGSize)toSize {
    @autoreleasepool {
        if (@available(iOS 10.0,*)) {
            UIGraphicsImageRendererFormat* renderFormat = [UIGraphicsImageRendererFormat defaultFormat];
            renderFormat.prefersExtendedRange = YES;
            UIGraphicsImageRenderer* render = [[UIGraphicsImageRenderer alloc] initWithSize:toSize format:renderFormat];
            return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((image.size.width-toSize.width)/2., (image.size.height-toSize.height)/2., toSize.width, toSize.height)];
                [path addClip];
                [image drawAtPoint:CGPointMake(0, 0)];
            }];
        }else {
            UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((image.size.width-toSize.width)/2., (image.size.height-toSize.height)/2., toSize.width, toSize.height)];
            [path addClip];
            [image drawAtPoint:CGPointMake(0, 0)];
            UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        }
    }
}

/// 修改图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image {
    @autoreleasepool {
        if (@available(iOS 10.0,*)) {
            UIGraphicsImageRendererFormat* renderFormat = [UIGraphicsImageRendererFormat defaultFormat];
            renderFormat.prefersExtendedRange = YES;
            UIGraphicsImageRenderer* render = [[UIGraphicsImageRenderer alloc] initWithSize:image.size format:renderFormat];
            return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
                CGContextScaleCTM(ctx, 1, -1);
                CGContextTranslateCTM(ctx, 0, -area.size.height);
                CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
                CGContextSetAlpha(ctx, alpha);
                CGContextDrawImage(ctx, area, image.CGImage);
            }];
        }else {
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
            CGContextScaleCTM(ctx, 1, -1);
            CGContextTranslateCTM(ctx, 0, -area.size.height);
            CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
            CGContextSetAlpha(ctx, alpha);
            CGContextDrawImage(ctx, area, image.CGImage);
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        }
    }
}


+ (UIImage*)addBorder:(UIImage*)originalImage color:(UIColor*)color{
    CGSize size = originalImage.size;
    CGFloat borderWidth = size.width/10;// 根据图片大小设置边框宽度
    CGFloat padding = borderWidth/4.;

    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // 画个圆
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width/2.];
    path.lineWidth = borderWidth;
    [color setStroke];
    [path addClip];
    [path stroke];
    
    // 再画上比圆小一点的内容
    [originalImage drawInRect:CGRectMake(borderWidth/2.-padding, borderWidth/2.-padding, size.width-borderWidth+padding*2, size.height-borderWidth+padding*2)];// 由于切图的原因，边框和图片有些缝隙，再放大padding
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 图片解码
+ (UIImage *)decodeImage:(UIImage *)image {
    // 获取CGImage
    CGImageRef cgImage = image.CGImage;
    
    // alphaInfo
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }
    
    // bitmapInfo
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    
    // size
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    // context
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
    
    // draw
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // get new CGImage
    cgImage = CGBitmapContextCreateImage(context);
    
    // 写入image
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    // release
    CGContextRelease(context);
    CGImageRelease(cgImage);
    return newImage;
}

@end
