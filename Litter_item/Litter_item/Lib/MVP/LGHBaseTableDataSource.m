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
    NSArray *rowArray = self.dataArray[indexPath.section];
    return (rowArray.count > indexPath.row) ? rowArray[indexPath.row] : nil;
}


#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (!self.dataArray)?0:self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rowArray = self.dataArray[section];
    return (!rowArray)?0:rowArray.count;
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

@end
