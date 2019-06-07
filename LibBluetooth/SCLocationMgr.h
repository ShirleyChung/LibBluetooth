//
//  SCLocationMgr.h
//  LibBluetoothMac
//
//  Created by 鐘妘甄 on 2019/5/22.
//  Copyright © 2019 鐘妘甄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCLocationMgr : NSObject <CLLocationManagerDelegate>
{
    NSUserDefaults*     userDef_;
    CLLocationManager*  clMgr_;
}

@end

NS_ASSUME_NONNULL_END
