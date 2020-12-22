//
//  KCLiveStreamView.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamView.h"
#import "KCLiveStreamAvatarListView.h"
#import "KCLiveStreamInfoView.h"
#import "KCLiveStreamGiftView.h"
#import "KCLiveStreamTableView.h"
#import "KCLiveStreamActionView.h"
#import "KCLiveStreamGiftBanner.h"
#import "KCLiveStreamHeartView.h"
#import "KCLiveStreamGiftSelectionView.h"
#import "KCLiveStreamShareView.h"
#import "KCLiveStreamInputView.h"

#define KeyboardAnimationDuration   0.25f
#define KeyboardAnimationCurve      7


@interface KCLiveStreamView ()

@property (nonatomic, strong) KCLiveStreamAdapter                   *adapter;
@property (nonatomic, strong) KCLiveStreamAvatarListView            *avatarListView;
@property (nonatomic, strong) KCLiveStreamInfoView                  *infoView;
@property (nonatomic, strong) KCLiveStreamGiftView                  *giftView;
@property (nonatomic, strong) KCLiveStreamTableView                 *tableView;
@property (nonatomic, strong) KCLiveStreamActionView                *actionView;
@property (nonatomic, strong) KCLiveStreamHeartView                 *heartView;
@property (nonatomic, strong) KCLiveStreamGiftSelectionView         *giftSelectionView;
@property (nonatomic, strong) KCLiveStreamShareView                 *shareView;
@property (nonatomic, strong) KCLiveStreamInputView                 *inputView;
@property (nonatomic, strong) UIImageView                           *videoView;

@property (nonatomic, assign) BOOL                                  isKeyboardVisible;
@property (nonatomic, assign) int                                   kbHeight;

@end
@implementation KCLiveStreamView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.delaysTouchesBegan = false;
        singleTap.delaysTouchesEnded = false;
        singleTap.cancelsTouchesInView = false;
        [self addGestureRecognizer:singleTap];
        self.clipsToBounds = false;
    }
    return self;
}

- (void)handleSingleTap:(UIGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    CGRect contentRect = self.bounds;
    contentRect.size.height -= (41+_kbHeight);//input height
    if (CGRectContainsPoint(contentRect, point)) {
        [self tableBlankAreaTouched];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)sender
{
    bool should = true;
    CGPoint point = [sender locationInView:self];
    CGRect contentRect = self.frame;
    contentRect.size.height = self.frame.size.height;
    contentRect.size.height -= 41;//input height
    if (contentRect.origin.y + contentRect.size.height < point.y) {
        should = false;
    }
    return should;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}


- (void)buildLiveStreamViewWithAdapter:(KCLiveStreamAdapter *)adapter {
    
    self.adapter = adapter;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    int viewHeight = self.bounds.size.height;
    int viewWidth = self.bounds.size.width;
    int marginX = 0;
    int marginY = 44;
    
    self.videoView = [UIImageView new];
    _videoView.image = [UIImage imageNamed:@"avatarBig"];
    _videoView.frame = self.bounds;
    _videoView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_videoView];
    
    
    //从上至下布局
    int avatarListHeight = 40;
    self.avatarListView = [KCLiveStreamAvatarListView new];
    _avatarListView.frame = CGRectMake(marginX, marginY, SCREEN_WIDTH, avatarListHeight);
    [_avatarListView initCustomView];
    [self addSubview:_avatarListView];
    marginY += avatarListHeight;
    marginY += 5;
    
    
    int infoViewHeight = 22;
    self.infoView = [KCLiveStreamInfoView new];
    _infoView.frame = CGRectMake(marginX, marginY, SCREEN_WIDTH, infoViewHeight);
    [_infoView initCustomView];
    marginY += infoViewHeight;
    marginY += 5;
    
    
    //绝对布局
    int giftViewHeight = 120;
    self.giftView = [KCLiveStreamGiftView new];
    _giftView.frame = CGRectMake(marginX, marginY-20, SCREEN_WIDTH, giftViewHeight);
    [_giftView initCustomView];
    [self addSubview:_giftView];
    marginY += giftViewHeight;
    marginY += 5;
    
    //heart view
    self.heartView = [KCLiveStreamHeartView new];
    _heartView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    [self addSubview:_heartView];

    //input view
    _inputView = [KCLiveStreamInputView new];
    _inputView.frame = CGRectMake(0, SCREEN_HEIGHT-41-3-34, SCREEN_WIDTH, 41);
    [self addSubview:_inputView];
    [_inputView buildInputView];
    _inputView.hidden = true;
    
    //从下至上布局
    int actionViewHeight = 41+34;
    self.actionView = [KCLiveStreamActionView new];
    _actionView.frame = CGRectMake(marginX, viewHeight-actionViewHeight, SCREEN_WIDTH, actionViewHeight);
    [_actionView initCustomView];
    [self addSubview:_actionView];
    
    // 用户交流tableView
    int messageViewHeight = 134;
    self.tableView = [KCLiveStreamTableView new];
    _tableView.frame = CGRectMake(marginX, viewHeight-actionViewHeight-messageViewHeight, SCREEN_WIDTH, messageViewHeight);
    [_tableView initCustomView];
    _tableView.delaysContentTouches = false;
    _tableView.delegate = adapter;
    _tableView.dataSource = adapter;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    //gift selection view
    _giftSelectionView = [KCLiveStreamGiftSelectionView new];
    _giftSelectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_giftSelectionView initCustomView];
    [self addSubview:_giftSelectionView];
    
    //share view
    _shareView = [KCLiveStreamShareView new];
    _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_shareView initCustomView];
    [self addSubview:_shareView];
}

