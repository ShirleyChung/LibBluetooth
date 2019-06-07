//
//  SCCoreBluetooth.m
//  LibBluetooth
//
//  Created by 鐘妘甄 on 2019/5/16.
//  Copyright © 2019 鐘妘甄. All rights reserved.
//

#include "SCCoreBluetooth.h"

#define UUID_CEN  @"DADFAAA8-43F0-4EDB-A996-A31C6BFC68B4"
#define UUID_CH1  @"C1E2094B-6940-4A4E-B52B-132BEC37B81A"
#define UUID_CH2  @"751D831B-C9F1-4AEC-B94A-01E9647F5233"

@implementation SCBluetooth

@synthesize connectPeripherals;

- (id) init {
    self            = [super init];
    userDef_        = [NSUserDefaults standardUserDefaults];
    peripheralUUID_ = [CBUUID UUIDWithString:UUID_CEN];
    bAdvertise_     = false;
    connectPeripherals = [[NSMutableSet alloc] init];
    return self;
}

- (void) dealloc {
    bAdvertise_     = false;
}

- (id) initCentralWithName:(NSString*) name {
    centralName_ = name;
    central_     = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return self;
}

- (id) initPeripheralWithName:(NSString*) name {
    bAdvertise_     = true;
    peripheralName_ = name;
    peripheral_     = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];  // 這個會觸發 peripheralManagerDidUpdateState
    characteristics_= [[NSMutableArray alloc] init];
    return self;
}

- (void) stopPeripheral {
    bAdvertise_     = false;
}

- (void) stopScan {
    [central_ stopScan];
}

/* CBPeripheralManagerDelegates */
// 藍牙周邊管理器介面實作

// 判斷藍牙是否開啟，並登錄service及charateristic
- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBManagerStatePoweredOn) {
        NSLog(@"藍牙未開啟");
        return;
    }
    
    peripheral.delegate = self;
    // 設定Service
    CBMutableService* service = [[CBMutableService alloc] initWithType:peripheralUUID_ primary:YES];
    // 設定Characteristic
    CBMutableCharacteristic* characteristic;
    // 第一個CC01提供訊息廣播用 CBCharacteristicPropertyNotify
    characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:UUID_CH1] properties:CBCharacteristicPropertyNotify|CBCharacteristicPropertyIndicate|CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    [characteristics_ addObject:characteristic];
    // 第二個CC01提供接收資料 CBCharacteristicPropertyWrite
    characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:UUID_CH2] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    [characteristics_ addObject:characteristic];
    
    service.characteristics = characteristics_;
    [peripheral_ addService:service]; // 這裡會觸發 didAddService
}

// 利用startAdvertising讓其它藍牙裝置可以搜尋到這一台
- (void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    // 開始廣播，讓其它裝置可以看到自己
    [peripheral_ startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey: @[service.UUID], CBAdvertisementDataLocalNameKey: peripheralName_ }];

    [self runThreadCharateristicData];
}

// 讓CC01送資料出去
- (void) runThreadCharateristicData {
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        int i = 0;
        while(bAdvertise_) {
            NSString* s = [NSString stringWithFormat:@"%d", i++];
            [self sendServerData:[s dataUsingEncoding:NSUTF8StringEncoding]];
            [NSThread sleepForTimeInterval:1.0];
        }
    });
}

// 使裝置送資料
- (void) sendServerData: (NSData*) data {
    // 取得第一個characteristic
    CBMutableCharacteristic* characteristic = [characteristics_ objectAtIndex:0];
    [peripheral_ updateValue:data forCharacteristic:characteristic onSubscribedCentrals:nil];
}

// 接收從central送過來的資料
- (void) peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    CBATTRequest* att = [requests objectAtIndex:0];
    NSLog(@"recv from center: %@", [[NSString alloc] initWithData:att.value encoding:NSUTF8StringEncoding]);
}

/* CBCentralManagerDelegates */
// 藍牙接收者介面實作

// 偵測藍牙是否開啟，若有，執行scanForPeripheralWithService來掃描周邊
- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBManagerStatePoweredOn) {
        NSLog(@"藍牙未開啟");
        return;
    }
    [central_ scanForPeripheralsWithServices:nil options:nil]; // 會觸發didDiscoverPeripheral
}

- (void) scan {
    
}

// 找到周邊，以connectPeripheral來連接
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"found: %@", peripheral.name);
//       if (peripheral.name != nil)
//       {
//        connectPeripheral_ = peripheral; /* 連接上的周邊保存reference以免被釋放掉 */
        peripheral.delegate = self;
        [connectPeripherals addObject:peripheral];
        [central connectPeripheral:peripheral options:nil];
//            [central stopScan];
//       }
}


- (void) addPeripheral: (CBPeripheral*) peripheral {
    
}


// 連接上周邊之後，掃描裝置具有的Service
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {

    [peripheral discoverServices:nil]; // 會觸發didDiscoverServices
}

// 從所有Service中，尋找所包函的chararteristics
- (void) peripheral:(CBPeripheral*)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService* service in peripheral.services) {
        // NSArray* arr = [[NSArray alloc] initWithObjects: [CBUUID UUIDWithString:@"CC01"], nil];
        NSLog(@"service's UUID: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// 列舉出所有characteristics, 針對需要的characteristic做處理
- (void) peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {
    for (CBCharacteristic* characteristic in service.characteristics) {
        /* 若是通知的屬性，CC01,則觸發didUpdateValueForCharacteristic */
        if ((characteristic.properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify)
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        
        /* 若是寫資料的屬性，則寫一筆資料給周邊 */
        if ((characteristic.properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
            writeChararteristic_ = characteristic;
            // [self sendClientData: data];
        }
    }
}

// 印出Client所通知的值
- (void) peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSString* str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"recieve: %@", str);
}

// 送資料給Client
- (void) sendClientData:(CBPeripheral*) peripheral Data: (NSData*) data {
    [peripheral writeValue:data forCharacteristic:writeChararteristic_ type:CBCharacteristicWriteWithResponse];
}

@end
