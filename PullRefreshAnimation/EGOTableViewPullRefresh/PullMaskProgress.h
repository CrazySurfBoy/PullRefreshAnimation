//
//  PullMaskProgress.h
//  PullRefreshAnimation
//
//  Created by SurfBoy on 10/14/15.
//  Copyright © 2015 com.crazysurfboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullMaskProgress : UIView {

    float _maskPercent;
}

@property(nonatomic, assign) float maskPercent; // 蒙板的百分比



/**
 *  创建蒙板图层
 *  
 *  @return CALayer
 */
- (CALayer *)crateMaskLayer;
@end
