//
//  LocalFileManager.m
//  CookBookByHeart
//
//  Created by mac on 14-9-17.
//  Copyright (c) 2014年 LPJ. All rights reserved.
//

#import "LocalFileManager.h"
#import "CommonTool.h"

@implementation LocalFileManager



//从沙盒中读取文件内容到数组中
+(NSArray *)readFromFile
{
    [self createPathIfNotExist];
    NSArray *objArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[CommonTool ShiPuPath]];
    //按count进行排序 //NSArray排序 按查看数量排序
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"count" ascending:NO];
//    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
//    [objArray sortedArrayUsingDescriptors:sortDescriptors];
    return objArray;
}

+(NSArray *)readSearchFromFile
{
    [self createPathIfNotExist];
    NSArray *objArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[CommonTool ShiPuSearchPath]];
    //按count进行排序 //NSArray排序 按查看数量排序
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"count" ascending:NO];
    //    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    //    [objArray sortedArrayUsingDescriptors:sortDescriptors];
    return objArray;
}

+(void)writeToFileWithSearchShipuObject:(SearchShipu *)shipu
{
    NSMutableArray *oldArray = [[NSMutableArray alloc]initWithArray:[self readSearchFromFile]];
    for (SearchShipu *obj1 in oldArray)
    {
        if ([shipu.searchStr  isEqualToString:obj1.searchStr])
        {
            [oldArray removeObject:obj1];
            break;
        }
    }
    [oldArray insertObject:shipu atIndex:0];
    [NSKeyedArchiver archiveRootObject:oldArray toFile:[CommonTool ShiPuSearchPath]];
}



+(void)writeToFileWithObject:(Myshipu *)shipu
{
    [self createPathIfNotExist];
    NSMutableArray *oldArray = [[NSMutableArray alloc]initWithArray:[self readFromFile]];
    
    for (Myshipu *obj1 in oldArray)
    {
        if ([shipu.shipuID integerValue] == [obj1.shipuID integerValue])
        {
            obj1.count++;
            shipu.count = obj1.count;
            if (shipu.count>3&&shipu.state == 0) {
                shipu.state = 1;
            }
            [oldArray removeObject:obj1];
            break;
        }
    }
    [oldArray insertObject:shipu atIndex:0];
    [NSKeyedArchiver archiveRootObject:oldArray toFile:[CommonTool ShiPuPath]];
}

//将对象数组序列化写入沙盒
+(void)writeToFile:(NSArray *)ObjArray
{
    [self createPathIfNotExist];
    NSMutableArray *oldArray = [[NSMutableArray alloc]initWithArray:[self readFromFile]];
    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:ObjArray];
    
    for (Myshipu *obj1 in oldArray)
    {
        for (Myshipu *obj in tmpArray)
        {
            //NSLog(@"--%@--%@",obj.shipuID,obj1.shipuID);
            if ([obj.shipuID integerValue] == [obj1.shipuID integerValue])
            {
                obj1.count = obj.count;
                [tmpArray removeObject:obj];
                break;
            }
        }
    }
    [oldArray addObjectsFromArray:tmpArray];
    
    [NSKeyedArchiver archiveRootObject:oldArray toFile:[CommonTool ShiPuPath]];
}

//食谱路径不存在则创建食谱存放路径
+(void)createPathIfNotExist
{
    if(![FILE_M fileExistsAtPath:[CommonTool ShiPuPathDirectory]])
    {
        [FILE_M createDirectoryAtPath:[CommonTool ShiPuPathDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![FILE_M fileExistsAtPath:[CommonTool ShiPuPath]]) {
        [FILE_M createFileAtPath:[CommonTool ShiPuPath] contents:nil attributes:nil];
    }
    if(![FILE_M fileExistsAtPath:[CommonTool ShiPuSearchPath]])
    {
        [FILE_M createFileAtPath:[CommonTool ShiPuSearchPath] contents:nil attributes:nil];
    }
}

//获取猜你喜欢数组
+(NSArray *)getYourLikeArray
{
    NSArray *allArray = [self readFromFile];
    NSMutableArray *ILikeArray =[[NSMutableArray alloc]initWithCapacity:0];
    for (Myshipu *obj in allArray) {
        if (obj.state == 1) {
            [ILikeArray addObject:obj];
        }
    }
    return ILikeArray;
}


//获取收藏数组
+(NSArray *)getCollectArray
{
    NSArray *allArray = [self readFromFile];
    NSMutableArray *CollectArray =[[NSMutableArray alloc]initWithCapacity:0];
    for (Myshipu *obj in allArray) {
        if (obj.state == 2) {
            [CollectArray addObject:obj];
        }
    }
    return CollectArray;
}


@end
