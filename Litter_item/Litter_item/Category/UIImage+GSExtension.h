//
//  UIImage+GSExtension.h
//  GameSirOTA
//
//  Created by gamesirDev on 3/6/2020.
//  Copyright © 2020 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GSExtension)

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


#pragma mark - 映射按键图片相关

/// 获取映射按键的图片，mapType: item_l1
+ (UIImage *)getImageWithMapType:(NSString*)mapType;
/// 获取组合键的图片，mapType: item_l1,item_l2
+ (UIImage*)getCombinationImageWithMapType:(NSString*)mapType;
/// 获取常规按键图片的名称，mapType: item_l1
+ (NSString*)getNormalImageNameWithMapType:(NSString*)mapType;
/// 获取常规按键图片，mapType: item_l1
+ (UIImage*)getNormalImageWithMapType:(NSString *)mapType;
/// 获取字母图片的名称，mapType: item_l1
+ (NSString*)getLetterImageNameWithMapType:(NSString*)mapType;
/// 获取字母图片，mapType: item_l1
+ (UIImage*)getLetterImageWithMapType:(NSString*)mapType;

#pragma mark - 各种各样的图片

/// 根据名称获取图片
+ (UIImage *)imageByName:(NSString *)imageName;

/// 指定大小的圆形图片
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size;

/// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 圆形图片
+ (UIImage *)roundImageWithColor:(UIColor *)color size:(CGSize)size;

/// 带文字的圆形图片
+ (UIImage *)imageWithRadius:(CGFloat)radius
                        text:(NSString *)text
                    fontSize:(CGFloat)fontSize
                   textColor:(UIColor *)textColor
             backgroundColor:(UIColor *)backgroudColor
                 borderColor:(UIColor *)borderColor
                 borderWidth:(CGFloat)borderWidth;

/// 裁剪图片，newSize：指定大小
+ (UIImage *)resizeImage:(UIImage*)img withSize:(CGSize)newSize;

/// 压缩图片
+ (NSData*)compressImage:(UIImage*)image;

/// 修改图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

/// 裁剪图片，测试用！！！
+ (UIImage *)clipCircleImage:(UIImage *)image toSize:(CGSize)toSize;

/// 添加边框
+ (UIImage*)addBorder:(UIImage*)originalImage color:(UIColor*)color;

/// 图片解码
+ (UIImage *)decodeImage:(UIImage *)image;

@end


NS_ASSUME_NONNULL_END
