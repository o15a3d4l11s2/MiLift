//
//  MiBandCommunicator.m
//  MiLift
//
//  Created by Dimitar Topalov on 2/21/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import "MiBandCommunicator.h"
#import "BluetoothCommunicator.h"
#import "MiBandBattery.h"

#define MI_BAND_PERIPHERAL_NAME @"MI"

#define MI_BAND_SERVICE_UUID_MILI @"FEE0"
#define MI_BAND_SERVICE_UUID_UNKNOWN @"FEE7"

#define MI_BAND_CHARACTERISTIC_UUID_DEVICE_INFO @"FF01"
#define MI_BAND_CHARACTERISTIC_UUID_DEVICE_NAME @"FF02"
#define MI_BAND_CHARACTERISTIC_UUID_CONTROL_POINT @"FF05"
#define MI_BAND_CHARACTERISTIC_UUID_REALTIME_STEPS @"FF06"
#define MI_BAND_CHARACTERISTIC_UUID_BATTERY @"FF0C"
#define MI_BAND_CHARACTERISTIC_UUID_PAIR @"FF0F"

@interface MiBandCommunicator () <BluetoothCommunicatorProtocol>

@property (strong, nonatomic) BluetoothCommunicator *bluetoothCommunicator;
@property (nonatomic) BOOL bandConnected;

@property (strong, nonatomic) CBCharacteristic *controlPointCharacteristic;
@property (strong, nonatomic) CBCharacteristic *pairingCharacteristic;

@end

@implementation MiBandCommunicator

+ (instancetype)sharedInstance
{
    static MiBandCommunicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startCommunication
{
    self.bluetoothCommunicator = [BluetoothCommunicator sharedInstance];
    self.bluetoothCommunicator.delegate = self;
    [self.bluetoothCommunicator setServices:@[
                                              [CBUUID UUIDWithString:MI_BAND_SERVICE_UUID_MILI],
                                              [CBUUID UUIDWithString:MI_BAND_SERVICE_UUID_UNKNOWN]
                                              ]];
}

- (void)connectIfneeded
{
    if (self.bandConnected) {
        return;
    }
    
    BOOL bandPreConnected = false;
    for (CBPeripheral *peripheral in [self.bluetoothCommunicator retrieveConnectedPeripherals]) {
        if ([peripheral.name isEqualToString:MI_BAND_PERIPHERAL_NAME]) {
            // Band already connected, but not for our application
            [self.bluetoothCommunicator connectPeripheral:peripheral];
            bandPreConnected = YES;
            break;
        }
    }
    
    if (bandPreConnected) {
        return;
    }
    
    [self.bluetoothCommunicator scanForPeripherals];
}

#pragma mark - BluetoothCommunicatorProtocol
- (void)bluetoothStarted
{
    [self connectIfneeded];
}

- (void)bluetoothStopped
{
    [self handleBandDisconnected];
}

- (void)discoveredPeripheral:(CBPeripheral *)peripheral withAdvertisementData:(NSDictionary *)advertisementData andRSSI:(NSNumber *)RSSI
{
    if ([peripheral.name isEqualToString:MI_BAND_PERIPHERAL_NAME] && [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]) {
        NSLog(@"Connecting peripheral: %@, advertisementData: %@, RSSI: %@", peripheral, advertisementData, RSSI);
        [self.bluetoothCommunicator connectPeripheral:peripheral];
    }
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self handleBandConnected];
}

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral
{
    [self handleBandDisconnected];
}

- (void)peripheralDidDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_SERVICE_UUID_MILI]]) {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            NSLog(@"Characteristic %@", characteristic);
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_DEVICE_INFO]]) {
                [self.bluetoothCommunicator readValueForCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_DEVICE_NAME]]) {
                [self.bluetoothCommunicator readValueForCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_BATTERY]]) {
                [self.bluetoothCommunicator readValueForCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_REALTIME_STEPS]]) {
                [self.bluetoothCommunicator readValueForCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_CONTROL_POINT]]) {
                self.controlPointCharacteristic = characteristic;
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_PAIR]]) {
                self.pairingCharacteristic = characteristic;
                [self.bluetoothCommunicator observeValueForCharacteristic:characteristic];
            }
        }
    }
}

- (void)peripheralDidUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_DEVICE_INFO]]) {
        [self getDeviceInfo:characteristic];
    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_DEVICE_NAME]]) {
        [self getDeviceName:characteristic];
    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_BATTERY]]) {
        [self getBatteryData:characteristic];
    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_REALTIME_STEPS]]) {
        [self getRealtimeSteps:characteristic];
    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:MI_BAND_CHARACTERISTIC_UUID_PAIR]]) {
        NSLog(@"PAIRING INFO!!! %@", characteristic);
    }
}

#pragma mark - Interpret data

- (void)getDeviceInfo:(CBCharacteristic *)characteristic
{
    NSLog(@"Device Info: %@", characteristic.value);
}

- (void)getDeviceName:(CBCharacteristic *)characteristic
{
    NSLog(@"Device Name: %@", characteristic.value);
}

- (void)getBatteryData:(CBCharacteristic *)characteristic
{
    NSLog(@"Battery Data: %@", [[MiBandBattery alloc] initWithData:characteristic.value]);
}

- (void)getRealtimeSteps:(CBCharacteristic *)characteristic
{
    NSUInteger steps;
    [characteristic.value getBytes:&steps length:sizeof(characteristic.value)];
    NSLog(@"Realtime Steps: %lu", (unsigned long)steps);
}

- (void)startVibration
{
    Byte dataBytes[] = {8, 1};
    NSData *data = [NSData dataWithBytes:dataBytes length:2];
    [self.bluetoothCommunicator writeValue:data forCharacteristic:self.controlPointCharacteristic type:CBCharacteristicWriteWithResponse];
    [self testLeds];
};

- (void)stopVibration
{
    Byte dataBytes[] = {13};
    NSData *data = [NSData dataWithBytes:dataBytes length:1];
    [self.bluetoothCommunicator writeValue:data forCharacteristic:self.controlPointCharacteristic type:CBCharacteristicWriteWithoutResponse];
};

- (void)vibrateForSeconds:(NSInteger)seconds
{
    [self startVibration];
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(stopVibration) userInfo:nil repeats:NO];
};

- (void)turnOnLeds:(NSArray *)leds withColors:(NSArray *)colors{};
- (void)turnOffLeds:(NSArray *)leds{};
- (void)turnOffAllLeds{};

- (void)testLeds
{
    Byte dataBytes[] = {14, 1, 1, 1, 1};
    NSData *data = [NSData dataWithBytes:dataBytes length:5];
    [self.bluetoothCommunicator writeValue:data forCharacteristic:self.controlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)pair
{
    Byte dataBytes[] = {2};
    NSData *data = [NSData dataWithBytes:dataBytes length:1];
    [self.bluetoothCommunicator writeValue:data forCharacteristic:self.pairingCharacteristic type:CBCharacteristicWriteWithResponse];
}


- (void)handleBandConnected
{
    self.bandConnected = YES;
    [self.delegate bandConnected];
}

- (void)handleBandDisconnected
{
    self.bandConnected = NO;
    [self.delegate bandDisconnected];
}

@end
