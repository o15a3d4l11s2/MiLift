//
//  ViewController.m
//  MiLift
//
//  Created by Dimitar Topalov on 2/18/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import "ViewController.h"
#import "MiBandCommunicator.h"

@interface ViewController () <MiBandCommunicatorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MiBandCommunicator sharedInstance] startCommunication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bandConnected
{
    
}

- (void)bandDisconnected
{
    
}

//- (void)centralManagerDidUpdateState:(CBCentralManager *)central
//{
//    if (central.state == CBCentralManagerStatePoweredOn) {
//        [_centralManager scanForPeripheralsWithServices:nil options:nil];
//        NSLog(@"Scanning started");
//    }
//}
//
//- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
//{
//    
//    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
//    
//    if ([peripheral.name isEqualToString:@"MI"] && self.discoveredPeripheral != peripheral) {
//        self.discoveredPeripheral = peripheral;
//        NSLog(@"Connecting to peripheral %@", peripheral);
//        [self.centralManager connectPeripheral:peripheral options:nil];
//    }
//}
//
//- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
//    NSLog(@"Connected");
//    
//    [self.centralManager stopScan];
//    NSLog(@"Scanning stopped");
//    
//    [self.data setLength:0];
//    
//    peripheral.delegate = self;
//    
//    [peripheral discoverServices:nil];
//}
//
//- (void)cleanup {
//    
//    // See if we are subscribed to a characteristic on the peripheral
//    if (_discoveredPeripheral.services != nil) {
//        for (CBService *service in self.discoveredPeripheral.services) {
//            if (service.characteristics != nil) {
//                for (CBCharacteristic *characteristic in service.characteristics) {
//                    if (characteristic.isNotifying) {
//                        [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
//                        return;
//                    }
//                }
//            }
//        }
//    }
//    
//    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
//}
//
//- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
//    NSLog(@"Failed to connect");
//    [self cleanup];
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
//    if (error) {
//        [self cleanup];
//        return;
//    }
//    
//    for (CBService *service in peripheral.services) {
//        [peripheral discoverCharacteristics:nil forService:service];
//    }
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
//    if (error) {
//        [self cleanup];
//        return;
//    }
//    
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        
//        if ([characteristic.UUID.UUIDString isEqualToString:@"FF0F"]) {
//            NSLog(@"Characteristic %@", characteristic);
//            NSData *data = [@"2" dataUsingEncoding:NSUTF8StringEncoding];
//            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
//            NSLog(@"Characteristic %@", characteristic);
//        } else if ([characteristic.UUID.UUIDString isEqualToString:@"FF06"]) {
//            NSLog(@"READING STEPS");
//            [peripheral readValueForCharacteristic:characteristic];
//        } else if ([characteristic.UUID.UUIDString isEqualToString:@"FF0C"]) {
//            NSLog(@"READING BATTERY");
//            [peripheral readValueForCharacteristic:characteristic];
//        }
//    }
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if (characteristic.isNotifying) {
//        NSLog(@"Notification began on %@", characteristic);
//    } else {
//        // Notification has stopped
//        [self.centralManager cancelPeripheralConnection:peripheral];
//    }
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if (error) {
//        NSLog(@"Error");
//        return;
//    }
//    
//    NSLog(@"Data for %@ | %@", characteristic.UUID.UUIDString, characteristic.value);
//    
//    if([characteristic.UUID.UUIDString isEqualToString:@"FF06"]) {
////        var u16 = UnsafePointer<Int>(characteristic.value().bytes).memory
////        stepsView.stringValue = ("\(u16) steps")
//        NSLog(@"%@ steps", characteristic.value.bytes);
//    } else if([characteristic.UUID.UUIDString isEqualToString:@"FF0C"]) {
//        NSLog(@"%@%% charged", characteristic.value.bytes);
//    }
//}

@end
