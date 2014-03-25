//
//  BERViewController.h
//  セントラルPart2
//
//  Created by 下津 惇平 on 2014/02/20.
//  Copyright (c) 2014年 junP. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import AudioToolbox;

@interface BERViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSUUID *proximityUUID;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLBeaconRegion *region;

@property (nonatomic) NSNumber *currentMinor;

@property (weak, nonatomic) IBOutlet UILabel *beaconLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end