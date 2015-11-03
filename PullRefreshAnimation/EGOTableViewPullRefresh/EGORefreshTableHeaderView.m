//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)


- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
// 		CALayer *layer = [CALayer layer];
// 		layer.frame = CGRectMake(60.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
// 		layer.contentsGravity = kCAGravityResizeAspect;
// 		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
// 		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
// 			layer.contentsScale = [[UIScreen mainScreen] scale];
// 		}
// #endif
		
// 		[[self layer] addSublayer:layer];
// 		_arrowImage=layer;
		
		// UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		// view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		// [self addSubview:view];
		// _activityView = view;
		
		
		[self setState:EGOOPullRefreshNormal];

		// 添加带旋转的动画
		self.pullActivityIndicator = [[PullActivityIndicator alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, frame.size.height - 50.0f, 30, 30)];
		[self addSubview:self.pullActivityIndicator];

		// 蒙板进度
		self.pullMaskProgress = [[PullMaskProgress alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, frame.size.height - 35.0f, 30, 24)];
		[self addSubview:self.pullMaskProgress];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	/*
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@", @"Last Updated: %@"), [dateFormatter stringFromDate:date]];
        //_lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@", @"Last Updated: %@"), [NSDate timeAgoSinceDate:date]];
        
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
	*/
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			//NSLog(@"EGOOPullRefreshPulling");
			
			break;

		case EGOOPullRefreshNormal:
			
			//NSLog(@"EGOOPullRefreshNormal");
			
			[self.pullActivityIndicator stopAnimating]; 

			break;
		case EGOOPullRefreshLoading:

			//NSLog(@"EGOOPullRefreshLoading");

			// 开始加载，开始旋转动画
			[self.pullActivityIndicator startAnimating];
			self.pullMaskProgress.hidden = YES;
			[self.pullMaskProgress setMaskPercent:0.0];

			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	

	// 显示灰色的图标
	if (_state == EGOOPullRefreshNormal) {
		if (scrollView.contentOffset.y < -1 && scrollView.contentOffset.y > -10) {
			self.pullMaskProgress.hidden = NO;
		}
	}


	////NSLog(@"egoRefreshScrollViewDidScroll");
	////NSLog(@"scrollView.contentOffset.y:%f", scrollView.contentOffset.y);
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {


		// 设置过渡效果
		float p = 0.0;
		if (scrollView.contentOffset.y < -20) {

			// 如果超过 y 起过了-45，设置成百分百
			if (scrollView.contentOffset.y < - 65) {
				p = 1.0;
			}
			else {
				p = (scrollView.contentOffset.y + 10) / -65;
			}
		}
		[self.pullMaskProgress setMaskPercent:p];
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {

			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];



}

@end
