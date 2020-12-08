//
//  GSBaseNoDataView.m
//  GameSirOTA
//
//  Created by 小肥观 on 2019/9/18.
//  Copyright © 2019 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import "GSBaseNoDataView.h"
#import "Define.h"

@interface GSBaseNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation GSBaseNoDataView

- (void)setContent:(NSString *)content{
    _content = content;
    self.titleLabel.text = content;
}

-(void)setDetailContent:(NSString *)detailContent{
    _detailContent = detailContent;
    self.detailLabel.text = detailContent;
}

-(void)setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
    [self.reloadButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imgView.image = [UIImage imageNamed:imageName];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.reloadButton.layer.cornerRadius = 4.0;
    self.reloadButton.backgroundColor = [UIColor colorWithRed:244/255.0 green:54/255.0 blue:76/255.0 alpha:1.0];//UIColorFromRGB(244,54,76)
    self.titleLabel.text = i18n(@"not search this game");
    self.detailLabel.text = i18n(@"you can add game to your list");
    [self.reloadButton setTitle:i18n(@"add game") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonAction{
    if (self.buttonActionBlock) {
        self.buttonActionBlock();
    }
}

@end
