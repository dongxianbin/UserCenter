//
//  SuspendedButton.m
//  xuanfutiao
//
//  Created by Mac on 14/12/24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SuspendedButton.h"
#import <QuartzCore/QuartzCore.h> 

#define kDuration 0.7   // 动画持续时间(秒)

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface SuspendedButton ()<CAAnimationDelegate>
{
    BOOL _isShowingButtonList;
    BOOL _isOnLeft;
    CGPoint _tempCenter;
    CGPoint _originalPosition;
    CGRect _windowSize;
    UIView *_buttonListView;
    UIView *_baseView;
    UIImageView *imageView;
    UIImageView *buttonimageView;
    CGPoint _newPosition;
   
}
@property (nonatomic,retain) UIView *buttonListView;
@property (nonatomic,retain) UIView *baseView;

@end

@implementation SuspendedButton

@synthesize buttonListView = _buttonListView;
@synthesize baseView = _baseView;
static SuspendedButton *_instance = nil;
#pragma mark - 继承方法 
- (id)init{
    if (self = [super init]) {
       
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _isShowingButtonList = NO;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchBegan");
    _originalPosition = [[touches anyObject]

    locationInView:self];
    _tempCenter = self.center;
    self.backgroundColor = [UIColor blueColor];
    CGAffineTransform toBig = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.1 animations:^{
        // Translate bigger
        self.transform = toBig;
    } completion:^(BOOL finished) {}];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchMove");
    CGPoint currentPosition = [[touches anyObject] locationInView:self];
    float detaX = currentPosition.x - _originalPosition.x;
    float detaY = currentPosition.y - _originalPosition.y;
    CGPoint targetPositionSelf = self.center;
    CGPoint targetPositionButtonList = _buttonListView.center;
    targetPositionSelf.x += detaX;
    targetPositionSelf.y += detaY;
    targetPositionButtonList.x += detaX;
    targetPositionButtonList.y += detaY;
    self.center = targetPositionSelf;
    _buttonListView.center = targetPositionButtonList;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchCancell");
    // 触发touchBegan后，tap手势被识别后会将touchMove和touchEnd的事件截取掉触发自身手势回调，然后运行touchCancell。touchBegan中设置的按钮状态在touchEnd和按钮触发方法两者中分别设置还原。
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchEnd");
    CGAffineTransform toNormal = CGAffineTransformTranslate(CGAffineTransformIdentity, 1/1.2, 1/1.2);
    CGPoint newPosition = [self correctPosition:self.frame.origin]; [UIView animateWithDuration:0.1 animations:^{
        // Translate normal
        self.transform = toNormal;
        self.backgroundColor = [UIColor greenColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(newPosition.x, newPosition.y, self.bounds.size.width, self.bounds.size.height);
            [self adjustButtonListView];
        }];
    }];
}
#pragma mark - 显示悬浮标
+ (SuspendedButton *)suspendedButtonWithCGPoint:(NdToolBarPlace)place inView:(UIView *)baseview
{
    if (!_instance) {
        _instance = [[self alloc]init];
        
        CGPoint point;
        switch (place) {
            case NdToolBarAtTopLeft:
                point = CGPointMake(0, 0);
                break;
            case NdToolBarAtTopRight:
                point = CGPointMake((kScreenWidth - 50), 0);
                break;
            case NdToolBarAtMiddleLeft:
                point = CGPointMake(0, (kScreenHeight - 50)/2);
                break;
            case NdToolBarAtMiddleRight:
                point = CGPointMake((kScreenWidth - 50), (kScreenHeight - 50)/2);
                break;
            case NdToolBarAtBottomLeft:
                point = CGPointMake(0, (kScreenHeight - 50));
                break;
            case NdToolBarAtBottomRight:
                point = CGPointMake((kScreenWidth - 50), (kScreenHeight - 50));
                break;
            default:
                break;
        }
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[SuspendedButton alloc] initWithCGPoint:point];
            _instance.baseView = baseview;
            [_instance constructUI];
            [baseview addSubview:_instance];
        });
    }
    
    return _instance;
}
#pragma mark - 关闭悬浮标
+(void)deleteSuspendedButton
{
    [_instance close];
    
    [_instance removeFromSuperview];
}
-(void)close
{
    [_buttonListView removeFromSuperview];
}
#pragma mark - 辅助方法
- (id)initWithCGPoint:(CGPoint)pos
{
    _windowSize.size = CGSizeMake(kScreenWidth, kScreenHeight);
    //封装了获取屏幕Size的方法
    _newPosition = [self correctPosition:pos];
    return [self initWithFrame:CGRectMake(_newPosition.x, _newPosition.y, 50, 50)];
    
}



