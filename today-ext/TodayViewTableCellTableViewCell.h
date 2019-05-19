//
//  TodayViewTableCellTableViewCell.h
//  today-ext
//
//  Created by Wolf-Tungsten on 2019/5/19.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodayViewTableCellTableViewCell : UITableViewCell
@property (nonatomic, weak, readonly) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak, readonly) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak, readonly) IBOutlet UILabel *subTitleLabel;
@end

NS_ASSUME_NONNULL_END
