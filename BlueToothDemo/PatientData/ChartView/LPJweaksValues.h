//
//  weaksValues.h
//  BloodPressureDemo
//
//  Created by 帝炎魔 on 16/4/9.
//  Copyright © 2016年 帝炎魔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPJweaksValues : UIView
@property(nonatomic,strong)NSArray *array;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr;
- (void)setUpViews;
@end
