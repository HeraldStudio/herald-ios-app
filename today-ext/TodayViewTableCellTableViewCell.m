//
//  TodayViewTableCellTableViewCell.m
//  today-ext
//
//  Created by Wolf-Tungsten on 2019/5/19.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "TodayViewTableCellTableViewCell.h"
@interface TodayViewTableCellTableViewCell()
@property (nonatomic, weak, readwrite) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak, readwrite) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak, readwrite) IBOutlet UILabel *subTitleLabel;
@end

@implementation TodayViewTableCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
