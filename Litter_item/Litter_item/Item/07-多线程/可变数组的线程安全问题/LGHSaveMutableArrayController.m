//
//  LGHSaveMutableArrayController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/3.
//

#import "LGHSaveMutableArrayController.h"
#import "LGHSaveMutableArray.h"
@interface LGHSaveMutableArrayController ()
@property (nonatomic, strong) LGHSaveMutableArray * myArr;
@end

@implementation LGHSaveMutableArrayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myArr = [[LGHSaveMutableArray alloc]initWithCapacity:1];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 100 ; i++) {
            [self.myArr addObject:@(i)];
        }
    });
    
    // 可以完美输出结果
    // 如果myArr的类型是NSMutableArray时，运行代码报错
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSNumber *number  in self.myArr) {
            NSLog(@"%ld",number.integerValue);
        }
    });
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
