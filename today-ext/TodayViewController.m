//
//  TodayViewController.m
//  today-ext
//
//  Created by Wolf-Tungsten on 2018/11/28.
//  Copyright © 2018 Herald Studio. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayViewDataSource.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    // Do any additional setup after loading the view from its nib.
    [self constructUI];
    NSLog(@"初始化小公举");
}

- (void)constructUI {
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    TodayViewDataSource *dataSource = [[TodayViewDataSource alloc] init];
    [tableView setDataSource:dataSource];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize { if (activeDisplayMode == NCWidgetDisplayModeCompact) { self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110); } else { self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300); } }

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
