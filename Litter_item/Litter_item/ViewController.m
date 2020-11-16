//
//  ViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/13.
//

#import "ViewController.h"



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * datas;

@property (nonatomic, strong) NSMutableArray * itemDatas;

@property (nonatomic, strong) UITableView * leftTableView;

@property (nonatomic, strong) UITableView * rightTableView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    self.title = @"我的";
    // @"左滑样式",@"自定义Tabbar",@"自定义UITableView编辑状态下的checkbox",@"APP首页的卡顿优化(小鸡游戏世界为例)",@"WKWebView+UITableView布局"
    NSString *path = [[NSBundle mainBundle]pathForResource:@"item" ofType:@"plist"];
    self.datas = [NSArray arrayWithContentsOfFile:path];
    CGRect ff = (CGRect)self.view.frame;
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ff.size.width/3.0, ff.size.height)];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftTableView"];
    [self.view addSubview:self.leftTableView];
    self.leftTableView.tableFooterView = [UIView new];
    
    self.rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(ff.size.width/3.0, 0, 2*ff.size.width/3.0, ff.size.height)];
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rightTableView"];
    [self.view addSubview:self.rightTableView];
    self.rightTableView.tableFooterView = [UIView new];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.datas.count;
    }
    return self.itemDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftTableView"];
        NSDictionary *data = self.datas[indexPath.row];
        cell.textLabel.text = data[@"title"];
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightTableView"];
    NSDictionary *itemData = self.itemDatas[indexPath.row];
    cell.textLabel.text = itemData[@"title"];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.leftTableView == tableView) {
        return  80;
    }
    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        NSDictionary *data = self.datas[indexPath.row];
        self.itemDatas = [NSMutableArray arrayWithArray:data[@"list"]];
        [self.rightTableView reloadData];
    }else{
        // self.rightTableView
        NSDictionary *itemData = self.itemDatas[indexPath.row];
        Class cls = NSClassFromString(itemData[@"class"]);
        UIViewController *vc = (UIViewController*)[cls new];
        BOOL isPush = ((NSNumber*)itemData[@"isPush"]).boolValue;
        if (isPush) {
            [self.navigationController pushViewController:vc animated:YES];
            NSString *title = itemData[@"title"];
            NSArray *titles =  [title componentsSeparatedByString:@"("];
            vc.title = titles.firstObject;
        }else{
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            
        }
    }
}


@end
