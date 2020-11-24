//
//  LGHBaseTableDataSource.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);
typedef void (^selectCell) (NSIndexPath *indexPath);

@interface LGHBaseTableDataSource : NSObject

// 二维数组
@property (nonatomic, strong)  NSMutableArray *dataArray;;

//自定义
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before selectBlock:(selectCell)selectBlock;

/**
 * 传入的datas需为二维数组，便于LGHBaseTableDataSource统一管理。
 * 如果服务器传来的是一维数组，需要包装成二维数组。
 */
- (void)dataWithArray:(NSArray *)datas;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
