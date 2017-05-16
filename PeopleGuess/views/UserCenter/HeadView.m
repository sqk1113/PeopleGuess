//
//  HeadView.m
//  PeopleGuess
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self ==[super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI
{
    _lbYuE = [[UILabel alloc]initWithFrame:CGRectMake(13*SCREEN_WIDTH_RATE, 18*SCREEN_WIDTH_RATE, 200, 14*SCREEN_WIDTH_RATE)];
    
    _lbYuE.font = [UIFont fontWithName:PFREGULARFONT size:14*SCREEN_WIDTH_RATE];
    _lbYuE.textColor = UIColorFromRGB(0x888888);
    [self addSubview:_lbYuE];
    
    _headChildView = [[UIView alloc]initWithFrame:CGRectMake(0, 42*SCREEN_WIDTH_RATE, SCREEN_WIDTH, self.frame.size.height - 42*SCREEN_WIDTH_RATE)];
    _headChildView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headChildView];
    
    _lbTotal = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*SCREEN_WIDTH_RATE, SCREEN_WIDTH/2, 16*SCREEN_WIDTH_RATE)];
    
    _lbTotal.font = [UIFont fontWithName:PFREGULARFONT size:16*SCREEN_WIDTH_RATE];
    _lbTotal.textColor = [UIColor blackColor];
    _lbTotal.textAlignment = NSTextAlignmentCenter;
    [_headChildView addSubview:_lbTotal];
    
    _lbCanExchange = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_lbTotal), 15*SCREEN_WIDTH_RATE, SCREEN_WIDTH/2, 16*SCREEN_WIDTH_RATE)];
    
    _lbCanExchange.font = [UIFont fontWithName:PFREGULARFONT size:16*SCREEN_WIDTH_RATE];
    _lbCanExchange.textColor = [UIColor blackColor];
    _lbCanExchange.textAlignment = NSTextAlignmentCenter;
    [_headChildView addSubview:_lbCanExchange];
    
    _lbTotalCount = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEWY(_lbTotal)+3, SCREEN_WIDTH/2, 57*SCREEN_WIDTH_RATE)];
    _lbTotalCount.textColor = NAVBARMAINCOLOR;
    _lbTotalCount.font = [UIFont fontWithName:PFMEDIUMFONT size:32*SCREEN_WIDTH_RATE];
    
    _lbTotalCount.textAlignment = NSTextAlignmentCenter;
    [_headChildView addSubview:_lbTotalCount];
    
    _lbCanExCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, VIEWY(_lbTotal)+3, SCREEN_WIDTH/2, 57*SCREEN_WIDTH_RATE)];
    _lbCanExCount.textColor = NAVBARMAINCOLOR;
    _lbCanExCount.font = [UIFont fontWithName:PFMEDIUMFONT size:32*SCREEN_WIDTH_RATE];
    
    _lbCanExCount.textAlignment = NSTextAlignmentCenter;
    [_headChildView addSubview:_lbCanExCount];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30*SCREEN_WIDTH_RATE, 0.5, 30*SCREEN_WIDTH_RATE)];
    line.backgroundColor = NAVBARMAINCOLOR;
    line.alpha = 0.35;
    [_headChildView addSubview:line];
}
@end
