//
//  YPLineChart.h
//  zhexianDemo
//
//  Created by 开发3 on 16/4/6.
//  Copyright © 2016年 开发3-lyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPJYPLineChart : UIView

//横竖轴距离间隔
@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;

//横竖轴显示标签
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;

//点信息
@property (nonatomic, strong) NSArray *array;
//标签信息
@property (nonatomic, strong) NSArray* tagArray;

@property (nonatomic, strong) UIImageView *bgImg;
@property(nonatomic,assign)BOOL isVasibleTag;
@end
