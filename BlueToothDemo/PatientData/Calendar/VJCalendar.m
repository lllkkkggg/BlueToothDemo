//
//  VJCalendar.m
//  VJCalendar
//
//  Created by houweijia on 16/5/28.
//  Copyright © 2016年 VJ. All rights reserved.
//

#define kCyanColor2 [UIColor colorWithRed:133/255.0 green:176/255.0 blue:174/255.0 alpha:1]

#define kWeekDay @[@"Su",@"Mo",@"Tu",@"We",@"Th",@"Fr",@"St"]
#import "VJCalendar.h"
#import "VJCalendarView.h"

@interface VJCalendar ()<UIScrollViewDelegate,VJCalendarViewDelegate>
{
    NSDateFormatter *_dateFormattor;
    UIButton *_dateButton;
    
    NSDate *_date;
}
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)VJCalendarView *previousCalendarView;
@property(nonatomic,retain)VJCalendarView *currentCalendarView;
@property(nonatomic,retain)VJCalendarView *nextCalendarView;

@end

@implementation VJCalendar

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/8)];
        topView.backgroundColor=[UIColor clearColor];
        [self addSubview:topView];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, topView.frame.size.width, 2)];
        lineView.backgroundColor=kColor;
        [topView addSubview:lineView];
        
        ///今天按钮
//        UIButton *todayButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        todayButton.frame=CGRectMake(0, 0, topView.frame.size.width/3, topView.frame.size.height);
//        [todayButton setTitle:@"今天" forState:UIControlStateNormal];
//        [todayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [todayButton addTarget:self action:@selector(skipToToday) forControlEvents:UIControlEventTouchUpInside];
//        [topView addSubview:todayButton];
        
        _dateButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _dateButton.frame=CGRectMake(0, 0, topView.frame.size.width/3+50, topView.frame.size.height);
        [_dateButton setTitle:[self stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        [_dateButton setTitleColor:kColor forState:UIControlStateNormal];
        [topView addSubview:_dateButton];
        
        for (int i=0; i<7; i++) {
            UILabel *weekDayLabel=[[UILabel alloc]initWithFrame:CGRectMake(i*frame.size.width/7, topView.frame.origin.y+CGRectGetHeight(topView.frame), frame.size.width/7, frame.size.height/8)];
            weekDayLabel.backgroundColor=[UIColor clearColor]; 
            if (i==0 || i==6) {
                weekDayLabel.textColor=[UIColor colorWithRed:222/255.0 green:174/255.0 blue:152/255.0 alpha:1];
            }
            weekDayLabel.text=kWeekDay[i];
            weekDayLabel.font=[UIFont systemFontOfSize:14];
            weekDayLabel.textAlignment=NSTextAlignmentCenter;
            [self addSubview:weekDayLabel];
        }
        
        [self setupScrollView];
        [self setupCurrentDate:[NSDate date]];
        
    }
    return self;
}

///回到今天
-(void)skipToToday
{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"selectedDate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self setupCurrentDate:[NSDate date]];
    
}

///设置日期格式
-(NSString *)stringFromDate:(NSDate *)date
{
    if (!_dateFormattor) {
        _dateFormattor=[[NSDateFormatter alloc]init];
        [_dateFormattor setDateFormat:@"yyyy年/M月"];
    }
    return [_dateFormattor stringFromDate:date];
}

///设置日历
-(void)setupScrollView
{
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.frame.size.height*2/8, self.frame.size.width, self.frame.size.height*6/8)];
    self.scrollView.contentSize=CGSizeMake(self.frame.size.width*3, 0);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.contentOffset=CGPointMake(self.scrollView.frame.size.width, 0);
    self.scrollView.delegate=self;
    [self addSubview:self.scrollView];
    
    self.previousCalendarView=[[VJCalendarView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    [_scrollView addSubview:self.previousCalendarView];
    
    self.currentCalendarView=[[VJCalendarView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    self.currentCalendarView.delegate=self;
    [_scrollView addSubview:self.currentCalendarView];
    
    self.nextCalendarView=[[VJCalendarView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    [_scrollView addSubview:self.nextCalendarView];
}

-(void)setupCurrentDate:(NSDate *)date
{
    _date=date;
    self.currentCalendarView.date=date;
    self.previousCalendarView.date=[self.currentCalendarView previousMonthDate];
    self.nextCalendarView.date=[self.currentCalendarView nextMonthDate];
    [_dateButton setTitle:[self stringFromDate:date] forState:UIControlStateNormal];
}


#pragma mark --UIScrollViewDelegate--
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<self.scrollView.frame.size.width) {
        [self setupCurrentDate:[self.currentCalendarView previousMonthDate]];
    }
    else if (scrollView.contentOffset.x>self.scrollView.frame.size.width){
        [self setupCurrentDate:[self.currentCalendarView nextMonthDate]];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
}

#pragma mark --VJCalendarViewDelegate--
-(void)didSelectedDate:(NSDate *)date
{
    [self setupCurrentDate:_date];
}

@end
