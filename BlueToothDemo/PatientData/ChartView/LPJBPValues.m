//
//  BPValues.m
//  BloodPressureDemo
//
//  Created by 帝炎魔 on 16/4/9.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import "LPJBPValues.h"

#define KDEVICEHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KDEVICEWIDTH ([UIScreen mainScreen].bounds.size.width)


#define RGB(R,G,B,A) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A)]

@interface LPJBPValues ()

@end


@implementation LPJBPValues

- (instancetype)initWithFrame:(CGRect)frame withMaxNum:(CGFloat)maxNum  withMinNum:(CGFloat)minNum
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViewswithMaxNum:maxNum  withMinNum:minNum];
    }
    return self;
}

- (void)setUpViewswithMaxNum:(CGFloat)maxNum  withMinNum:(CGFloat)minNum
{
    CGFloat rowSpace = (maxNum - minNum)/8;
    for (int i = 0; i < 9; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/8.0 * i-17*B_HIGHT/2, self.frame.size.width, 17*B_HIGHT)];
        label.text = [NSString stringWithFormat:@"%.0f", maxNum - i*rowSpace];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = RGB(153, 153, 153, 1);
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
    }
}

@end
