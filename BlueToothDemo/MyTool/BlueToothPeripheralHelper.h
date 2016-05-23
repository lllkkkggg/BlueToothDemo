//
//  BlueToothPeripheralHelper.h
//  userTest
//
//  Created by iosOne on 16/4/19.
//  Copyright © 2016年 iosOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothPeripheralHelper : NSObject
+(instancetype)sharedInstance;
-(void)createService;
-(void)Advertising;
-(void)sendData;
@end
