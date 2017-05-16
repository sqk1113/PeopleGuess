//
//  PayCenterPayCell.m
//  PeopleGuess
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayCenterPayCell.h"

@implementation PayCenterPayCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    PayCenterPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCenterPayCell"];
    
    if (!cell) {
        cell = [[PayCenterPayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PayCenterPayCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(17*SCREEN_WIDTH_RATE, 14*SCREEN_WIDTH_RATE, 21*SCREEN_WIDTH_RATE, 17*SCREEN_WIDTH_RATE)];
        [self addSubview:_icon];
        
        _lbText = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_icon)+20*SCREEN_WIDTH_RATE,15*SCREEN_WIDTH_RATE , 200, 16*SCREEN_WIDTH_RATE)];
        _lbText.textColor = [UIColor blackColor];
        _lbText.font = [UIFont fontWithName:PFREGULARFONT size:16*SCREEN_WIDTH_RATE];
        [self addSubview:_lbText];
        _imgisSelected = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-37*SCREEN_WIDTH_RATE, 11*SCREEN_WIDTH_RATE, 23*SCREEN_WIDTH_RATE, 23*SCREEN_WIDTH_RATE)];
        _imgisSelected.image = [UIImage imageNamed:@"unchoose_rechargecenter"];
        [self addSubview:_imgisSelected];
        
    }
    return self;
}
@end
