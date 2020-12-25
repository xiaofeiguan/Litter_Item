//
//  KCBaseViewController.h
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import "LGHBaseViewController.h"
#import "CDDContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface KCBaseViewController : LGHBaseViewController

@property (nonatomic, strong) CDDContext    *rootContext;

-(void)configMVPWithView:(UIView *)view Presentor:(CDDPresenter*)presenter Interactor:(CDDInteractor*)interactor;
@end

NS_ASSUME_NONNULL_END
