//
//  CDDContext.h
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import "NSObject+CDD.h"
NS_ASSUME_NONNULL_BEGIN

@class CDDView;

@interface CDDPresenter : NSObject
@property (nonatomic, weak) UIViewController*           baseController;
@property (nonatomic, weak) CDDView *                    view;
@property (nonatomic, weak) id                          adapter; //for tableview adapter

@end

@interface CDDInteractor : NSObject
@property (nonatomic, weak) UIViewController*           baseController;
@end


@interface CDDView : UIView
@property (nonatomic, weak) CDDPresenter*               presenter;
@property (nonatomic, weak) CDDInteractor*              interactor;
@end



//Context bridges everything automatically, no need to pass it around manually
@interface CDDContext : NSObject

@property (nonatomic, strong) CDDPresenter*           presenter;
@property (nonatomic, strong) CDDInteractor*          interactor;
@property (nonatomic, strong) CDDView*                view; //view holds strong reference back to context

@end

NS_ASSUME_NONNULL_END
