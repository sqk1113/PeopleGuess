//
//  TakePartCell.m
//  PeopleGuess
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TakePartCell.h"

@implementation TakePartCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    TakePartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakePartCell"];
    
    if (!cell) {
        cell = [[TakePartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TakePartCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _picImage = [[UIImageView alloc]initWithFrame:CGRectMake(14*SCREEN_WIDTH_RATE, 15*SCREEN_WIDTH_RATE, 60*SCREEN_WIDTH_RATE, 60*SCREEN_WIDTH_RATE)];
        [self addSubview:_picImage];
        
        _lbName = [[UILabel alloc]initWithFrame:CGRectMake(VIEWX(_picImage)+12*SCREEN_WIDTH_RATE, 21*SCREEN_WIDTH_RATE, 220*SCREEN_WIDTH_RATE, 17*SCREEN_WIDTH_RATE)];
        _lbName.textColor = [UIColor blackColor];
        _lbName.font = [UIFont fontWithName:PFREGULARFONT size:17*SCREEN_WIDTH_RATE];
        [self addSubview:_lbName];
        
        _lbTime = [[UILabel alloc]init];
        _lbTime.textColor = UIColorFromRGB(0xa9a9a9);
        _lbTime.font = [UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE];
        [self addSubview:_lbTime];
        
        _lbBuyNum = [[UILabel alloc]init];
        _lbBuyNum.textColor = UIColorFromRGB(0xa9a9a9);
        _lbBuyNum.font =  [UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE];
        [self addSubview:_lbBuyNum];
        
        _lbReward = [[UILabel alloc]init];
        _lbReward.textColor = UIColorFromRGB(0xa9a9a9);
        _lbReward.font =  [UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE];
        [self addSubview:_lbReward];
        
        _btnShare = [[UIButton alloc]init];
        _btnShare.frame = CGRectMake(SCREEN_WIDTH-85*SCREEN_WIDTH_RATE, 45*SCREEN_WIDTH_RATE, 70*SCREEN_WIDTH_RATE, 30*SCREEN_WIDTH_RATE);
        _btnShare.layer.cornerRadius = 4;
        _btnShare.layer.borderWidth = 1;
        _btnShare.layer.borderColor = [NAVBARMAINCOLOR CGColor];
        _btnShare.layer.masksToBounds = YES;
        [_btnShare setTitle:@"分享" forState:UIControlStateNormal];
        [_btnShare setTitleColor:NAVBARMAINCOLOR forState:UIControlStateNormal];
        _btnShare.titleLabel.font = [UIFont fontWithName:PFREGULARFONT size:15*SCREEN_WIDTH_RATE];
        [self addSubview:_btnShare];

        [Tool addSepLine:CGRectMake(14*SCREEN_WIDTH_RATE, 92.5*SCREEN_WIDTH_RATE-0.5, SCREEN_WIDTH-14*SCREEN_WIDTH_RATE, 0.5) inView:self];
    }
    return self;
}

-(void)setModel:(TakePartModel *)model
{
    _model = model;
    [_picImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    _lbName.text = model.name;
    //未完成
    if (model.status ==0) {
        _lbBuyNum.text = [NSString stringWithFormat:@"下注:%@",model.buyNum];
        CGSize sizeBuyNum = [_lbBuyNum.text sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE] maxW:SCREEN_WIDTH];
        _lbBuyNum.frame = CGRectMake(VIEWX(_picImage)+12*SCREEN_WIDTH_RATE,  58*SCREEN_WIDTH_RATE, sizeBuyNum.width, sizeBuyNum.height);
        _lbReward.hidden = YES;
        _btnShare.hidden = NO;
        return;
    }
    
    //完成
    if (model.status ==1) {
        _lbBuyNum.text = [NSString stringWithFormat:@"下注:%@",model.buyNum];
        CGSize sizeBuyNum = [_lbBuyNum.text sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE] maxW:SCREEN_WIDTH];
        _lbBuyNum.frame = CGRectMake(VIEWX(_picImage)+12*SCREEN_WIDTH_RATE,  58*SCREEN_WIDTH_RATE, sizeBuyNum.width, sizeBuyNum.height);
        
        
        NSString *str =[NSString stringWithFormat:@"%@",model.reward];
        NSString *allStr = [NSString stringWithFormat:@"盈亏:%@",model.reward];
        
        NSMutableAttributedString *arrString = [[NSMutableAttributedString alloc]initWithString:allStr];
        
        if ([model.reward intValue]>=0) {
            [arrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE],NSForegroundColorAttributeName:[UIColor redColor]}range:[allStr rangeOfString:str]];
            _lbReward.attributedText = arrString;
        }
        else{
            [arrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE],NSForegroundColorAttributeName:[UIColor greenColor]}range:[allStr rangeOfString:str]];
            _lbReward.attributedText = arrString;
        }
        CGSize sizeReward = [_lbReward.text sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE] maxW:SCREEN_WIDTH];
        _lbReward.frame = CGRectMake(VIEWX(_lbBuyNum)+10*SCREEN_WIDTH_RATE,  58*SCREEN_WIDTH_RATE, sizeReward.width, sizeReward.height);
        _lbReward.hidden = NO;
        _btnShare.hidden  =YES;
        return;
    }
}

