//
//  MiBandBattery.h
//  MiLift
//
//  Created by Dimitar Topalov on 2/22/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MiBandBatteryStatus) {
    MiBandBatteryLow = 1,
    MiBandBatteryCharging,
    MiBandBatteryFull,
    MiBandBatteryNotCharging
};

@interface MiBandBattery : NSObject

@property (nonatomic) NSUInteger level;
@property (strong, nonatomic) NSDate *lastCharge;
@property (nonatomic) NSUInteger charges;
@property (nonatomic) MiBandBatteryStatus status;

- (instancetype)initWithData:(NSData *)data;

@end
