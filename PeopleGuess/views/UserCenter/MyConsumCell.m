//
//  MyConsumCell.m
//  PhoneRecord
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 sinocall. All rights reserved.
//

#import "MyConsumCell.h"

@implementation MyConsumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 75, 15)];
        _dateLabel.font =[UIFont fontWithName:PFREGULARFONT size:15];
        _dateLabel.textColor = UIColorFromRGB(0x888888);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 75, 13)];
        _timeLabel.font = [UIFont fontWithName:PFREGULARFONT size:13];;
        _timeLabel.textColor = UIColorFromRGB(0x888888);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
        
        _withHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_dateLabel)+10, 15, 250*SCREEN_WIDTH_RATE, 17)];
        _withHoldLabel.font = [UIFont fontWithName:PFREGULARFONT size:17];;
        _withHoldLabel.textColor = UIColorFromRGB(0x000000);
        _withHoldLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_withHoldLabel];
 
        _reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_dateLabel)+10, 40, 250*SCREEN_WIDTH_RATE, 13)];
        _reasonLabel.font = [UIFont fontWithName:PFREGULARFONT size:13];;
        _reasonLabel.textColor = UIColorFromRGB(0xa9a9a9);
        _reasonLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_reasonLabel];
        
        UIImageView *line = [[UIImageView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        line.frame = CGRectMake(15, 69.5f, SCREEN_WIDTH-15, 0.5);
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
