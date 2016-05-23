//
//  BlueToothPeripheralHelper.m
//  userTest
//
//  Created by iosOne on 16/4/19.
//  Copyright © 2016年 iosOne. All rights reserved.
//

#import "BlueToothPeripheralHelper.h"

static BlueToothPeripheralHelper *BTPH = nil;

@interface BlueToothPeripheralHelper()<CBPeripheralManagerDelegate,CBCentralManagerDelegate>

@property(nonatomic,strong)CBPeripheralManager *manager;
@property(nonatomic,strong)CBMutableCharacteristic *transferCharacteristic;
@property(nonatomic,strong)CBCentral *central;
@end

@implementation BlueToothPeripheralHelper

+(instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        BTPH = [[self alloc]init];
    });
    return BTPH;
}

//1.创建外设角色
-(CBPeripheralManager *)manager
{
    if (!_manager)
    {
        _manager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    }
    return _manager;
}

//2.创建服务
-(void)createService
{
    
    //创建特征，设置特征UUID，属性，值（为nil表示是动态值，生命周期内会发生变化），对值的操作权限；UUID128位
    self.transferCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:@"68753A44-4D6F-1226-9C60-0050E4C00067"] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    //创建服务
    CBMutableService *transferService = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:@"68753A44-4D6F-1226-9C60-0050E4C00068"]  primary:YES];
    //设置服务的特征
    transferService.characteristics = @[self.transferCharacteristic];
    //将服务添加到外设中
    [self.manager addService:transferService];
}

//3.广播服务
-(void)Advertising
{
    [self.manager startAdvertising:@{CBAdvertisementDataLocalNameKey:@"advd123",CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:@"68753A44-4D6F-1226-9C60-0050E4C00068"]] }];
}

//4.发送数据
-(void)sendData
{
    static int i=0;
    i++;
    [self.manager updateValue:[[NSString stringWithFormat:@"%d",i] dataUsingEncoding: NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:[NSArray arrayWithObjects:self.central, nil]];
}


-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}
#pragma mark - CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"%ld",(long)peripheral.state);
    
}

//添加服务
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"添加成功");
}

//进行广播
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
     NSLog(@"正在广播。。。");
}

//中央订阅了服务
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"sfdvd---%@",central);
    [self.manager stopAdvertising];
    self.central = central;
}

//当有可用的发送队列空间的时候会触发以下代理方法，可以在这里面对数据重新发送
-(void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    [self sendData];
}

@end
