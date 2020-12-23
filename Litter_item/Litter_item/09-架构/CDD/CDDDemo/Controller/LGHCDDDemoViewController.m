//
//  LGHCDDDemoViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import "LGHCDDDemoViewController.h"
#import "KCHomeView.h"
#import "KCHomeAdapter.h"
#import "KCHomePresenter.h"
#import "KCHomeInteractor.h"

@interface LGHCDDDemoViewController ()<KCBaseAdapterDelegate>
@property (nonatomic, strong) KCHomeAdapter     *homeAdapter;
@end

@implementation LGHCDDDemoViewController

- (void)viewDidLoad {
    
    
    [self configMVPWithView:[KCHomeView new] Presentor:[KCHomePresenter new] Interactor:[KCHomeInteractor new]];
    
    [super viewDidLoad];
    self.title = @"LGHCDDDemo";
    
    self.homeAdapter = [KCHomeAdapter new];
    self.homeAdapter.adapterDelegate = self;
    
    [(id<KCHomePresentDelegate>)(self.view) buildHomeView:self.homeAdapter];
    
    [(id<KCHomePresentDelegate>)(self.context.presenter) loadDataWithAdapter:self.homeAdapter];
    
    
    
}

#pragma mark - KCBaseAdapterDelegate
- (void)didSelectCellData:(id)cellData{
    [(id<KCHomePresentDelegate>)(self.context.interactor) gotoLiveStream];
}

@end
