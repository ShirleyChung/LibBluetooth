//
//  SCLocationMgr.m
//  LibBluetoothMac
//
//  Created by 鐘妘甄 on 2019/5/22.
//  Copyright © 2019 鐘妘甄. All rights reserved.
//

#import "SCLocationMgr.h"

#define KEY_UUID @"uuid"

@implementation SCLocationMgr

-(id) init {
    self = [super init];
    clMgr_ = [[CLLocationManager alloc] init];
    clMgr_.delegate = self;

    NSUUID* uuid = [userDef_ objectForKey:KEY_UUID];
    if (uuid == nil) {
        uuid = [NSUUID UUID];
        [userDef_ setObject:uuid forKey:KEY_UUID];
    }
    
    CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"libBluetooth"];
    
    [clMgr_ startRangingBeaconsInRegion:region];
    [clMgr_ startMonitoringForRegion:region];
    return self;
}

@end
