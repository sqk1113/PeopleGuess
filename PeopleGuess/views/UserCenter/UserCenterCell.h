//
//  UserCenterCell.h
//  PeopleGuess
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterCell : UITableViewCell
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel *lbText;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
