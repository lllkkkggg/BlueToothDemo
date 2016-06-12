//
//  VJNumberCell.m
//  VJCalendar
//
//  Created by houweijia on 16/5/28.
//  Copyright © 2016年 VJ. All rights reserved.
//

#define kColor2 [UIColor colorWithRed:40/255.0 green:170/255.0 blue:166/255.0 alpha:1]

#import "VJNumberCell.h"

@implementation VJNumberCell

-(UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width*5/7, self.bounds.size.width*5/7)];
        _dayLabel.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height*0.45);
       _dayLabel.backgroundColor=[UIColor clearColor];
        _dayLabel.textAlignment=NSTextAlignmentCenter;
        _dayLabel.textColor=kColor2;
        _dayLabel.clipsToBounds=YES;
        _dayLabel.layer.cornerRadius=self.bounds.size.width*5/7/2;
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

-(UILabel *)pointLabel
{
    if (!_pointLabel) {
        _pointLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/10, self.bounds.size.width/10)];
        _pointLabel.backgroundColor=[UIColor clearColor];
        _pointLabel.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height*14/15);
        _pointLabel.clipsToBounds=YES;
        _pointLabel.layer.cornerRadius=self.bounds.size.width/10/2;
        [self addSubview:_pointLabel];
    }
    return _pointLabel;
}

@end
