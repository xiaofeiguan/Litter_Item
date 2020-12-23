//
//  LGHThreadViewController.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/18.
//

#import "LGHThreadViewController.h"
#import "SDWebImageManager.h"
/*
 https://tva4.sinaimg.cn//large//0072Vf1pgy1foxkd4s1rxj31hc0u0qo0.jpg
 https://tva3.sinaimg.cn//large//0072Vf1pgy1fodqnt870uj31kf14ex6p.jpg
 https://tva4.sinaimg.cn//large//0072Vf1pgy1foxkfzphb2j31hc0u0gvv.jpg
 https://tva4.sinaimg.cn//large//0072Vf1pgy1foxkinxp8pj31kw0w0nje.jpg
 */


@interface LGHThreadViewController ()
@property (nonatomic, copy) NSArray * imageUrls;

@property (nonatomic, strong) NSMutableArray * downloadImages;

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton * button;
@end

@implementation LGHThreadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LGHScreenWidth, LGHScreenWidth*(1080/1920.0)*4)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake((LGHScreenWidth-80)/2.0, (LGHScreenHeight-30)/2.0, 80, 30)];
    [self.view addSubview:self.button];
    [self.button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [self.button setTitle:@"加载图片" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.imageView];
    self.imageUrls = @[
        @"https://tva4.sinaimg.cn//large//0072Vf1pgy1foxkd4s1rxj31hc0u0qo0.jpg",
        @"https://tva3.sinaimg.cn//large//0072Vf1pgy1fodqnt870uj31kf14ex6p.jpg",
        @"https://tva4.sinaimg.cn//large//0072Vf1pgy1foxkfzphb2j31hc0u0gvv.jpg",
        @"https://tva4.sinaimg.cn//large//0072Vf1pgy1foxkinxp8pj31kw0w0nje.jpg"
    ];
    self.downloadImages = [NSMutableArray arrayWithCapacity:1];
}


-(void)makePictureToOneWithArray:(NSArray*)images{
    //合并
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(LGHScreenWidth, LGHScreenWidth*(1080/1920.0)*4), NO, 0.0);
    for (int i = 0 ; i<images.count; i++) {
        UIImage *image = images[i];
        [image drawInRect:CGRectMake(0, i*LGHScreenWidth*(1080/1920.0), LGHScreenWidth, LGHScreenWidth*(1080/1920.0))];
    }
    //给ImageView赋值
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    [self.view insertSubview:self.button atIndex:0];
}


-(void)clickButton:(UIButton *)sender{
    [self dealWithDownloadFourPictureToConbineOnePicture02];
}




/**
 *  采用调度组的方式，实现多任务下载
 */
-(void)dealWithDownloadFourPictureToConbineOnePicture01{
    
    __weak typeof(self) weakSelf = self;
    // 创建分组
    dispatch_group_t  group = dispatch_group_create();
    // 创建队列
    dispatch_queue_t  queue = dispatch_queue_create("downLoadImage", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSString *urlStr in self.imageUrls) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            NSURL *url = [NSURL URLWithString:urlStr];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (image) {
                [weakSelf.downloadImages addObject:image];
            }
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self makePictureToOneWithArray:self.downloadImages];
        });
    });
}

/*
 * 采用信号量，设置信号量单一通过。
 */
-(void)dealWithDownloadFourPictureToConbineOnePicture02{
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建信号量，并且设置值为1,单一通过
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSString *urlStr in self.imageUrls) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSURL *url = [NSURL URLWithString:urlStr];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (image) {
                [self.downloadImages addObject:image];
            }
            // 每次发送信号则semaphore会+1，
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self makePictureToOneWithArray:self.downloadImages];
        // 每次发送信号则semaphore会+1，
        dispatch_semaphore_signal(semaphore);
    });
    
}



@end