- (void)fireHeartWithColorId:(NSNumber *)colorId
{
    [_heartView fireHeart:colorId];
}

- (KCLiveStreamGiftBanner *)getTopBanner
{
    return [_giftView getTopBanner];
}
- (KCLiveStreamGiftBanner *)getBottomBanner
{
    return [_giftView getBottomBanner];
}

- (BOOL)hasFreeSpaceToPlayNormalGift
{
    return [_giftView hasFreeSpace];
}

- (void)playGiftAnimation:(GiftChannelMessage*)giftMsg {
    
    AssertMainThread
    
    [_giftView showGeneralGiftAnimation:giftMsg];
}


- (void)showGiftSelectionView:(BOOL)show
{
    [_giftSelectionView showGiftSelectionView:show];
}

- (void)showShareView:(BOOL)show
{
    [_shareView showGiftShareView:show];
}

- (void)showInputView:(BOOL)show
{
    _actionView.hidden = YES;
    _inputView.hidden = NO;
    _inputView.userInteractionEnabled = YES;
    [_inputView activateTextInputView];
}

- (void)layoutStreamView
{
    int keyboardDisplayHeight = _isKeyboardVisible ? _kbHeight : 0;
    
    CGRect floatFrame = _inputView.frame;
    floatFrame.origin.y = SCREEN_HEIGHT-keyboardDisplayHeight-_inputView.frame.size.height;
    _inputView.frame = floatFrame;
}

- (void)adjustTalkViewOnKeyboardShow:(NSNotification*)notification
{
    BOOL isTriggeredByTalkInput = [_inputView isInputViewTriggeringKeyboard];
    if (!isTriggeredByTalkInput && !_isKeyboardVisible) {
        return;
    }
    
    NSDictionary *info = [notification userInfo];
    NSValue *keyBounds = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect bndKey;
    [keyBounds getValue:&bndKey];
    _kbHeight = bndKey.size.height;
    
    [self showStreamViewKeyboard];
    
}

- (void)adjustTalkViewOnKeyboardHide:(NSNotification*)notification
{
    if (![_inputView isDynamicResign] && _inputView.hidden)
        return;
    
    [self hideStreamViewKeyboard];
}

- (void)showStreamViewKeyboard
{
    _isKeyboardVisible = true;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    double duration = KeyboardAnimationDuration;
    int curve = KeyboardAnimationCurve;
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    [self layoutStreamView];
    [UIView commitAnimations];
}

- (void)hideStreamViewKeyboard
{
    _isKeyboardVisible = false;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    double duration = KeyboardAnimationDuration;
    int curve = KeyboardAnimationCurve;
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    [self layoutStreamView];
    [UIView commitAnimations];
    
    [self switchToActionViewMode];
}

- (void)switchToActionViewMode
{
    _actionView.hidden = NO;
    _inputView.hidden = YES;
    _inputView.userInteractionEnabled = NO;
}

- (void)tableBlankAreaTouched
{
    if (!self.window) {
        return;
    }
    if (_isKeyboardVisible) {
        [_inputView resignTextInputView];
    }
}

@end
