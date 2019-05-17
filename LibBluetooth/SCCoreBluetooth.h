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
    CBPeripheralManager* cbpermgr_;
    CBCentralManager* cbmgr_;
    NSMutableArray* characteristicArray_;
}
- (void) initCoreBluetooth;

@end

#endif /* SCCoreBluetooth_h */
