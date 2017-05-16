//
//  NSString+dateToWeek.m
//  FYZKitchen
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSString+dateToWeek.h"

@implementation NSString (dateToWeek)
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
+ (NSString*)englishDateStringFromDate:(NSString*)inputDate{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newdate = [inputFormatter dateFromString:inputDate];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newdate];
    NSDateComponents *dateComponentnew = [calendar components:unitFlags fromDate:date];
    
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];

    int nowYear = [dateComponentnew year];
    
    NSArray *arr = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sept",@"Oct",@"Nov",@"Dec",nil];
    NSString *monthForEnglish = [arr objectAtIndex:month-1];
    NSString *needStr = [NSString stringWithFormat:@"%@·%d",monthForEnglish,day];
    if (nowYear==year) {
        return needStr;
    }
    else{
        return [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    }
    
}
@end
