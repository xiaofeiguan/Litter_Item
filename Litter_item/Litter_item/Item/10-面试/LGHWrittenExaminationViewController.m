//
//  LGHWrittenExaminationViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/2.
//

#import "LGHWrittenExaminationViewController.h"
#import "LGHSaveMutableArray.h"
#import "View01.h"
#import "Button01.h"


@interface LGHWrittenExaminationViewController ()



@end

@implementation LGHWrittenExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test01];
    
//    [self test03];
    [self test04];
}

/*
 * 输出的结果是？
 * 解析见：test01.png
 */
-(void)test01{
    int a [3] = {1,2,3};
    int *ptr = (int*) (&a + 1);
    printf ("%d,%d",*(a + 1) ,*(ptr - 1));
}


/*
 * frame与bounds的区别
 * frame是该view在父view坐标系中的大小和位置
 * bounds是该view在本地坐标系中的大小和位置
 */

-(void)test03{
    UIView *view01 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:view01];
    view01.backgroundColor = [UIColor redColor];
    
    NSLog(@"%@ - %@",NSStringFromCGRect(view01.frame),NSStringFromCGRect(view01.bounds));
    
    view01.transform = CGAffineTransformMakeRotation(M_PI_4);
    NSLog(@"%@ - %@",NSStringFromCGRect(view01.frame),NSStringFromCGRect(view01.bounds));
}


/*
 * 关于事件的响应链
 *
 */

-(void)test04{
    View01 *view01 = [[View01 alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    [self.view addSubview:view01];
    view01.backgroundColor = UIColor.redColor;
    
    UIButton *button01 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [view01 addSubview:button01];
    button01.backgroundColor = UIColor.greenColor;
    [button01 addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
}

-(void)action{
    NSLog(@"%s" , __FUNCTION__);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__FUNCTION__);
}




@end
