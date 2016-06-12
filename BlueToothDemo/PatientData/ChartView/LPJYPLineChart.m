//
//  YPLineChart.m
//  zhexianDemo
//
//  Created by 开发3 on 16/4/6.
//  Copyright © 2016年 开发3-lyp. All rights reserved.
//

#import "LPJYPLineChart.h"
#define RGB(R,G,B,A) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A)]

@implementation LPJYPLineChart
{
    CALayer *linesLayer;
    
    
    UIView *popView;
    UILabel *disLabel;
    
    int x;
    int y;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //[self addSubview:self.bgImg];
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        x = frame.size.width;
        y = frame.size.height;
        
        
        _hInterval = 10;
        _vInterval = 50;
        
        linesLayer = [[CALayer alloc] init];
        linesLayer.masksToBounds = YES;
        linesLayer.contentsGravity = kCAGravityLeft;
        linesLayer.backgroundColor = [[UIColor redColor] CGColor];
        
        //[self.layer addSublayer:linesLayer];
        
        
        //PopView
        popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [popView setBackgroundColor:[UIColor whiteColor]];
        [popView setAlpha:0.0f];
        
        disLabel = [[UILabel alloc]initWithFrame:popView.frame];
        [disLabel setTextAlignment:NSTextAlignmentCenter];
        
        [popView addSubview:disLabel];
        
        
        [self addSubview:popView];
        
    }
    return self;
}

- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImg.image = [UIImage imageNamed:@"bg_zhexian_03_02"];
    }
    return _bgImg;
}

- (void)drawRect:(CGRect)rect
{
    
    [self setClearsContextBeforeDrawing: YES];
    for (UIView *v in self.subviews)
    {
        [v removeFromSuperview];
    }
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"bg_zhexian_03_02" ofType:@"png"];
    UIImage* myImageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
    //[myImageObj drawAtPoint:CGPointMake(0, 0)];
    [myImageObj drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    if (!_array||_array.count ==0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    //画点线条------------------
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 5.0f;
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetMiterLimit(context, pointMiterLimit);//投影角度
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound );
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    UIColor* color1 = RGB(0, 161, 249, 1);//更改线条的颜色
    [color1 set];
    //绘图
    CGPoint p1 = [[_array objectAtIndex:0] CGPointValue];
    //   NSLog(@"%f");
    CGContextMoveToPoint(context, p1.x + 16, p1.y);//tempHeight-p1.y*tempWidth/tempHeight1);
    for (int i = 0; i<[_array count]; i++)
    {
        p1 = [[_array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(p1.x + 16, p1.y);//tempHeight-p1.y*tempWidth/tempHeight1);
        int j = 0;
        if(p1.y<0)
        {
            j=1;
            goPoint.y = 0;
        }
        if ((int)p1.y>rect.size.height)
        {
            j=2;
            goPoint.y = rect.size.height;
        }
        CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
        //添加触摸点
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius = 5;
        [bt setBackgroundColor:RGB(0, 161, 249, 1)];
        [bt setBounds:CGRectMake(0, 0, 10, 10)];
        [bt setCenter:goPoint];
        [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        if (_isVasibleTag)
        {
            UILabel *lab = [[UILabel alloc]init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = [NSString stringWithFormat:@"%ld",(long)[_tagArray[i] integerValue]];
            lab.center = CGPointMake(goPoint.x, goPoint.y-13);
            lab.bounds = CGRectMake(0, 0, 50, 15);
            lab.font = [UIFont systemFontOfSize:10];
            [self addSubview:lab];
            if (j==1)
            {
                lab.text =@"MAX";
                lab.textColor = [UIColor redColor];
                [bt setBackgroundColor:[UIColor redColor]];
            }
            if (j==2)
            {
                lab.text =@"MIN";
                lab.textColor = [UIColor redColor];
                [bt setBackgroundColor:[UIColor redColor]];
            }
        }
        else
        {
            if (j!=0)
            {
                UILabel *lab = [[UILabel alloc]init];
                lab.textAlignment = NSTextAlignmentCenter;
                if (j==1)
                {
                     lab.text =@"MAX";
                     lab.textColor = [UIColor redColor];
                    [bt setBackgroundColor:[UIColor redColor]];
                }
                if (j==2)
                {
                     lab.text =@"MIN";
                     lab.textColor = [UIColor redColor];
                    [bt setBackgroundColor:[UIColor redColor]];
                }
                lab.center = CGPointMake(goPoint.x, goPoint.y-10);
                lab.bounds = CGRectMake(0, 0, 50, 15);
                lab.font = [UIFont systemFontOfSize:10];
                [self addSubview:lab];
            }
        }
    }
    CGContextStrokePath(context);
}
- (void)btAction:(id)sender{
    //    [disLabel setText:@"400"];
    //
    //    UIButton *bt = (UIButton*)sender;
    //    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    //    [popView setAlpha:1.0f];
}

@end
