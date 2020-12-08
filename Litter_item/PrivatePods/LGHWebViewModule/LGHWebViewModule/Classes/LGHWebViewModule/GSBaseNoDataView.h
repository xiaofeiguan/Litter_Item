//
//  GSBaseNoDataView.h
//  GameSirOTA
//
//  Created by 小肥观 on 2019/9/18.
//  Copyright © 2019 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ButtonActionBlock)(void);
@interface GSBaseNoDataView : UIView
@property(nonatomic,copy) ButtonActionBlock buttonActionBlock;
-(void)buttonAction;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * detailContent;
@property (nonatomic,strong) NSString * buttonTitle;
@property (nonatomic,strong) NSString * imageName;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@end

NS_ASSUME_NONNULL_END
