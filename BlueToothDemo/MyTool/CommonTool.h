//
//  CommonTool.h
//  CookBookByHeart
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 LPJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+ (CGFloat)getHeightOfText:(NSString *)text forWidth:(CGFloat)width andFontsize:(CGFloat)fontsize;
+ (NSString *)ShiPuPath;
+ (NSString *)ShiPuPathDirectory;
+ (void)moveJsonFileToSandBox;
+ (NSDictionary *)readJSONFileToDictionary;
+ (NSString *)ShiPuSearchPath;
@end
