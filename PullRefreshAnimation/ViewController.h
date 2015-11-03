//
//  ViewController.h
//  PullRefreshAnimation
//
//  Created by SurfBoy on 10/14/15.
//  Copyright © 2015 com.crazysurfboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>


// 下拉
@property(nonatomic,strong) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, assign) BOOL reloading;
@property(nonatomic,strong) UIScrollView *scrollView;

@end

