//
//  SelfSetCell.m
//  PeopleGuess
//
//  Created by mac on 17/2/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SelfSetCell.h"

@implementation SelfSetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    SelfSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelfSetCell"];
    
    if (!cell) {
        cell = [[SelfSetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SelfSetCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _leftText = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 16)];
        _leftText.font = [UIFont fontWithName:PFREGULARFONT size:16];
        [self addSubview:_leftText];
        
        _rightText = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 15, SCREEN_WIDTH/2-15, 16)];
        _rightText.font = [UIFont fontWithName:PFREGULARFONT size:15];
        _rightText.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightText];
        
        _headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 25, 25)];
        _headIcon.layer.cornerRadius = 25/2;
        _headIcon.layer.masksToBounds = YES;
        [self addSubview:_headIcon];
    }
    return self;
}

@end
