//
//  LGHPerson.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/16.
//

#import "LGHPerson.h"

@interface LGHPerson()
@property (nonatomic, strong) NSString * className;
@end

@implementation LGHPerson

-(instancetype)init{
    self = [super init];
    if (self) {
        _uuid = @"gfffffffff";
        _name = @"user";
        _className = @"fffff";
        _classID = 10;
    }
    return self;
}







@end
