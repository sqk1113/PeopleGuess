//
//  SelfSetCell.h
//  PeopleGuess
//
//  Created by mac on 17/2/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfSetCell : UITableViewCell
@property (nonatomic,strong)UILabel *leftText;
@property (nonatomic,strong)UILabel *rightText;
@property (nonatomic,strong)UIImageView *headIcon;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
