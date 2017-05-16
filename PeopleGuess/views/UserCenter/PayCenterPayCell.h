//
//  PayCenterPayCell.h
//  PeopleGuess
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayCenterPayCell : UITableViewCell
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel *lbText;
@property (nonatomic,strong)UIImageView *imgisSelected;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
