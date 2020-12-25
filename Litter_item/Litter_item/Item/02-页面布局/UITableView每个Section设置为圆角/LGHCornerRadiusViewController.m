//
//  LGHCornerRadiusViewController.m
//  Litter_item
//
//  Created by 刘观华 on 2020/11/24.
//

#import "LGHCornerRadiusViewController.h"
#import "LGHBaseTableDataSource.h"

@interface LGHCornerRadiusViewController ()
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGRect bounds;


@property (nonatomic, strong) LGHBaseTableDataSource * dataSource;
@end

@implementation LGHCornerRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [ @[
    @[@{
          @"title":@"iOS优化篇之APP启动时间优化"},
      @{
          @"title":@"深入理解 iOS 启动流程和优化技巧"
      }
    ],
    @[@{
          @"title":@"抖音品质建设 - iOS启动优化《原理篇》"},
      @{
          @"title":@"基于二进制文件重排的解决方案 APP启动速度提升超15%"
      },
      @{
          @"title":@"利用Clang插桩，获取所有符号，实现二进制重排"}
    ],
    @[@{
          @"title":@"利用Clang插桩，获取所有符号，实现二进制重排"}
    ]
    ] mutableCopy];
    
    __weak __typeof(self)weakSelf = self;
    self.dataSource = [[LGHBaseTableDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell* _Nonnull cell, NSDictionary*  _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = model[@"title"];
        // cell背景透明，否则不会出现圆角效果
        cell.backgroundColor = UIColor.clearColor;
        // 创建layer
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        // 创建path,保存绘制的路径
        CGMutablePathRef pathRef = CGPathCreateMutable();
        // cell的bounds
        strongSelf.bounds = CGRectInset(cell.contentView.bounds, 0, 0);
        // 每组第一行cell
        if (indexPath.row == 0) {
            // 起点： 左下角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(strongSelf.bounds), CGRectGetMaxY(strongSelf.bounds));
            // cell左上角 -> 顶端中点
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(strongSelf.bounds), CGRectGetMinY(strongSelf.bounds), CGRectGetMidX(strongSelf.bounds), CGRectGetMinY(strongSelf.bounds), strongSelf.cornerRadius);
            // cell右上角 -> 右端中点
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(strongSelf.bounds), CGRectGetMinY(strongSelf.bounds), CGRectGetMaxX(strongSelf.bounds), CGRectGetMidY(strongSelf.bounds), strongSelf.cornerRadius);
            // cell右下角
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(strongSelf.bounds), CGRectGetMaxY(strongSelf.bounds));
            // 绘制cell分隔线
            // addLine = YES;
        }
        
        // 每组最后一行cell
        NSArray *array = self.datas[indexPath.section];
        if (indexPath.row == array.count-1) {
            // 初始起点为cell的左上角坐标
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(strongSelf.bounds), CGRectGetMinY(strongSelf.bounds));
            // cell左下角 -> 底端中点
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(strongSelf.bounds), CGRectGetMaxY(strongSelf.bounds), CGRectGetMidX(strongSelf.bounds), CGRectGetMaxY(strongSelf.bounds), strongSelf.cornerRadius);
            // cell右下角 -> 右端中点
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(strongSelf.bounds), CGRectGetMaxY(strongSelf.bounds), CGRectGetMaxX(strongSelf.bounds), CGRectGetMidY(strongSelf.bounds), strongSelf.cornerRadius);
            // cell右上角
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(strongSelf.bounds), CGRectGetMinY(strongSelf.bounds));
        }
        // 绘制完毕，路径信息赋值给layer
        layer.path = pathRef;
        // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
        CFRelease(pathRef);
        // 按照shape layer的path填充颜色，类似于渲染render
        layer.fillColor = [UIColor redColor].CGColor;
        
        // 创建和cell尺寸相同的view
        UIView *backView = [[UIView alloc] initWithFrame:strongSelf.bounds];
        // 添加layer给backView
        [backView.layer addSublayer:layer];
        // backView的颜色
        backView.backgroundColor = [UIColor clearColor];
        // 把backView添加给cell
        cell.backgroundView = backView;
        
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        
    }];
    // 二维数组
    [self.dataSource dataWithArray:[self.datas copy]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}

@end
