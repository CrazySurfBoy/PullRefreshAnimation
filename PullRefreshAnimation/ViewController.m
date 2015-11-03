//
//  ViewController.m
//  PullRefreshAnimation
//
//  Created by SurfBoy on 10/14/15.
//  Copyright © 2015 com.crazysurfboy. All rights reserved.
//

#import "ViewController.h"
#import "PullActivityIndicator.h"

#define SCREEN_WDITH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(assign) float imageHeight;
@property(nonatomic, strong) UITableView *listTableView;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Init
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"下拉刷新";
    self.imageHeight = SCREEN_WDITH/ 2.5;
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];

    // UITableView
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WDITH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.listTableView setDelegate:self];
    [self.listTableView setDataSource:self];
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.listTableView];

    // EGORefresh
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.listTableView.bounds.size.height, SCREEN_WDITH, self.listTableView.bounds.size.height)];
    self.refreshHeaderView.delegate = self;
    [self.listTableView addSubview:self.refreshHeaderView];
    [self.refreshHeaderView refreshLastUpdatedDate];
}


#pragma mark -
#pragma mark -#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 

    return 10; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Row cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        // 图像
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WDITH, self.imageHeight)];
        photoImageView.tag = 10;
        [cell.contentView addSubview:photoImageView];

        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 175.0, SCREEN_WDITH, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 12;
        [cell.contentView addSubview:titleLabel];

        // 内容标题
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 200.0, SCREEN_WDITH, 20.0)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        contentLabel.tag = 13;
        [cell.contentView addSubview:contentLabel];

        

    }

    // 图片
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:10];
    [photoImageView setImage:[UIImage imageNamed:@"l1.png"]];

    // 标题
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:12];
    titleLabel.text = @"北京直飞大板5/7天往返含税机票";

    // 内容
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:13];
    contentLabel.text = @"八月、十月、12月";

    return cell;
}

// Asks the delegate for the height to use for a row in a specified location.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 230;
}




#pragma mark -
#pragma mark EGORefresh


// 完成下拉刷新
- (void)doneLoadingTableViewData{
    
    //DLog(@"doneLoadingTableViewData");

    //  model should call this when its done loading
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listTableView];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //DLog(@"scrollViewDidScroll");
    self.scrollView = scrollView;
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];

    // 这仅只是为了完整体验    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(doneLoadingTableViewData) userInfo:@"" repeats:NO];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
  
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    //DLog(@"egoRefreshTableHeaderDataSourceIsLoading");
    return self.reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    //DLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
    return [NSDate date]; // should return date data source was last changed
    
}


@end
