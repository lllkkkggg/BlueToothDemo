//
//  BlueToothHelper.h
//  userTest
//  蓝牙主设备
//  Created by iosOne on 16/4/19.
//  Copyright © 2016年 iosOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^FindPeripheralsBlock)(NSArray *array);
typedef void(^FindServersBlock)(NSArray *array);
typedef void(^FindCharacteristicsBlock)(NSArray *array);
typedef void(^FailureBlock)(NSError *error);
typedef void(^SuccessBlock)(id value);
typedef void(^ResultBlock)(id value,NSError *error);
typedef void(^BlueToothState)(NSInteger state,NSString *message);

@interface BlueToothCenterHelper : NSObject

@property(nonatomic,copy)FindPeripheralsBlock findPeripheralsBlock;
@property(nonatomic,copy)FindServersBlock findServersBlock;
@property(nonatomic,copy)FindCharacteristicsBlock findCharacteristicsBlock;
@property(nonatomic,copy)BlueToothState blueToothState;
@property(nonatomic,copy)FailureBlock failureBlock;
@property(nonatomic,copy)SuccessBlock successBlock;
@property(nonatomic,copy)ResultBlock resultBlock;

+(instancetype)sharedInstance;

-(CBCentralManager *)managerWithStateBlock:(BlueToothState)blueToothState;
//1.扫描所有外设
-(void)startScanWithFindPeripheralsBlock:(FindPeripheralsBlock)FindPeripheralsBlock;
//取消蓝牙管理对象
-(void)cancelManager;
//2.停止扫描外设
-(void)stopScan;
//3.连接到一个设备
-(void)connectToperipheral:(CBPeripheral *)peripheral withFindServersBlock:(FindServersBlock)FindServersBlock;
//断开连接的设备
-(void)cancelConnectToperipheral:(CBPeripheral *)peripheral;
//4.搜索服务的所有特征
-(void)searchCharacteristicWith:(CBPeripheral *)peripheral andInterestingService:(CBService *)InterestingService withFindCharacteristicsBlock:(FindCharacteristicsBlock)FindCharacteristicsBlock;
//5(1).订阅服务的某个特征值
-(void)setNotifyValueForCharacteristicWith:(CBPeripheral *)peripheral WithInterestingCharacteristic:(CBCharacteristic *)InterestingCharacteristic withSuccessBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)FailureBlock;
//5(2).直接读取服务的某个特征值
-(void)readValueForCharacteristicWith:(CBPeripheral *)peripheral WithInterestingCharacteristic:(CBCharacteristic *)InterestingCharacteristic withResultBlock:(ResultBlock)ResultBlock;
//6.写值到特征中
-(void)writeValueForCharacteristicWith:(CBPeripheral *)peripheral WithInterestingCharacteristic:(CBCharacteristic *)InterestingCharacteristic  withData:(NSData *)data withResultBlock:(ResultBlock)ResultBlock;

@end
