//
//  MiBandCommunicator.h
//  MiLift
//
//  Created by Dimitar Topalov on 2/21/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MiBandCommunicatorDelegate <NSObject>
@required
- (void)bandConnected;
- (void)bandDisconnected;

@end

@interface MiBandCommunicator : NSObject

@property (weak, nonatomic) id<MiBandCommunicatorDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)startCommunication;

- (void)pair;

- (void)startVibration;
- (void)stopVibration;
- (void)vibrateForSeconds:(NSInteger)seconds;

- (void)turnOnLeds:(NSArray *)leds withColors:(NSArray *)colors;
- (void)turnOffLeds:(NSArray *)leds;
- (void)turnOffAllLeds;
- (void)testLeds;

@end
