//
//  NSString+DateCommon.h
//  PhoneRecord
//
//  Created by mac on 17/1/12.
//  Copyright © 2017年 sinocall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateCommon)

/**
 时间处理

 @param dateSrr 固定格式时间字符串
 @return
 */
-(NSString *)getCurrentDateStr;

-(NSString *)getMonthAndDay;

-(NSString *)getHoursAndMin;
@end
