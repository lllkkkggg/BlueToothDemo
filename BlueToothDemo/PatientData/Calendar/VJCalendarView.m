//
//  VJCalendarView.m
//  VJCalendar
//
//  Created by houweijia on 16/5/28.
//  Copyright © 2016年 VJ. All rights reserved.
//

#define kIdentififer @"dayCell"

#define redArray @[@"0",@"6",@"7",@"13",@"14",@"20",@"21",@"27",@"28",@"34",@"35",@"41"]
#define kCyanColor [UIColor colorWithRed:133/255.0 green:176/255.0 blue:174/255.0 alpha:0.6]

#import "VJCalendarView.h"
#import "VJNumberCell.h"

@interface VJCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    UICollectionView *_collectionView;
    UILabel *_todayLabel;
    NSMutableDictionary *_dateDictionary;
    
}

@end

@implementation VJCalendarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        NSLog(@"\n    %@",NSHomeDirectory());
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"selectedDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.dateArray=[NSMutableArray arrayWithObjects:@"2016-6-5",@"2016-6-7",@"2016-4-10", nil];

          [self setupCollectonView];
    }
    return self;
}

-(void)setDate:(NSDate *)date
{
    _date=date;
    [_collectionView removeFromSuperview];
    [self setupCollectonView];
}

///获取date的下个月日期
- (NSDate *)nextMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}

/// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}

/// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];  //设置每周的第一天从星期几开始，比如：1代表星期日开始，2代表星期一开始，以此类推
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];  //根据NSDateComponents对象得到一个NSDate对象,这个月1号;
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate]; //取得一个NSDate对象的1个或多个部分，用NSDateComponents来封装
    
    return firstComponents.weekday - 1;
}

/// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

-(NSMutableDictionary *)transformString:(NSMutableArray *)mutableArray
{
    if (!_dateDictionary) {
        _dateDictionary=[NSMutableDictionary dictionary];
        for (int i=0;i<mutableArray.count; i++) {
            NSArray *array=[mutableArray[i] componentsSeparatedByString:@"-"];
            [_dateDictionary setObject:array forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dateDictionary;
}


-(void)setupCollectonView
{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing=1;
    layout.minimumInteritemSpacing=1;
    layout.sectionInset=UIEdgeInsetsMake(0, 5, 0, 5);
    layout.itemSize=CGSizeMake((self.frame.size.width-6-10)/7, (self.frame.size.height-5)/6);
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor clearColor];
    [self addSubview:_collectionView];
    [_collectionView registerClass:[VJNumberCell class] forCellWithReuseIdentifier:kIdentififer];
    
    
}

#pragma mark --UICollectionViewDelegate,DataSource--
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VJNumberCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kIdentififer forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    NSInteger firstWeekDay=[self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOfDate:self.date];
//    NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOfDate:[self previousMonthDate]];
   
    NSString *indexStr=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    for (int j=0; j<redArray.count; j++) {
        if ([indexStr isEqualToString:redArray[j]]) {
            cell.dayLabel.textColor=[UIColor redColor];
        }
    }
    
    
    if (indexPath.row<firstWeekDay) {
        //上个月
//        NSInteger day=totalDaysOfLastMonth-firstWeekDay+indexPath.row+1;
//        cell.dayLabel.text=[NSString stringWithFormat:@"%ld",day];
//        cell.dayLabel.textColor=[UIColor lightGrayColor];
        cell.userInteractionEnabled=NO;
    }else if (indexPath.row>=totalDaysOfMonth+firstWeekDay){
        //下个月
//        NSInteger day = indexPath.row-totalDaysOfMonth-firstWeekDay+1;
//        cell.dayLabel.text=[NSString stringWithFormat:@"%ld",day];
//        cell.dayLabel.textColor=[UIColor lightGrayColor];
        cell.userInteractionEnabled=NO;
    }else{
        //当前月
        NSInteger day=indexPath.row-firstWeekDay+1;
        cell.dayLabel.text=[NSString stringWithFormat:@"%ld",day];
        
        //今天高亮显示
        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]]  && [[NSCalendar currentCalendar] isDate:[NSDate date] equalToDate:self.date toUnitGranularity:NSCalendarUnitMonth]) {
            cell.dayLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:199/255.0 blue:149/255.0 alpha:1];
            _todayLabel=cell.dayLabel;
        }
        
        //有记录的日期
        NSDateComponents *recordComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
        NSMutableDictionary *dic=[self transformString:self.dateArray];
        for (int i=0; i<dic.count; i++) {
            NSArray *stringDateArray=[dic objectForKey:[NSString stringWithFormat:@"%d",i]];
            if ([[NSString stringWithFormat:@"%ld",recordComponents.year] isEqualToString: stringDateArray[0]]
                && [[NSString stringWithFormat:@"%ld",recordComponents.month] isEqualToString: stringDateArray[1]]
                && [[NSString stringWithFormat:@"%ld",day] isEqualToString: stringDateArray[2]]) {
                cell.pointLabel.backgroundColor=[UIColor colorWithRed:222/255.0 green:174/255.0 blue:152/255.0 alpha:1];
            }
        }
        
        // 选中的日期;
        NSDate *selectedDate=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDate"];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-M-d"];
        NSString *selectedString=[formatter stringFromDate:selectedDate];
        NSArray *array=[selectedString componentsSeparatedByString:@"-"];
            if ([[NSString stringWithFormat:@"%ld",recordComponents.year] isEqualToString: array[0]]
                && [[NSString stringWithFormat:@"%ld",recordComponents.month] isEqualToString: array[1]]
                && [[NSString stringWithFormat:@"%ld",day] isEqualToString: array[2]]) {
                cell.dayLabel.backgroundColor=kCyanColor;
            }
        
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    [components setDay:(indexPath.row - firstWeekday + 1)];
    NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    //得到本地时间，避免时区问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:selectedDate];
    NSDate *localeDate = [selectedDate dateByAddingTimeInterval:interval];
    
    [[NSUserDefaults standardUserDefaults]setObject:localeDate forKey:@"selectedDate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self setDate:self.date];

    if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
        [self.delegate didSelectedDate:localeDate];
    }
    
}


@end
