//
//  NSDate+add.m
//  userTest
//
//  Created by iosOne on 16/4/10.
//  Copyright © 2016年 iosOne. All rights reserved.
//

#import "NSDate+add.h"

@implementation NSDate (add)

+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate
{
    //    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return theComponents.weekday;
}
+(NSArray *)getSevenDaywithDate:(NSDate *)date
{
    NSInteger  day = [self weekdayStringFromDate:date];
    NSMutableArray *arr = @[].mutableCopy;
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    for (int i = 1; i <= 7; i++)
    {
        NSDate *d = [NSDate dateWithTimeInterval:(i-day)*60 * 60 * 24 sinceDate:date];
        [arr addObject:[df stringFromDate:d]];
    }
    return arr;
}
@end
