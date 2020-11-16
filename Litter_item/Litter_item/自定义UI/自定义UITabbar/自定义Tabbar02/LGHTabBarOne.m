//
//  LGHTabBarOne.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import "LGHTabBarOne.h"
#import "XJVerticalButton.h"
#import "UIImage+GSExtension.h"
@interface LGHTabBarOne ()
@property (nonatomic, retain) NSMutableArray*               sysButtons;
@property (nonatomic,strong)  NSArray * titleArr;
@end


@implementation LGHTabBarOne

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.barTintColor = UIColor.whiteColor;// 需求
        self.sysButtons = [NSMutableArray arrayWithCapacity:0];
        self.buttons = [NSMutableArray array];

        /// 创建自定义按钮
        self.titleArr = @[@"首页",@"帮助",@"商城"];
        NSArray *imageArr = @[@"tabbar_device",@"tabbar_help",@"tabbar_shop"];
        NSArray *selectImageArr = @[@"tabbar_device_pressed",@"tabbar_help_pressed",@"tabbar_shop_pressed"];
        for (NSUInteger i = 0; i < self.titleArr.count; i ++) {
            XJVerticalButton* button = [[XJVerticalButton alloc] initWithImageY:5 titleImagePadding:2 titleHeight:10 imageSize:CGSizeMake(25, 25)];
            [self addSubview:button];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            button.tag = i+8888;
            button.titleLabel.font = [UIFont systemFontOfSize:10.0];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
            [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
            [button setImage:[[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            
            [button setTitle:@"" forState:UIControlStateSelected];
            [button setImage:[UIImage imageWithColor:UIColor.clearColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[[UIImage imageNamed:selectImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:button];

            if (i == 0) {
                button.selected = YES;
            }
        }
    }
    return self;
}

- (void)btnClicked:(UIButton *)button {
    if (button.selected) {
        return ;
    }
    
    for (NSUInteger i = 0; i < self.titleArr.count; i ++) {
        XJVerticalButton* button = [self viewWithTag:8888+i];
        if ([button isKindOfClass:[XJVerticalButton class]]) {
            button.selected = NO;
        }
    }
    button.selected = YES;
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:button.tag-8888];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /// 布局自定义按钮
    CGFloat buttonWidth = 50.;
    CGFloat buttonHeight = 51.;// UI说按钮的BackgroundImage的高度有点被压缩，因此由50改为51
    CGFloat buttonPadding = (self.lgh_width-buttonWidth*self.titleArr.count)/(self.titleArr.count+1.0);// 等距间隙
    
    for (NSUInteger i = 0; i < self.titleArr.count; i ++) {
        XJVerticalButton* button = [self viewWithTag:8888+i];
        if ([button isKindOfClass:[XJVerticalButton class]]) {
            button.frame = CGRectMake(buttonPadding*(i+1)+buttonWidth*i, 1, buttonWidth, buttonHeight);
            [self bringSubviewToFront:button];
        }
    }
    
    if (self.sysButtons.count == 0) {// 防止多次添加
        /// 拿到系统的按钮，在hitTest方法使用
        for (NSUInteger i = 0; i < self.subviews.count; i ++) {
            UIView* view = self.subviews[i];
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                // 保存系统的UITabBarButton
                [self.sysButtons addObject:view];
            }
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* target = [super hitTest:point withEvent:event];
    
    // 问题：点击2个按钮的中间，会点到「帮助」Tab的WebView，如何解决？
    // 解决方法：将return nil 改为 return [UIView new]
    if ([target isKindOfClass:NSClassFromString(@"UITabBarButton")]) {// 由于系统UITabBarButton的宽度较大（90），为防止点到它就切换NavigationViewController，所以禁止点击，把点击事件交给下边的自定义XJVerticalButton来处理
        return [UIView new];// 此处不能用return nil;
    }
    
    if ([target isKindOfClass:[XJVerticalButton class]]) {
        /// 找到匹配的系统按钮，使用其切换NavigationViewController的功能
        for (NSUInteger i = 0; i < self.sysButtons.count; i ++) {
            UIButton* sysButton = self.sysButtons[i];
            if (CGRectContainsPoint(sysButton.frame, point)) {
                XJVerticalButton* button = [self viewWithTag:8888+i];
                [self btnClicked:button];// 1.点击自定义按钮，使其更换状态为selected
                // return sysButton; 相当于点击了button，就是点击了sysButton
                return sysButton;// 2.使其点击系统按钮，达到切换NavigationViewController的目的
            }
        }
    }
    return target;
}

@end
