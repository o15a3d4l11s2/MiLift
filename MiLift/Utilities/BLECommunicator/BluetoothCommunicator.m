//
//  BluetoothCommunicator.m
//  MiLift
//
//  Created by Dimitar Topalov on 2/21/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import "BluetoothCommunicator.h"

@interface BluetoothCommunicator () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic, readwrite) CBPeripheral *connectedPeripheral;
@property (strong, nonatomic) NSArray *services;

@end

@implementation BluetoothCommunicator

+ (instancetype)sharedInstance
{
    static BluetoothCommunicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:sharedInstance queue:nil];
        sharedInstance.centralManager = centralManager;
    });
    
    return sharedInstance;
}

- (void)scanForPeripherals
{
    if (!self.services.count) {
        NSLog(@"Warning! Bluetooth services not set. Scaning for all kinds of devices.");
    }
    
    [self.centralManager scanForPeripheralsWithServices:self.services options:nil];
}

- (void)stopScanningForPeripherals
{
    [self.centralManager stopScan];
}

- (NSArray *)retrieveConnectedPeripherals
{
    if (!self.services.count) {
        NSLog(@"Warning! Bluetooth services not set. Cannot retrieve connected peripherals.");
        return nil;
    }
    return [self.centralManager retrieveConnectedPeripheralsWithServices:self.services];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManager stopScan];
    self.connectedPeripheral = peripheral;
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)readValueForCharacteristic:(CBCharacteristic *)charateristic
{
    [self.connectedPeripheral readValueForCharacteristic:charateristic];
}

- (void)observeValueForCharacteristic:(CBCharacteristic *)characteristic
{
    [self.connectedPeripheral setNotifyValue:YES forCharacteristic:characteristic];
}

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type
{
    [self.connectedPeripheral writeValue:data forCharacteristic:characteristic type:type];
}

#pragma mark - CBCentralManagerDelegate

// Invoked when a connection is successfully created with a peripheral.
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:self.services];
    
    if (peripheral.state == CBPeripheralStateConnected) {
        [self.delegate didConnectPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (peripheral.state == CBPeripheralStateDisconnected) {
        [self.delegate didDisconnectPeripheral:peripheral];
    }
}

// Invoked when the central manager discovers a peripheral while scanning.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    [self.delegate discoveredPeripheral:peripheral withAdvertisementData:advertisementData andRSSI:RSSI];
}

// Invoked when the central manager’s state is updated. (required)
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *bleHardwareState;
    
    // Determine the state of the peripheral
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:   bleHardwareState = @"powered off";                  break;
        case CBCentralManagerStatePoweredOn:    bleHardwareState = @"powered on and ready";         break;
        case CBCentralManagerStateResetting:    bleHardwareState = @"resetting";                    break;
        case CBCentralManagerStateUnauthorized: bleHardwareState = @"unauthorized";                 break;
        case CBCentralManagerStateUnknown:      bleHardwareState = @"unknown";                      break;
        case CBCentralManagerStateUnsupported:  bleHardwareState = @"unsupported on this platform"; break;
        default: break;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.delegate bluetoothStarted];
    } else {
        [self.delegate bluetoothStopped];
    }
    
    NSLog(@"CoreBluetooth BLE hardware state is %@", bleHardwareState);
}

#pragma mark - CBPeripheralDelegate

// Invoked when you discover the peripheral’s available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    [self.delegate peripheralDidDiscoverCharacteristicsForService:service error:error];
}

// Invoked when you retrieve a specified characteristic’s value, or when the peripheral device notifies your app that the characteristic’s value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self.delegate peripheralDidUpdateValueForCharacteristic:characteristic error:error];
}

// Invoked when you write data to a characteristic’s value.
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Wrote data with error: %@", error);
}

@end
