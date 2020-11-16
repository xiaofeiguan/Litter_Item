//
//  UICheckboxViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/14.
//

#import "LGHCheckboxViewController.h"
#import "CheckboxTableViewCell.h"
@interface LGHCheckboxViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * datas;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation LGHCheckboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[@"xiaoliu",@"xiaohua",@"xiaowei",@"xiaojun"];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckboxTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckboxTableViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self initEditButton];
}

-(void)initEditButton{
    // 右侧编辑按钮
   UIButton *editButton = [UIButton LGH_make:^(LGHButtonMaker *make) {
        make.title(@"Edit", UIControlStateNormal)
        .title(@"Cancel", UIControlStateSelected)
        .titleColor([UIColor redColor], UIControlStateNormal)
        .titleColor([UIColor lightGrayColor], UIControlStateSelected)
        .titleFont([UIFont systemFontOfSize:15.]);
    }];
    [editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(0, 0, 50, 35);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
}

#pragma  mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckboxTableViewCell"];
    cell.nameLabel.text = self.datas[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        
    }
    
    
}




-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma  mark - action

-(void)editButton:(UIButton*)button{
    button.selected = !button.isSelected;
    if (button.isSelected) {
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
    }else{
        [self.tableView setEditing:NO animated:YES];
        [self.tableView reloadData];
    }
}

@end
