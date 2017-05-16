//
//  UserCenterCell.m
//  PeopleGuess
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UserCenterCell.h"

@implementation UserCenterCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCell"];
    
    if (!cell) {
        cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UserCenterCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(28*SCREEN_WIDTH_RATE, 20*SCREEN_WIDTH_RATE, 16*SCREEN_WIDTH_RATE, 16*SCREEN_WIDTH_RATE)];
        [self addSubview:_icon];
        
        _lbText = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_icon)+20*SCREEN_WIDTH_RATE, _icon.frame.origin.y, 200, 16*SCREEN_WIDTH_RATE)];
        _lbText.textColor = [UIColor blackColor];
        _lbText.font = [UIFont fontWithName:PFREGULARFONT size:17*SCREEN_WIDTH_RATE];
        [self addSubview:_lbText];
    }
    return self;
}

@end
