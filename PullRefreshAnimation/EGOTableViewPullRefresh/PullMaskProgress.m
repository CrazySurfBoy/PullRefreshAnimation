//
//  PullMaskProgress.m
//  PullRefreshAnimation
//
//  Created by SurfBoy on 10/14/15.
//  Copyright © 2015 com.crazysurfboy. All rights reserved.
//

#import "PullMaskProgress.h"

CGFloat const PullMaskWidth = 30.0f;
CGFloat const PullMaskHeight = 24.0f;

@interface PullMaskProgress ()

@property (strong, nonatomic) UIImageView *grayImageView;   // 默认显示灰色图片
@property (strong, nonatomic) UIImageView *colorImageView;  // 需要渐渐填充的图像颜色
@property (strong, nonatomic) CAShapeLayer *maskLayerDown;  // 下的圆蒙板

@end

@implementation PullMaskProgress

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        // 初始化
        self.maskPercent = 0.0f;

        //  默认显示的图像
        self.grayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_refresh_arrow_twitterIcon.png"]];
        [self addSubview:self.grayImageView];

        //  过渡的颜色
        self.colorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_refresh_arrow_highlight_twitterIcon.png"]];
        [self addSubview:self.colorImageView];

        // 设置蒙板
        self.colorImageView.layer.mask = [self crateMaskLayer];
    }

    return self;
}


// 获得画出上下的圆层
- (CALayer *)crateMaskLayer {

    CALayer *mask = [CALayer layer];
    mask.frame = self.colorImageView.bounds;
        
    // 画出一个矩形
    self.maskLayerDown = [CAShapeLayer layer];
    self.maskLayerDown.bounds = CGRectMake(0, 0, PullMaskWidth, PullMaskHeight);
    self.maskLayerDown.fillColor = [UIColor greenColor].CGColor; 
    self.maskLayerDown.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, PullMaskWidth, PullMaskHeight)].CGPath;
    self.maskLayerDown.position = CGPointMake(PullMaskWidth/2, PullMaskHeight + 15);
    [mask addSublayer:self.maskLayerDown];

    // 测试用，查看蒙板的位置
    //[self.layer addSublayer:self.maskLayerDown];

    return mask;
}


// 设置蒙板占图像的百分比
- (void)setMaskPercent:(float)percent {
    
    float offsetY = percent * (PullMaskHeight + 15 - PullMaskHeight/2);
    self.maskLayerDown.position = CGPointMake(PullMaskWidth/2, PullMaskHeight + 15 - offsetY);
}

// Tells the view that its superview is about to change to the specified superview.
- (void)willMoveToSuperview:(UIView *)newSuperview {

    [super willMoveToSuperview:newSuperview];
    self.bounds = CGRectMake(0.0f, 0.0f, PullMaskWidth, PullMaskHeight);
}


@end
