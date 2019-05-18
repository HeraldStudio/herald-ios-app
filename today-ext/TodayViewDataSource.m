//
//  TodayViewDataSource.m
//  today-ext
//
//  Created by Wolf-Tungsten on 2019/5/18.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "TodayViewDataSource.h"
@interface TodayViewDataSource ()

@property NSArray *data;

@end

@implementation TodayViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    //通过标识符，在tableView的重用池中找到可用的Cell（在重用池内部其实是一个可变的集合）
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //如果重用池中没有这个标识符对应的cell，则创建一个新的，并且设置标识符
    if (!cell) {
        //代码块内只做Cell样式的处理，不做数据设置
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    //对Cell做数据设置
    [cell.textLabel setText:@"标题"];
    [cell.detailTextLabel setText:@"描述：这是小标题"];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.data = @[@"1", @"2", @"3"];
    return self.data.count;
}

@end
