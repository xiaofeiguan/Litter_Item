//
//  LGHARCViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/25.
//

#import "LGHARCViewController.h"
#import "LGHPerson.h"
@interface LGHARCViewController ()
@property (nonatomic, strong) NSObject * object;
@end

@implementation LGHARCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self test01];
    
}


-(void)test01{
    NSObject *obj = [[NSObject alloc]init];
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)obj)); // 1
//    obj = [obj init];
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)obj)); // 1
    
    self.object = obj;
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)obj)); // 2
    
    LGHPerson *person = [[LGHPerson alloc]init];
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)person));
    
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
