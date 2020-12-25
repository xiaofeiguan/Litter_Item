//
//  CheckboxTableViewCell.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import "CheckboxTableViewCell.h"

@implementation CheckboxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews){
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    img.frame = CGRectMake(img.lgh_x, img.lgh_y, 16, 16);
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"adjust_checkbox_normal.png"];
                    }
                }
            }
        }
    }
}

-(void)layoutSubviews{
    NSLog(@"%@",self.subviews);
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews){
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    img.frame = CGRectMake(img.lgh_x, img.lgh_y, 16, 16);
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"adjust_checkbox_choose.png"];
                    }else{
                        img.image=[UIImage imageNamed:@"adjust_checkbox_normal.png"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}

@end
