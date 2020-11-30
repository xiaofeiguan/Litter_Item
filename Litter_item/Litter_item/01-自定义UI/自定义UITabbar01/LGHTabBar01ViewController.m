//
//  LGHTabBarViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import "LGHTabBar01ViewController.h"

@interface LGHTabBar01ViewController ()<UINavigationControllerDelegate,UITabBarControllerDelegate>
@property(nonatomic,assign) NSInteger indexFlag;
@end

@implementation LGHTabBar01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self createControllers];
    self.indexFlag = 0;
}

- (void)createControllers {
    NSArray *classnameArray = @[@"LGHOneViewController", @"LGHTwoViewController", @"LGHThreeViewController"];
    for (NSInteger i = 0; i < classnameArray.count; i++) {
        Class class = NSClassFromString(classnameArray[i]);
        UIViewController *vc = nil;
        vc = [[class alloc]init];
        
        UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:vc];
        navigationVc.delegate = self;
        NSString *indexString = (i==0?@"one":(i==1?@"two":@"three"));
        switch (i) {
            case 0:
                navigationVc.tabBarItem.title = @"主页";
                break;
            case 1:
                navigationVc.tabBarItem.title = @"商城";
                break;
            case 2:
                navigationVc.tabBarItem.title = @"购物车";
                break;
            default:
                break;
        }
        navigationVc.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal",indexString]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navigationVc.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected",indexString]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // 添加
        [self addChildViewController:navigationVc];
    }
}

#pragma  mark  - UITabBarControllerDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    NSLog(@"title = %@",item);
    NSInteger  count = 0;
    UIView * targetView = nil;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    
        if (index != self.indexFlag) {
            for (UIControl *tabBarButton in self.tabBar.subviews) {
                if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    count += 1;
                    for (UIView *imageView in tabBarButton.subviews) {
                        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                            [arr addObject:imageView];
                            if (index == count-1) {
                                targetView = imageView;
                            }
                        }
                    }
                }
            }
            //添加动画
            // 动画1
//            [self addAnimation01WithView:targetView];
            // 动画2
//            [self addAnimation02WithView:targetView];
            // 动画3
//            [self addAnimation03WithView:targetView];
            // 动画4
//            [self addAnimation04WithView:targetView];
            // 动画5
            [self addAnimation05WithView:targetView allImageViews:[arr copy]];
            self.indexFlag = index;
        }
}

#pragma  mark - 动画的方式
-(void)addAnimation01WithView:(UIView*)imageView{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    //通过初中物理重力公式计算出的位移y值数组
    animation.values = @[@0.0, @-4.15, @-7.26, @-9.34, @-10.37, @-9.34, @-7.26, @-4.15, @0.0, @2.0, @-2.9, @-4.94, @-6.11, @-6.42, @-5.86, @-4.44, @-2.16, @0.0];
    animation.duration = 0.8;
    animation.beginTime = CACurrentMediaTime()+0.15;
    [imageView.layer addAnimation:animation forKey:nil];
}

-(void)addAnimation02WithView:(UIView*)imageView{
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
    [[imageView layer] addAnimation:animation forKey:nil];
}

-(void)addAnimation03WithView:(UIView*)imageView{
    //z轴旋转180度
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:M_PI];     //结束伸缩倍数
    [[imageView layer] addAnimation:animation forKey:nil];
}

-(void)addAnimation04WithView:(UIView*)imageView{
    //向上移动
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:-10];     //结束伸缩倍数
    [[imageView layer] addAnimation:animation forKey:nil];
}

-(void)addAnimation05WithView:(UIView*)imageView allImageViews:(NSArray<UIView*>*)arr{
    //放大效果
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;           //保证动画效果延续
    animation.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.25];     //结束伸缩倍数
    [[imageView layer] addAnimation:animation forKey:nil];
    //移除其他tabbar的动画
    for (UIView *subView in arr) {
        if (subView != imageView) {
            [subView.layer removeAllAnimations];
        }
    }
}

@end
