//
//  NSString+dateToWeek.h
//  FYZKitchen
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (dateToWeek)
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
+ (NSString*)englishDateStringFromDate:(NSString*)inputDate;
@end
