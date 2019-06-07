//
//  SCCoreBluetooth.h
//  LibBluetooth
//
//  Created by 鐘妘甄 on 2019/5/16.
//  Copyright © 2019 鐘妘甄. All rights reserved.
//

#ifndef SCCoreBluetooth_h
#define SCCoreBluetooth_h

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SCBluetooth: NSObject<CBPeripheralManagerDelegate, CBCentralManagerDelegate>
{
    NSUserDefaults*         userDef_;
    CBUUID*                 peripheralUUID_;

    // Peripheral members
    NSString*               peripheralName_;
    CBPeripheralManager*    peripheral_;
    NSMutableArray*         characteristics_;
    bool                    bAdvertise_;

    // Central members
    NSString*               centralName_;
    CBCentralManager*       central_;
    CBCharacteristic*       writeChararteristic_;

}

@property NSMutableSet* connectPeripherals;

- (id) initCentralWithName:(NSString*) name;

- (id) initPeripheralWithName:(NSString*) name;

- (void) stopPeripheral;

- (void) stopScan;

- (void) runThreadCharateristicData;

- (void) sendServerData: (NSData*) data;

- (void) sendClientData:(CBPeripheral*) peripheral Data:(NSData*) data;

- (void) addPeripheral: (CBPeripheral*) peripheral;

@end

#endif /* SCCoreBluetooth_h */
