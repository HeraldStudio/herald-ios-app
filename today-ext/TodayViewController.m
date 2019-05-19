//
//  TodayViewController.m
//  today-ext
//
//  Created by Wolf-Tungsten on 2018/11/28.
//  Copyright © 2018 Herald Studio. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayViewDataSource.h"
#import "Masonry.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic)TodayViewDataSource *dataSource;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    // Do any additional setup after loading the view from its nib.
    [self constructUI];
}

- (void)constructUI {
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"TodayViewTableCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    TodayViewDataSource *dataSource = [[TodayViewDataSource alloc] init];
    self.dataSource = dataSource;
    [tableView setDataSource:dataSource];
    [tableView setDelegate:self];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize { if (activeDisplayMode == NCWidgetDisplayModeCompact) { self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 60); } else { self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 360); } }

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    //其他代码
}
@end