-(void)setMyModel:(MyCreatModel *)myModel
{
    _myModel = myModel;
    [_picImage sd_setImageWithURL:[NSURL URLWithString:myModel.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    _lbName.text = myModel.name;
    //未完成
    if (myModel.status ==0) {
        _lbBuyNum.text = [NSString stringWithFormat:@"投注:%@",myModel.progress];
        CGSize sizeBuyNum = [_lbBuyNum.text sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE] maxW:SCREEN_WIDTH];
        _lbBuyNum.frame = CGRectMake(VIEWX(_picImage)+12*SCREEN_WIDTH_RATE,  58*SCREEN_WIDTH_RATE, sizeBuyNum.width, sizeBuyNum.height);
        _lbReward.hidden = YES;
        _btnShare.hidden = NO;
        return;
    }
    
    //完成
    if (myModel.status ==1) {
        
        _lbBuyNum.text = [NSString stringWithFormat:@"人数:%@",myModel.rnum];
        CGSize sizeBuyNum = [_lbBuyNum.text sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE] maxW:SCREEN_WIDTH];
        _lbBuyNum.frame = CGRectMake(VIEWX(_picImage)+12*SCREEN_WIDTH_RATE,  58*SCREEN_WIDTH_RATE, sizeBuyNum.width, sizeBuyNum.height);
        
        
        NSString *str =[NSString stringWithFormat:@"%@",myModel.commission];
        NSString *allStr = [NSString stringWithFormat:@"佣金:%@",myModel.commission];
        
        NSMutableAttributedString *arrString = [[NSMutableAttributedString alloc]initWithString:allStr];
        
        if ([myModel.commission intValue]>=0) {
            [arrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE],NSForegroundColorAttributeName:[UIColor redColor]}range:[allStr rangeOfString:str]];
            _lbReward.attributedText = arrString;
        }
        else{
            [arrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE],NSForegroundColorAttributeName:[UIColor greenColor]}range:[allStr rangeOfString:str]];
            _lbReward.attributedText = arrString;
        }
        CGSize sizeReward = [_lbReward.text sizeWithFont:[UIFont fontWithName:PFREGULARFONT size:12*SCREEN_WIDTH_RATE] maxW:SCREEN_WIDTH];
        _lbReward.frame = CGRectMake(VIEWX(_lbBuyNum)+10*SCREEN_WIDTH_RATE,  58*SCREEN_WIDTH_RATE, sizeReward.width, sizeReward.height);
        _lbReward.hidden = NO;
        _btnShare.hidden  =YES;
        return;
    }

}
@end
