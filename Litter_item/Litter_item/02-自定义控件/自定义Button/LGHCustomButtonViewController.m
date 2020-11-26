//
//  LGHCustomButtonViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/15.
//

#import "LGHCustomButtonViewController.h"
#import "XJVerticalButton.h"
@interface LGHCustomButtonViewController ()
@property(nonatomic,strong) XJVerticalButton *button01;
@end

@implementation LGHCustomButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.button01 = [[XJVerticalButton alloc]initWithImageY:5 titleImagePadding:5 titleHeight:10 imageSize:CGSizeMake(25, 25)];
    
    self.button01.backgroundColor = [UIColor lightGrayColor];
    self.button01.frame = CGRectMake(0, 80, 40, 40);
    [self.button01 setImage:[UIImage imageNamed:@"tabbar_help"] forState:UIControlStateNormal];
    [self.button01 setTitle:@"帮助" forState:UIControlStateNormal];
    self.button01.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.view addSubview:self.button01];
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
