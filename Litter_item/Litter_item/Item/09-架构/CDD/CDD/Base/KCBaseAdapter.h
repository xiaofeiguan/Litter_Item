//
//  KCBaseAdapter.h
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KCBaseAdapterDelegate <NSObject>

@optional
- (void)didSelectCellData:(id)cellData;
- (void)deleteCellData:(id)cellData;
- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol KCBaseAdapterScrollDelegate <NSObject>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView ;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView ;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

@end

@protocol KCBaseAdapterPullUpDelegate <NSObject>

- (void)beginToRefresh;

@end

@interface KCBaseAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, weak) id<KCBaseAdapterDelegate>   adapterDelegate;
@property (nonatomic, weak) id<KCBaseAdapterScrollDelegate>              adapterScrollDelegate;
@property (nonatomic, weak) id<KCBaseAdapterPullUpDelegate>              adapterPullUpDelegate;

- (float)getTableContentHeight;
- (void)refreshCellByData:(id)data tableView:(UITableView*)tableView;

- (NSArray*)getAdapterArray;
- (void)setAdapterArray:(NSArray*)arr;


@end

NS_ASSUME_NONNULL_END
