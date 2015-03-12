//
//  InitialScreenViewController.m
//  MiLift
//
//  Created by Dimitar Topalov on 3/1/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

#import "InitialScreenViewController.h"
#import "MiBandCommunicator.h"

@interface InitialScreenViewController () <MiBandCommunicatorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;

@end

@implementation InitialScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MiBandCommunicator sharedInstance].delegate = self;
    [[MiBandCommunicator sharedInstance] startCommunication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bandConnected
{
    self.connectionStatusLabel.text = @"Band Connected!";
}

- (void)bandDisconnected
{
    self.connectionStatusLabel.text = @"Band Disconnected!";
}

- (IBAction)startVibrationButtonTouched
{
    [[MiBandCommunicator sharedInstance] startVibration];
}

- (IBAction)stopVibrationButtonTouched
{
    [[MiBandCommunicator sharedInstance] stopVibration];
}

- (IBAction)pairButtonTouched
{
    [[MiBandCommunicator sharedInstance] pair];
}

@end
