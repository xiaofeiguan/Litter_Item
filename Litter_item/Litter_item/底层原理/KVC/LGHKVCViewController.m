//
//  UIKVOViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/16.
//

#import "LGHKVCViewController.h"
#import "LGHPerson.h"
@interface LGHKVCViewController ()
@property (nonatomic, strong) LGHPerson * person;
@end

@implementation LGHKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.person = [[LGHPerson alloc]init];
    NSLog(@"viewDidLoad:%@ - %@" , self.person.uuid,self.person.name);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self test01];
    [self test02];
}

-(void)test01{
    // 通过KVC 设置readonly属性   获取私有属性
    [self.person setValue:@"11111111" forKey:@"uuid"];
    [self.person setValue:@"liuguanhua" forKey:@"name"];
    [self.person setValue:@"ggggggggg" forKey:@"className"];
    NSLog(@"%@ - %@ -%@" , self.person.uuid,self.person.name,[self.person valueForKey:@"className"]);
}

-(void)test02{
    [self.person setValue:@"11111111" forKey:NSStringFromSelector(@selector(uuid))];
    [self.person setValue:@"liuguanhua" forKey:NSStringFromSelector(@selector(name))];
    [self.person setValue:@"ggggggggg" forKey:NSStringFromSelector(@selector(className))];
    NSLog(@"%@ - %@ -%@" , self.person.uuid,self.person.name,[self.person valueForKey:@"className"]);
}

@end
