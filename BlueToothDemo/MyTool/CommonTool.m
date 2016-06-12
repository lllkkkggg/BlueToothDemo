//
//  CommonTool.m
//  CookBookByHeart
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 LPJ. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool


+ (CGFloat)getHeightOfText:(NSString *)text forWidth:(CGFloat)width andFontsize:(CGFloat)fontsize{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontsize]} context:nil];
    return rect.size.height;
}

+ (NSString *)ShiPuPath{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SHIPU/shipu.plist"];
}

+ (NSString *)ShiPuSearchPath
{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SHIPU/shipuSearch.plist"];
}
+ (NSString *)ShiPuPathDirectory{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SHIPU"];
}

+(void)moveJsonFileToSandBox
{
    
    NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"xinshipu_fenlei" ofType:@"json"];
    NSString *destinationPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SHIPU/xinshipu_fenlei.json"];
    if (![FILE_M fileExistsAtPath:destinationPath]) {
        [FILE_M moveItemAtPath:sourcePath toPath:destinationPath error:nil];
    }
}
+(NSDictionary *)readJSONFileToDictionary
{
    NSString *destinationPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SHIPU/xinshipu_fenlei.json"];
    if ([FILE_M fileExistsAtPath:destinationPath]) {
        NSData *data = [NSData dataWithContentsOfFile:destinationPath];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return jsonDic;
    }
    return nil;
}

@end
