//
//  GSCombineButton.m
//  Help
//
//  Created by gamesirDev on 14/4/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import "GSCombineButton.h"

@interface GSCombineButton ()
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIButton * deviceButton;
@end

@implementation GSCombineButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"G6";
        
        CGSize deviceButtonSize = [self getSizeWithText:self.title boldFontSize:34];
        self.deviceButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, deviceButtonSize.width+5, 40)];
        [self.deviceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.deviceButton.userInteractionEnabled = NO;
        self.deviceButton.titleLabel.font = [UIFont boldSystemFontOfSize:34];
        [self addSubview:self.deviceButton];
        
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigation_icon_disclosure"]];
        [self.imageView setFrame:CGRectMake(deviceButtonSize.width+5+10,0 , 20, 20)];
        [self addSubview:self.imageView];
        
        
        self.userInteractionEnabled = YES;
    }
    return  self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    CGSize size = [self getSizeWithText:self.title boldFontSize:34];
    CGRect newFrame = self.frame;
    newFrame.size.width = size.width+40;
    self.frame = newFrame;
    self.deviceButton.frame = CGRectMake(0, 0, size.width+5, 40);
    self.imageView.frame = CGRectMake(size.width+10, 10, 20, 20);
    [self.deviceButton setTitle:title forState:UIControlStateNormal];
    
}

- (CGSize)getSizeWithText:(NSString *)text boldFontSize:(float)fontSize{
    CGSize size = CGSizeZero;
    size = [text boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil].size;
    return size;
}

@end
