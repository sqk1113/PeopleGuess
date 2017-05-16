//
//  NSString+DateCommon.m
//  PhoneRecord
//
//  Created by mac on 17/1/12.
//  Copyright © 2017年 sinocall. All rights reserved.
//

#import "NSString+DateCommon.h"

@implementation NSString (DateCommon)

/**
 如果是今天 返回HH:mm
 如果不是今天是今年 返回MM-dd
 如果不是今年 返回yyyy-MM-dd
 @param dateSrr yyyy-MM-dd HH:mm:ss
 @return
 */
-(NSString *)getCurrentDateStr
{
    NSString *dateSrr = self;
    NSDate * today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *curdate =[[NSDate alloc]init];
    curdate =[df dateFromString:dateSrr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *compToday = [[NSDateComponents alloc] init];
    NSDateComponents *compCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    compToday = [calendar components:unitFlags fromDate:today];
    long weekNumber = [compToday weekday]; //获取星期对应的长整形字符串
    long day=[compToday day];//获取日期对应的长整形字符串
    long year=[compToday year];//获取年对应的长整形字符串
    long month=[compToday month];//获取月对应的长整形字符串
    long hour=[compToday hour];//获取小时对应的长整形字符串
    long minute=[compToday minute];//获取月对应的长整形字符串
    long second=[compToday second];//获取秒对应的长整形字符串
    
    compCur = [calendar components:unitFlags fromDate:curdate];
    long curweekNumber = [compCur weekday]; //获取星期对应的长整形字符串
    long curday=[compCur day];//获取日期对应的长整形字符串
    long curyear=[compCur year];//获取年对应的长整形字符串
    long curmonth=[compCur month];//获取月对应的长整形字符串
    long curhour=[compCur hour];//获取小时对应的长整形字符串
    long curminute=[compCur minute];//获取月对应的长整形字符串
    long cursecond=[compCur second];//获取秒对应的长整形字符串
    if (year==curyear&&month==curmonth&&day==curday) {
        return [NSString stringWithFormat:@"%0ld:%0ld",curhour,curminute];
    }
    else if (year==curyear)
    {
        return [NSString stringWithFormat:@"%0ld-%0ld",curmonth,curday];
    }
    else
    {
        return [NSString stringWithFormat:@"%0ld-%0ld-%0ld",curyear,curmonth,curday];
    }
}
-(NSString *)getMonthAndDay
{
    NSString *dateSrr = self;
    NSDate * today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *curdate =[[NSDate alloc]init];
    curdate =[df dateFromString:dateSrr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *compToday = [[NSDateComponents alloc] init];
    NSDateComponents *compCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    compToday = [calendar components:unitFlags fromDate:today];
    long weekNumber = [compToday weekday]; //获取星期对应的长整形字符串
    long day=[compToday day];//获取日期对应的长整形字符串
    long year=[compToday year];//获取年对应的长整形字符串
    long month=[compToday month];//获取月对应的长整形字符串
    long hour=[compToday hour];//获取小时对应的长整形字符串
    long minute=[compToday minute];//获取月对应的长整形字符串
    long second=[compToday second];//获取秒对应的长整形字符串
    return [NSString stringWithFormat:@"%0ld-%0ld",month,day];
}

-(NSString *)getHoursAndMin
{
    NSString *dateSrr = self;
    NSDate * today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *curdate =[[NSDate alloc]init];
    curdate =[df dateFromString:dateSrr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *compToday = [[NSDateComponents alloc] init];
    NSDateComponents *compCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    compToday = [calendar components:unitFlags fromDate:today];
    long weekNumber = [compToday weekday]; //获取星期对应的长整形字符串
    long day=[compToday day];//获取日期对应的长整形字符串
    long year=[compToday year];//获取年对应的长整形字符串
    long month=[compToday month];//获取月对应的长整形字符串
    long hour=[compToday hour];//获取小时对应的长整形字符串
    long minute=[compToday minute];//获取月对应的长整形字符串
    long second=[compToday second];//获取秒对应的长整形字符串
    return [NSString stringWithFormat:@"%0ld:%0ld",hour,minute];
}

@end
