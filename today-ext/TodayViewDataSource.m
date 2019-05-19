//
//  TodayViewDataSource.m
//  today-ext
//
//  Created by Wolf-Tungsten on 2019/5/18.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "TodayViewDataSource.h"
#import "TodayViewTableCellTableViewCell.h"

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TodayViewDataSource ()

@property (nonatomic) NSMutableArray *items;

@end

@implementation TodayViewDataSource

- (id) init {
    self = [super init];
    if (self != nil){
        NSUserDefaults* todayExtDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.myseu"];
        self.items = [NSMutableArray new];
        NSArray *types = @[@"课程", @"考试", @"实验"];

        for (NSString *type in types) {
            NSArray *itemsOfThisType = [todayExtDefaults objectForKey:type];
            for (NSDictionary *item in itemsOfThisType) {
                
                NSTimeInterval now = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
                
                if([item[@"timestamp"] doubleValue] > now) {
                    [self.items addObject:@{@"color":item[@"color"],
                                            @"title":item[@"title"],
                                            @"subtitle":item[@"subtitle"],
                                            @"timestamp":item[@"timestamp"],
                                            @"type":type
                                            }];
                }
            }
        }
        
        [self.items sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [(NSNumber *)(obj1[@"timestamp"]) compare:(NSNumber *)(obj2[@"timestamp"])];
        }];
    }
    return self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString *cellID = @"cell";
    //通过标识符，在tableView的重用池中找到可用的Cell（在重用池内部其实是一个可变的集合）
    TodayViewTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //如果重用池中没有这个标识符对应的cell，则创建一个新的，并且设置标识符
    if (!cell) {
        //代码块内只做Cell样式的处理，不做数据设置
        cell = [[TodayViewTableCellTableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.titleLabel setText:self.items[indexPath.row][@"title"]];
    [cell.subTitleLabel setText:self.items[indexPath.row][@"subtitle"]];
    [cell.typeLabel setText:self.items[indexPath.row][@"type"]];
//    cell.typeLabel.backgroundColor = HexRGB([(NSNumber *)self.items[indexPath.row][@"color"] intValue]);
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
