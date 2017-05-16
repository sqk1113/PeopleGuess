//
//  TakePartCell.h
//  PeopleGuess
//
//  Created by mac on 17/2/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePartModel.h"
#import "MyCreatModel.h"
@interface TakePartCell : UITableViewCell
@property (nonatomic,strong)UIImageView *picImage;
@property (nonatomic,strong)UILabel *lbName;
@property (nonatomic,strong)UILabel *lbTime;
@property (nonatomic,strong)UILabel *lbBuyNum;
@property (nonatomic,strong)UILabel *lbReward;
@property (nonatomic,strong)UIButton *btnShare;
@property (nonatomic,strong)TakePartModel *model;
@property (nonatomic,strong)MyCreatModel *myModel;
-(void)setModel:(TakePartModel *)model;
-(void)setMyModel:(MyCreatModel *)myModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
