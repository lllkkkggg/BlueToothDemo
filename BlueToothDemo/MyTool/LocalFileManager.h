//
//  LocalFileManager.h
//  CookBookByHeart
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 LPJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Myshipu.h"
#import "SearchShipu.h"
@interface LocalFileManager : NSObject

+(NSArray *)readFromFile;
+(void)writeToFile:(NSArray *)ObjArray;
+(void)createPathIfNotExist;
+(void)writeToFileWithObject:(Myshipu *)shipu;
+(NSArray *)getCollectArray;
+(NSArray *)getYourLikeArray;
+(NSArray *)readSearchFromFile;
+(void)writeToFileWithSearchShipuObject:(SearchShipu *)shipu;
@end
