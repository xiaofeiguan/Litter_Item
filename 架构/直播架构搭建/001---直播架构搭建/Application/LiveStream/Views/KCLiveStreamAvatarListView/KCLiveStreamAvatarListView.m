//
//  KCLiveStreamAvatarListView.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamAvatarListView.h"

@interface KCLiveStreamAvatarListView ()

@end

@implementation KCLiveStreamAvatarListView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor randomColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initCustomView {
	
    int marginX = 5;
    for (int i = 0; i < 20; i ++) {
        
        UIImageView* imgAvatar = [UIImageView new];
        imgAvatar.backgroundColor = [UIColor clearColor];
        imgAvatar.contentMode = UIViewContentModeScaleAspectFill;
        imgAvatar.clipsToBounds =true;
        imgAvatar.image = [UIImage imageNamed:@"logic_icon"];
        imgAvatar.layer.cornerRadius = 18;
        imgAvatar.layer.masksToBounds = true;
        [self addSubview:imgAvatar];
        
        imgAvatar.frame = CGRectMake(marginX, 5, 36, 36);
        marginX += (5+36);
        
    }
    
}



@end