- (CGPoint)correctPosition:(CGPoint)pos
{
    CGPoint newPosition;
    if ((pos.x + 50 > _windowSize.size.width) || (pos.x > _windowSize.size.width/2-25))
    {
        newPosition.x = _windowSize.size.width - 50; _isOnLeft = NO;
    }
    else
    {
        newPosition.x = 0;
        _isOnLeft = YES;
    }
    (pos.y + 50 > _windowSize.size.height)?(newPosition.y = _windowSize.size.height - 50):((pos.y < 0)?newPosition.y = 0:(newPosition.y = pos.y));
    return newPosition;
}
- (void)constructUI
{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.6;
    self.layer.cornerRadius = 10;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiggerButtonList)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    UIImage *img = [UIImage imageNamed:Resouse(@"悬浮背景.png")];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imageView setImage:img];
    [self addSubview:imageView];
   
    NSUInteger numOfButton = 2;
    self.buttonListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, numOfButton*100, 50)];
    _buttonListView.backgroundColor = [UIColor clearColor];
    _buttonListView.alpha = 0;
    _buttonListView.layer.cornerRadius = 10;
    _buttonListView.hidden = YES;
    
    buttonimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.8, 2*100, 50)];
    buttonimageView.userInteractionEnabled = YES;
    [self createButtonByNumber:numOfButton withSize:CGSizeMake(80, 50) inImageView:(UIImageView *)buttonimageView];
    [_buttonListView addSubview:buttonimageView];
    [_baseView addSubview:_buttonListView];
}

- (void)createButtonByNumber:(NSUInteger)number withSize:(CGSize)size inImageView:(UIImageView *)imageview
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"用户中心",@"游戏论坛", nil];
    //子按钮的UI效果自定义
    for (NSUInteger i = 0; i < number; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(optionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 2000;
        button.frame = CGRectMake(20 + i*size.width, 0, size.width, size.height);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 

        [imageview addSubview:button];
    }
}

- (void)adjustButtonListView
{
    
    if (_isOnLeft)
    {
        _buttonListView.frame = CGRectMake(30, self.center.y - 25, _buttonListView.bounds.size.width, _buttonListView.bounds.size.height);
    }
    else
    {
        _buttonListView.frame = CGRectMake((_windowSize.size.width - 30 - _buttonListView.bounds.size.width), self.center.y - 25, _buttonListView.bounds.size.width, _buttonListView.bounds.size.height);
    }
}

- (void)tiggerButtonList
{
    //NSLog(@"tiggerTap");
    _isShowingButtonList = !_isShowingButtonList;
    CGAffineTransform toNormal = CGAffineTransformTranslate(CGAffineTransformIdentity, 1/1.2, 1/1.2);
    [UIView animateWithDuration:0.1 animations:^{
        // Translate normal
        self.transform = toNormal;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.center = _tempCenter;
            [self adjustButtonListView];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                if (_isOnLeft)
                {
                    _buttonListView.hidden = !_isShowingButtonList;
                    if (_isShowingButtonList)
                    {
                        [self popleftAnimation:_buttonListView duration:kDuration];
                        UIImage *img = [UIImage imageNamed:Resouse(@"悬浮背景2.png")];
                        [imageView setImage:img];
                        [self addSubview:imageView];
                        
                        UIImage *image = [UIImage imageNamed:Resouse(@"悬浮条背景2.png")];
                        [buttonimageView setImage:image];
                    }
                    else
                    {
                        [self poprightAnimation:_buttonListView duration:kDuration];
                        UIImage *img = [UIImage imageNamed:Resouse(@"悬浮背景.png")];
                        [imageView setImage:img];
                        [self addSubview:imageView];
                    }
                }
                else
                {
                    _buttonListView.hidden = !_isShowingButtonList;
                    if (_isShowingButtonList)
                    {
                        [self poprightAnimation:_buttonListView duration:kDuration];
                        [imageView removeFromSuperview];
                        UIImage *img = [UIImage imageNamed:Resouse(@"悬浮背景1.png")];
                        [imageView setImage:img];
                        [self addSubview:imageView];
                        
                        UIImage *image = [UIImage imageNamed:Resouse(@"悬浮条背景3.png")];
                        [buttonimageView setImage:image];
                    }
                    else
                    {
                        [self popleftAnimation:_buttonListView duration:kDuration];
                        UIImage *img = [UIImage imageNamed:Resouse(@"悬浮背景.png")];
                        [imageView setImage:img];
                        [self addSubview:imageView];
                    }
                }
                 _isShowingButtonList ? (_buttonListView.alpha = 0.6) : (_buttonListView.alpha = 0);
            }];
        }];
    }];
}
#pragma mark /** 自左向右弹出视图的动画 */
- (void)popleftAnimation:(UIView *)outView duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [outView.layer addAnimation:animation forKey:nil];
}
#pragma mark /** 自右向左弹出视图的动画 */
- (void)poprightAnimation:(UIView *)outView duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [outView.layer addAnimation:animation forKey:nil];
}
#pragma mark - 按钮回调
- (void)optionsButtonPressed:(UIButton *)button
{
    NSLog(@"buttonNumberPressed:%ld",(long)button.tag);
    switch (button.tag)
    {
        case 2000:
            [[NSNotificationCenter defaultCenter]postNotificationName:TOUCH_BUTTON_ZERO object:nil];
            break;
        case 2001:
            [[NSNotificationCenter defaultCenter]postNotificationName:TOUCH_BUTTON_ONE object:nil];
            break;
        default:
            break;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
