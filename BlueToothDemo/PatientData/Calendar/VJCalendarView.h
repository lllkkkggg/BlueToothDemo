//
//  VJCalendarView.h
//  VJCalendar
//
//  Created by houweijia on 16/5/28.
//  Copyright © 2016年 VJ. All rights reserved.
//

#define kColor [UIColor colorWithRed:40/255.0 green:170/255.0 blue:166/255.0 alpha:1]

#import <UIKit/UIKit.h>



@protocol VJCalendarViewDelegate <NSObject>

-(void)didSelectedDate:(NSDate *)date;

@end



@interface VJCalendarView : UIView

typedef NS_ENUM(NSUInteger,VJCalendarMonth){
    VJCalendarMonthPrevious = 0,
    VJCalendarMonthCurrent,
    VJCalendarMonthNext,
};

@property(nonatomic,strong)NSDate *date;
@property(nonatomic,weak)id<VJCalendarViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *dateArray;  //有记录的日期,格式"yyyy-M-d"

- (NSDate *)nextMonthDate;
- (NSDate *)previousMonthDate;

@end
