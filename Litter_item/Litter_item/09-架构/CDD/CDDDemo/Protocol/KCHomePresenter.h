//
//  KCHomePresenter.h
//  Litter_item
//
//  Created by 小肥观 on 2020/12/22.
//

#import "KCBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@class KCBaseAdapter;

@protocol KCHomePresentDelegate <NSObject>

@optional
// 通过adapter建立我们的视图 : 主要是数据与视图的绑定
- (void)buildHomeView:(KCBaseAdapter *)adapter;
// 加载数据
- (void)loadDataWithAdapter:(KCBaseAdapter *)adapter;
// UI去刷新界面了
- (void)reloadUIWithData;
// 去直播间
- (void)gotoLiveStream;
@end

@interface KCHomePresenter : CDDPresenter<KCHomePresentDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
