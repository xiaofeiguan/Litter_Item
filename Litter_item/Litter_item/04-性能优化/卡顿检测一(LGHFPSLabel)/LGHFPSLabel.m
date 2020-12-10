//
//  LGHFPSLabel.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/1.
//

#import "LGHFPSLabel.h"
#import "LGHProxy.h"
#define LGHFPSLabelSize  CGSizeMake(80,25)

@interface LGHFPSLabel ()
{
    NSUInteger _count;
}
@property (nonatomic, strong) CADisplayLink * displayLink;

@property (nonatomic, assign) NSTimeInterval lastTime;
@end

@implementation LGHFPSLabel

-(instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = LGHFPSLabelSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    self.font = [UIFont systemFontOfSize:14.0];
    self.textColor = [UIColor lightGrayColor];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:[LGHProxy proxyWithTransformObject:self] selector:@selector(displayLinkAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    return self;
}


-(void)displayLinkAction:(CADisplayLink *)link{
    if(_lastTime == 0){
        _lastTime = link.timestamp;
        return;
    }
    _count++;
    NSTimeInterval time = link.timestamp - _lastTime;
    // delta>=1 每秒计算一次 每秒刷新的次数_count
    // 看每秒 displayLinkAction:(CADisplayLink *)link 方法执行了多少次，就说明帧刷新了多少次。
    if (time < 1) return;
    float fps = _count / time;
    NSLog(@"%ld -- %lf",_count,time);
    _count = 0;
    _lastTime = link.timestamp;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length - 3)];
    [text setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(text.length - 3, 3)];
    [text setAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(0, text.length)];
    [text setAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(0, text.length)];
    self.attributedText = text;
    
    _lastTime = link.timestamp;
}


-(void)dealloc{
    [self.displayLink invalidate];
    NSLog(@"%@",[self class]);
}

@end
