//
//  weaksValues.m
//  BloodPressureDemo
//
//  Created by 帝炎魔 on 16/4/9.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import "LPJweaksValues.h"
#import "NSDate+add.h"

@implementation LPJweaksValues

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        if (arr == nil)
        {
            _array = [NSDate getSevenDaywithDate:[NSDate date]];
            NSLog(@"%@",_array);
        }
        else
        {
            _array = arr;
        }
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    // _array = @[@"04-05",@"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    if(_array == nil||_array.count == 0)
    {
        _array = [NSDate getSevenDaywithDate:[NSDate date]];
    }
    for (UIView *v in self.subviews)
    {
        [v removeFromSuperview];
    }
    CGFloat w = (self.frame.size.width-20*A_WIDTH-10)/6;
    for (int i = 0; i < (_array.count<7?_array.count:7) ;i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(w * i + 8 * A_WIDTH, 0,(self.frame.size.width - 5*A_WIDTH) / (_array.count<7?_array.count:7), self.frame.size.height)];
        label.text = [_array[i] substringFromIndex:5];
        UIFont* font = label.font;
        label.font = [UIFont fontWithName:font.fontName size:12.0f];
        label.textColor = RGB(102, 102, 102, 1);
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
    }
}

@end