//
//  SCCoreBluetooth.m
//  LibBluetooth
//
//  Created by 鐘妘甄 on 2019/5/16.
//  Copyright © 2019 鐘妘甄. All rights reserved.
//

#include "SCCoreBluetooth.h"

@implementation SCBluetooth

- (id) init {
    self = [super init];
    [self initCoreBluetooth];
    return self;
}

- (void) initCoreBluetooth {
    cbmgr_    = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    cbpermgr_ = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

/* CBPeripheralManagerDelegates */
// 藍牙周邊管理器介面實作

// 判斷藍牙是否開啟，並登錄service及charateristic
- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
}

// 利用startAdvertising讓其它藍牙裝置可以搜尋到這一台
- (void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    
}

// 接收從central送過來的資料
- (void) peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    
}

/* CBCentralManagerDelegates */
// 藍牙接收者介面實作

// 偵測藍牙是否開啟，若有，執行scanForPeripheralWithService來掃描周邊
- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBManagerStatePoweredOn) {
        NSLog(@"藍牙未開啟");
        return;
    }
    [cbmgr_ scanForPeripheralsWithServices:nil options:nil];
}

// 找到周邊，以connectPeripheral來連接
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
}

// 連接上周邊之後，掃描裝置具有的Service
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
}

@end
