//
//  LGHWrittenExaminationViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/2.
//

#import "LGHWrittenExaminationViewController.h"
#import "LGHSaveMutableArray.h"
@interface LGHWrittenExaminationViewController ()



@end

@implementation LGHWrittenExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test01];
    
    
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
 * 可能输出的结果是？
 */
-(void)test02{
    
}

/*
 * 冒泡排序
 */







@end
