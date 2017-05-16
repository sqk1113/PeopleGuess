//
//  MyConsumCell.h
//  PhoneRecord
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 sinocall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyConsumCell : UITableViewCell
@property (strong, nonatomic) UILabel *dateLabel;//日期
@property (strong, nonatomic) UILabel *timeLabel;//时间
@property (strong, nonatomic) UILabel *withHoldLabel;//消费录音币数量
@property (strong, nonatomic) UILabel *reasonLabel;//消费原因
@end
