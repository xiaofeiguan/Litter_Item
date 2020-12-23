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
    
    KCHomeView *homeView = [[KCHomeView alloc]init];
    
    [self configMVPWithView:homeView Presentor:[KCHomePresenter new] Interactor:[KCHomeInteractor new]];
    
    [super viewDidLoad];
    self.title = @"LGHCDDDemo";
    
    self.homeAdapter = [KCHomeAdapter new];
    self.homeAdapter.adapterDelegate = self;
    
    self.view = homeView;
    
    [(id<KCHomePresentDelegate>)homeView buildHomeView:self.homeAdapter];
    
    [(id<KCHomePresentDelegate>)(self.context.presenter) loadDataWithAdapter:self.homeAdapter];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"");
}

#pragma mark - KCBaseAdapterDelegate
- (void)didSelectCellData:(id)cellData{
    [(id<KCHomePresentDelegate>)(self.context.interactor) gotoLiveStream];
}

@end
