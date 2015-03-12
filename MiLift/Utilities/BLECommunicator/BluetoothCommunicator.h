//
//  BluetoothCommunicator.h
//  MiLift
//
//  Created by Dimitar Topalov on 2/21/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

@protocol BluetoothCommunicatorProtocol <NSObject>
@required
- (void)bluetoothStarted;
- (void)bluetoothStopped;
- (void)discoveredPeripheral:(CBPeripheral *)peripheral  withAdvertisementData:(NSDictionary *)advertisementData andRSSI:(NSNumber *)RSSI;
- (void)didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral;
- (void)peripheralDidDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
- (void)peripheralDidUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

@end;

@interface BluetoothCommunicator : NSObject

@property (weak, nonatomic) id<BluetoothCommunicatorProtocol> delegate;

@property (strong, nonatomic, readonly) CBPeripheral *connectedPeripheral;

+ (instancetype)sharedInstance;
- (void)setServices:(NSArray *)services;
- (void)scanForPeripherals;
- (void)stopScanningForPeripherals;
- (NSArray *)retrieveConnectedPeripherals;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)readValueForCharacteristic:(CBCharacteristic *)charateristic;
- (void)observeValueForCharacteristic:(CBCharacteristic *)characteristic;
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;

@end
