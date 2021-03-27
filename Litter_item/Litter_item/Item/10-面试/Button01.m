//
//  Button01.m
//  Litter_item
//
//  Created by 刘观华 on 2021/3/23.
//

#import "Button01.h"

@implementation Button01

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s",__FUNCTION__);
}


@end
