//
//  BlueToothHelper.m
//  userTest
//
//  Created by iosOne on 16/4/19.
//  Copyright © 2016年 iosOne. All rights reserved.
//

#import "BlueToothCenterHelper.h"

static BlueToothCenterHelper *blueToothCenterHelper = nil;

@interface BlueToothCenterHelper ( ) <CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong)CBCentralManager *manager;
@property(nonatomic,strong)NSMutableArray *PeripheralArray;//设备数组
@property(nonatomic,strong)NSMutableArray *ServerArray;//服务数组
@property(nonatomic,strong)NSMutableArray *CharacteristicArray;//特征数组

@end

@implementation BlueToothCenterHelper

-(NSMutableArray *)PeripheralArray
{
    if (!_PeripheralArray)
    {
        _PeripheralArray = @[].mutableCopy;
    }
    return _PeripheralArray;
}

-(NSMutableArray *)ServerArray
{
    if (!_ServerArray)
    {
        _ServerArray = @[].mutableCopy;
    }
    return _ServerArray;
}

-(NSMutableArray *)CharacteristicArray
{
    if (!_CharacteristicArray)
    {
        _CharacteristicArray = @[].mutableCopy;
    }
    return _CharacteristicArray;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        blueToothCenterHelper = [[self alloc]init];
    });
    return blueToothCenterHelper;
}

//1.建立中心角色 -+- 获取当前蓝牙状态
-(CBCentralManager *)managerWithStateBlock:(BlueToothState)blueToothState
{
    if (!_manager) {
        _blueToothState = blueToothState;
        _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
    }
    return _manager;
}

-(void)cancelManager
{
    _manager = nil;
}

//2.扫描所有外设
-(void)startScanWithFindPeripheralsBlock:(FindPeripheralsBlock)FindPeripheralsBlock
{
    _PeripheralArray = nil;
    _ServerArray = nil;
    _CharacteristicArray = nil;
    self.findPeripheralsBlock = FindPeripheralsBlock;
    [self stopScan];
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

//3.停止扫描外设
-(void)stopScan
{
    [self.manager stopScan];
}

//4.连接到一个设备
-(void)connectToperipheral:(CBPeripheral *)peripheral withFindServersBlock:(FindServersBlock)FindServersBlock
{
    [self stopScan];
    _findServersBlock = FindServersBlock;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.manager connectPeripheral:peripheral options:dic];
}

//断开连接的设备
-(void)cancelConnectToperipheral:(CBPeripheral *)peripheral
{
    [self.manager cancelPeripheralConnection:peripheral];
}

//5.搜索服务的所有特征
-(void)searchCharacteristicWith:(CBPeripheral *)peripheral andInterestingService:(CBService *)InterestingService withFindCharacteristicsBlock:(FindCharacteristicsBlock)FindCharacteristicsBlock
{
    _findCharacteristicsBlock = FindCharacteristicsBlock;
    [peripheral discoverCharacteristics:nil forService:InterestingService];
}

//6(1).订阅服务的某个特征值
-(void)setNotifyValueForCharacteristicWith:(CBPeripheral *)peripheral WithInterestingCharacteristic:(CBCharacteristic *)InterestingCharacteristic withSuccessBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)FailureBlock
{
    _successBlock = successBlock;
    _failureBlock = FailureBlock;
    [peripheral setNotifyValue:YES forCharacteristic:InterestingCharacteristic];
}

//6(2).直接读取服务的某个特征值
-(void)readValueForCharacteristicWith:(CBPeripheral *)peripheral WithInterestingCharacteristic:(CBCharacteristic *)InterestingCharacteristic withResultBlock:(ResultBlock)ResultBlock
{
    _resultBlock = ResultBlock;
    [peripheral readValueForCharacteristic:InterestingCharacteristic];
}

//7.写值到特征中
-(void)writeValueForCharacteristicWith:(CBPeripheral *)peripheral WithInterestingCharacteristic:(CBCharacteristic *)InterestingCharacteristic  withData:(NSData *)data withResultBlock:(ResultBlock)ResultBlock
{
    _resultBlock = ResultBlock;
    [peripheral writeValue:data forCharacteristic:InterestingCharacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark -CBCentralManagerDelegate
//判断蓝牙状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *messageStr = nil;
    switch (central.state) {
        case 0:
            NSLog(@"蓝牙未知错误");
            messageStr = @"蓝牙未知错误";
            break;
        case 1:
            NSLog(@"蓝牙复位");
            messageStr = @"蓝牙复位";
            break;
        case 2:
            NSLog(@"蓝牙不支持");
            messageStr = @"蓝牙不支持";
            break;
        case 3:
            NSLog(@"蓝牙未授权");
            messageStr = @"蓝牙未授权";
            break;
        case 4:
            NSLog(@"蓝牙未打开");
            messageStr = @"蓝牙未打开";
            break;
        case 5:
            NSLog(@"蓝牙已打开");
            messageStr = @"蓝牙已打开";
            break;
        default:
            break;
    }
    if (_blueToothState)
    {
        _blueToothState(central.state,messageStr);
    }
}

//搜索到外围设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral);
    if(![self.PeripheralArray containsObject:peripheral])
    {
        [self.PeripheralArray addObject:peripheral];
    }

     //回调block
    if (_findPeripheralsBlock)
    {
        _findPeripheralsBlock(_PeripheralArray);
    }
    
}

//成功连接外围设备
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];//发现一个外围设备提供的所有服务
}

#pragma mark - CBPeripheralDelegate
//外围设备提供的服务个数
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for(CBService *service in peripheral.services)
    {
        NSLog(@"-=-==-=-=%@",service);
        if (![self.ServerArray containsObject:service])
        {
            [self.ServerArray addObject:service];
        }
    }
    //回调block
    if (_findServersBlock) {
        _findServersBlock(_ServerArray);
    }
}

//外围设备服务的特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"-=-==---%@",characteristic);
        if (![self.CharacteristicArray containsObject:characteristic])
        {
            [self.CharacteristicArray addObject:characteristic];
        }
    }
     //回调block
    if (_findCharacteristicsBlock) {
        _findCharacteristicsBlock(_CharacteristicArray);
    }
}

//直接读取特征值时的回调
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"----%@  -- %@",dataStr,error);
    if (_successBlock) {
        _successBlock(data);
    }
    if (_resultBlock) {
        _resultBlock(nil,error);
    }
}

//订阅特征值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error:%@",[error localizedDescription]);
    }
    if (_failureBlock) {
        _failureBlock(error);
    }
}

//向外设写数据回调
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (_resultBlock) {
        _resultBlock(nil,error);
    }
}

@end
