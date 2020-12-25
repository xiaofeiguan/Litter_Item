//
//  KCBaseViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import "KCBaseViewController.h"
#import "KCBasePresenter.h"
#import "KCBaseInteractor.h"

@interface KCBaseViewController ()
@property (nonatomic, strong) NSMutableDictionary   *eventMap;
@property (nonatomic, assign) BOOL                  mvpEnabled;
@end

@implementation KCBaseViewController

-(void)configMVPWithView:(CDDView *)view Presentor:(CDDPresenter*)presenter Interactor:(CDDInteractor*)interactor{
    
    self.mvpEnabled = true;
    
    self.rootContext = [[CDDContext alloc]init]; //strong
    
    self.context = self.rootContext; //weak
    
    if (presenter) {
        self.context.presenter = presenter;
        self.context.presenter =  presenter;
        self.context.presenter.context = self.context;
    }
    
    if (interactor) {
        self.context.interactor = interactor;
        self.context.interactor.context = self.context;
    }
    
    if (view) {
        self.context.view = view;
        self.context.view.context = self.context;
    }
    
    //build relation
    self.context.presenter.view = self.context.view;
    self.context.presenter.baseController = self;
    
    self.context.interactor.baseController = self;
    
    self.context.view.presenter = self.context.presenter;
    self.context.view.interactor = self.context.interactor;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.mvpEnabled) {
        self.context.view.frame = self.view.bounds;
        self.view = self.context.view;
    }
    KCLog(@"\n\nDid Load ViewController: %@\n\n", [self class]);
}

- (void)dealloc
{
    KCLog(@"\n\nReleasing ViewController: %@\n\n", [self class]);
    
    [Notif removeObserver:self];
}

@end
