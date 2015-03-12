//
//  MiBandBattery.m
//  MiLift
//
//  Created by Dimitar Topalov on 2/22/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import "MiBandBattery.h"
#import "NSDate+Additions.h"

@implementation MiBandBattery

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        const char *dataBytes = (const char *)data.bytes;
        self.level = dataBytes[0];
        self.charges = 0xffff & ((0xff & dataBytes[7]) | (0xff & dataBytes[8]) << 8);
        self.status = dataBytes[9];
        self.lastCharge = [NSDate dateWithYear:2000 + dataBytes[1] month:dataBytes[2] day:dataBytes[3] hour:dataBytes[4] minute:dataBytes[5] second:dataBytes[6]];
    }
    
    return  self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"MiBandBattery: Level=%lu%% Charges=%lu Status=%lu LastCharge=%@", (unsigned long)self.level, (unsigned long)self.charges, self.status, self.lastCharge];
}

@end
