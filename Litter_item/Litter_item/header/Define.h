//
//  Header.h
//  Litter_item
//
//  Created by 刘观华 on 2020/11/15.
//


#ifndef Define_h
#define Define_h
//keyWindow
#define WINDOWS                     [UIApplication sharedApplication].keyWindow

/// 横屏时的高度
#define LGHSCREEN_HEIGHT_LANDSCAPE         MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
/// 横屏时的宽度
#define LGHSCREEN_WIDTH_LANDSCAPE          MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
/// 竖屏时的宽度
#define LGHScreenWidth  [UIScreen mainScreen].bounds.size.width
/// 竖屏时的高度
#define LGHScreenHeight [UIScreen mainScreen].bounds.size.height
/// iPhone X系列
#define LGHIsPhoneXSeries [LGHTools isPhoneXSeries];
/// 导航栏高度
#define LGHNaviTopHeight (LGHPhoneXSeries ? 88 : 64)
/// tabbar高度
#define LGHTabBarBottomHeight (LGHPhoneXSeries ? (49 + 34) : 49)

#define LGHMainScreenScale [UIScreen mainScreen].scale

#endif /* Header_h */
