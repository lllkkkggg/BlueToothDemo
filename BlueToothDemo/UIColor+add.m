//
//  UIColor+add.m
//  userTest
//
//  Created by iosOne on 16/4/8.
//  Copyright © 2016年 iosOne. All rights reserved.
//

#import "UIColor+add.h"

@implementation UIColor (add)

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
@end
