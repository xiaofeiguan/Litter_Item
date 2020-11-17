//
//  LGHBaseTableDataSource.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/17.
//

#import "LGHBaseTableDataSource.h"
@interface LGHBaseTableDataSource ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

@property (nonatomic, copy) CellConfigureBefore cellConfigureBefore;

@property (nonatomic, copy)   selectCell selectBlock;
@end

@implementation LGHBaseTableDataSource

- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before  selectBlock:(selectCell)selectBlock{
    if(self = [super init]) {
        _cellIdentifier = identifier;
        _cellConfigureBefore = [before copy];
        _selectBlock = [selectBlock copy];
    }
    return self;
}

- (void)dataWithArray:(NSArray *)datas{
    if(!datas) return;
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    self.dataArray = [NSMutableArray arrayWithArray:datas];
    
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath{
    return (self.dataArray.count > indexPath.row) ? self.dataArray[indexPath.row] : nil;
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (!self.dataArray)?1:self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    if(self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model,indexPath);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 将点击事件通过block的方式传递出去
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}


@end
