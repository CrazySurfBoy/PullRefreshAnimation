//
//  PullActivityIndicator.m
//  PullRefreshAnimation
//
//  Created by SurfBoy on 10/14/15.
//  Copyright © 2015 com.crazysurfboy. All rights reserved.
//

#import "PullActivityIndicator.h"

@interface PullActivityIndicator ()

@property (nonatomic, strong) UIImageView *animateCircle;

@end

@implementation PullActivityIndicator

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        //  图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitterIcon.png"]];
        [self addSubview:iconImageView];

        //  转动的图片
        self.animateCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_indicator.png"]];
        [self addSubview:self.animateCircle];

        // 默认创建隐藏
        self.hidden = YES;
    }

    return self;
}


// 动画开始
- (void)startAnimating {

    // 判断是否已经常见过动画，如果已经创建则不再创建动画
    CAAnimation *exiestAnimation = [self.animateCircle.layer animationForKey:@"rotate"];
    if (exiestAnimation) {
        return;
    }
    
    // 显示
    self.hidden = NO;
    
    // 设置动画让它旋转起来
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(2*M_PI);
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1.0f;
    [self.animateCircle.layer addAnimation:animation forKey:@"rotate"];
}


// 停止动画
- (void)stopAnimating {

    self.hidden = YES;
    [self.animateCircle.layer removeAllAnimations];
}


// Tells the view that its superview is about to change to the specified superview.
- (void)willMoveToSuperview:(UIView *)newSuperview {

    [super willMoveToSuperview:newSuperview];
    self.bounds = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
}


@end
