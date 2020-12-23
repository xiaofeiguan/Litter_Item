//
//  KCHomeViewController.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCHomeViewController.h"


@interface KCHomeViewController ()<KCBaseAdapterDelegate>
@property (nonatomic, strong) KCHomeAdapter     *homeAdapter;
@end

@implementation KCHomeViewController

- (void)viewDidLoad {

    [self configMVP:@"Home"];
    
    [super viewDidLoad];
    
    self.homeAdapter = [KCHomeAdapter new];
    self.homeAdapter.adapterDelegate = self;
    
    [(id<KCHomePresentDelegate>)(self.view) buildHomeView:self.homeAdapter];
    
    
    [(id<KCHomePresentDelegate>)(self.context.presenter) loadDataWithAdapter:self.homeAdapter];

}

#pragma mark - KCBaseAdapterDelegate
- (void)didSelectCellData:(id)cellData{
    
    KC(self.context.interactor, KCHomePresentDelegate, gotoLiveStream);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)dealloc{
    NSLog(@"dealloc:%@",[self class]);
}


@end
