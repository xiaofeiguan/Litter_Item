//
//  LGHLeftSlipViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/13.
//

#import "LGHLeftSlipViewController.h"

@interface LGHLeftSlipViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * datas;

@property (nonatomic, strong) UITableView * tableView;
@end

@implementation LGHLeftSlipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createEditingButtonsBelowiOS11:) name:@"GSCreateCellEditButtonsBelowiOS11Notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createEditingButtonsAboveiOS11:) name:@"GSCreateCellEditButtonsAboveiOS11Notification" object:nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.datas = @[@"xiaoliu",@"xiaohua",@"xiaowei",@"xiaojun"];
    
    

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


NSIndexPath *kEditingIndexPath = nil;
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"开始编辑");
    kEditingIndexPath = indexPath;
    

    if (@available(iOS 11.0, *)) {
        UIView *targetView = nil;// 3个功能按钮的superview。
        CGFloat targetWidth = 148.f;// 由于此时targetView的宽度是0，统一指定为148
        
        /**
         问题：cellA正处于编辑状态，如果往左滑动cellB，cellB进入编辑状态，而cellB的3个编辑按钮没有显示。
         
         分析布局：
         UITableView
            _UITableViewCellSwipeContainerView
                UISwipeActionPullView // cellB的
                    UISwipeActionStandardButton
                    UISwipeActionStandardButton
            _UITableViewCellSwipeContainerView
                UISwipeActionPullView // cellA的
                    UIButton
                    UIButton
                    UIButton
                    UIButton
                    UIButton
                    UIButton
         
         原因：3个按钮加到cellA的UISwipeActionPullView上了，应当加到cellB。
         
         解决：
         思路一：像iOS 10-系统一样，当“_UITableViewCellSwipeContainerView”调用willMoveToSuperview:再发通知获取targetView（遇到问题：iOS 14系统条件下，不会调用UIView的willMoveToSuperview:方法，原因未知。）
         思路二：通过判断，在cellB的UISwipeActionPullView添加按钮。可行✅
         */
        for (UIView *view in tableView.subviews) {
            // 不同系统的TableView布局不一样
            if (@available(iOS 13.0, *)) {// iOS 13+
                if ([view isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]) {
                    for (UIView *subview in view.subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
                            
                            BOOL isNewTargetView = NO;
                            for (UIView *subSubview in subview.subviews) {
                                if ([subSubview isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                                    [subSubview removeFromSuperview];// 删除该按钮，才不会影响新增按钮的点击事件
                                    // 判断依据：新建的UISwipeActionPullView会有UISwipeActionStandardButton
                                    isNewTargetView = YES;
                                }
                            }
                            
                            // TODO:处理targetView为nil的情况
                            if (isNewTargetView) {
                                targetView = subview;
                            }
                        }
                    }
                }
            }else {
                if ([view isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
                    BOOL isNewTargetView = NO;
                    for (UIView *subSubview in view.subviews) {
                        if ([subSubview isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                            [subSubview removeFromSuperview];
                            isNewTargetView = YES;
                        }
                    }
                    
                    // TODO:处理targetView为nil的情况
                    if (isNewTargetView) {
                        targetView = view;
                    }
                }
            }
        }
     
        [self createEditingButtonsOnTargetView:targetView targetWidth:targetWidth indexPath:indexPath];
        
    }else { // iOS 10及以下，由于此时targetView还没有创建，因此特殊处理，请看方法createEditingButtonsBelowiOS11:
        /**
         问题：此时拿不到targetView，布局如下:
         UITableViewWrapperView
            UITableViewCell
                UITableViewCellContentView
         
         而最终的布局是：
         UITableViewWrapperView
            UITableViewCell1
            UITableViewCell2
                UITableViewCellContentView
                UITableViewCellDeleteConfirmationView（目标View，此时还未创建！！！）
                    _UITableViewCellActionButton1
                    _UITableViewCellActionButton2
         解决思路：等UITableViewCellDeleteConfirmationView创建好再创建按钮
         */
    }
}




// 编辑Cell - iOS 11及以上的系统，取代 editActionsForRowAtIndexPath:
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)) {
    UISwipeActionsConfiguration *config = nil;
    UIContextualAction *action1 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
    }];
    
    UIContextualAction *action2 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
    }];
    
    config = [UISwipeActionsConfiguration configurationWithActions:@[action1,action2]];
    
    return config;
}

- (void)createEditingButtonsOnTargetView:(UIView *)targetView targetWidth:(CGFloat)targetWidth indexPath:(NSIndexPath *)indexPath {
    if (!targetView || !indexPath || targetWidth <= 0.) {
        return;
    }
    
    // 创建3个按钮：分享、重命名、删除
    NSArray *colors = @[UIColorFromRGB(100, 100, 100), UIColorFromRGB(152, 149, 149), UIColorFromRGB(34, 27, 24)];
    NSArray *imageNames = @[@"conf_share", @"edit", @"conf_delete2"];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        [UIButton LGH_make:^(LGHButtonMaker *make) {
            make.addTo(targetView)
            .frame(CGRectMake((148/3.*i) + (targetWidth-148), 0, targetWidth/3., targetView.lgh_height))
            .backgroundColor(colors[i])
            .titleFont([UIFont systemFontOfSize:14])
            .image([UIImage imageNamed:imageNames[i]], UIControlStateNormal)
            .action(^(UIButton *button) {
                if (i == 0) {
                    
                }else if (i == 1) {
                    
                }else if (i == 2) {
                    
                }
            });
        }];
    }
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // title文字的多少决定 UITableViewCellDeleteConfirmationView 的宽度大小，当前宽度是151
    
    if (@available(iOS 11.0,*)) {
        return nil;
    }else{
        // iOS8.0-iOS10.0
        UITableViewRowAction* deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        deleteAction.backgroundColor = UIColorFromRGB(152, 149, 149);
        
        UITableViewRowAction* shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        shareAction.backgroundColor = UIColor.redColor;
        
        return @[deleteAction,shareAction];
    }
}


#pragma  mark  - NSNoti

- (void)createEditingButtonsBelowiOS11:(NSNotification *)notify {
    if (@available(iOS 11.0, *)) {
        return ;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *targetView = (UIView *)notify.object;// 拿到TargetView：UITableViewCellDeleteConfirmationView
        targetView.backgroundColor = UIColor.clearColor;
        CGFloat targetWidth = 151;// 26个空格的宽度，关于宽度的说明在 tableView:editActionsForRowAtIndexPath:
        
        for (UIView *subview in targetView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UITableViewCellActionButton")]) {
                [subview removeFromSuperview];// 删除该按钮，才不会影响新增按钮的点击事件
            }
        }
        
        [self createEditingButtonsOnTargetView:targetView targetWidth:targetWidth indexPath:kEditingIndexPath];
    });
}


- (void)createEditingButtonsAboveiOS11:(NSNotification *)notify {
    if (@available(iOS 11.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *targetView = (UIView *)notify.object;// 拿到TargetView：UISwipeActionPullView
            CGFloat targetWidth = 148;
            
            for (UIView *subSubview in targetView.subviews) {
                if ([subSubview isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                    [subSubview removeFromSuperview];// 删除该按钮，才不会影响新增按钮的点击事件
                }
            }
            
            [self createEditingButtonsOnTargetView:targetView targetWidth:targetWidth indexPath:kEditingIndexPath];
        });
    }
}

@end
