//
//  LGHButtonClickProblemController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/26.
//

#import "LGHButtonClickProblemController.h"

@interface LGHButtonClickProblemController ()

@property (nonatomic, strong) UIButton * button;

@end

@implementation LGHButtonClickProblemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 用到了UIControl+LGHCategory.m 分类里面的实现
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)buttonClick:(UIButton*)button{
    NSLog(@"button click");
}


@end
