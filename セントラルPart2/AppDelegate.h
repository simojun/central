//
//  AppDelegate.h
//  セントラルPart2
//
//  Created by 下津 惇平 on 2014/02/20.
//  Copyright (c) 2014年 junP. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import AVFoundation;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSUUID *proximityUUID;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLBeaconRegion *region;

@property (strong, nonatomic) AVAudioPlayer *enter;
@property (strong, nonatomic) AVAudioPlayer *exit;

@end
