//
//  ViewController.m
//  CAKeyframeAnimation
//
//  Created by apple on 2016/11/22.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 使用CABasicAnimation类做出来的动画只能使layer在两个点之间移动（fromValue-->toValue），具有一定的局限性。而使用CAKeyframeAnimation类做出来的动画能在无数个点之间移动。
 */
#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //redView沿着点移动
    [self moveAlongPoints];
    
    //redView沿着圆移动
//    [self moveAlongCircle];
}

#pragma mark ————— 沿着点移动 —————
- (void)moveAlongPoints
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    animation.keyPath = @"position";
    animation.duration = 2.0;
    
    NSValue *value = [NSValue valueWithCGPoint:CGPointZero];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(300, 200)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(500, 300)];
    animation.values = [NSArray arrayWithObjects:value, value1, value2, value3, nil];
    
    //用来设置每一帧（一个点到另一个点）的时间
    animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:1.5], nil];
    
    //保持执行动画完毕后的状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.redView.layer addAnimation:animation forKey:animation.keyPath];
}

#pragma mark ————— 沿着圆移动 —————
- (void)moveAlongCircle
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    animation.keyPath = @"position";
    animation.duration = 2.0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(100, 100, 200, 200));
    animation.path = path;
    
    //也可以用贝塞尔路径设置圆形
//    animation.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(130, 120, 100, 100)].CGPath;
    
    /**
     设置动画的速度控制函数：
     1、kCAMediaTimingFunctionLinear（线性）：匀速，给人一个相对静态的感觉；
     2、kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开；
     3、kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地；
     4、kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。
     */
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.delegate = self;
    
    CGPathRelease(path);
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.redView.layer addAnimation:animation forKey:nil];
}

#pragma mark ————— CAAnimationDelegate —————
//动画开始之后会调用此方法，方法传进来的参数是之前方法中新创建的animation对象。
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"动画开始之后会调用此方法");
    NSLog(@"anim = %@", anim);
}

//动画结束之后会调用此方法，方法传进来的参数是之前方法中新创建的animation对象。
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束之后调用此方法");
}

@end
