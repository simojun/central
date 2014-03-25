//
//  BERViewController.m
//  セントラルPart2
//
//  Created by 下津 惇平 on 2014/02/20.
//  Copyright (c) 2014年 junP. All rights reserved.
//

#import "BERViewController.h"

@interface BERViewController ()

@end

@implementation BERViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        // CLLocationManagerの生成とデリゲートの設定
        self.manager = [CLLocationManager new];
        self.manager.delegate = self;
        
        // 生成したUUIDからNSUUIDを作成
        NSString *uuid = @"7BA32984-6F97-4789-BAF0-45DEFBB5A019";
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        
        // CLBeaconRegionを作成
        self.region = [[CLBeaconRegion alloc]
                       initWithProximityUUID:self.proximityUUID
                       identifier:@"jp.classmethod.testregion"];
        self.region.notifyOnEntry = YES;
        self.region.notifyOnExit = YES;
        self.region.notifyEntryStateOnDisplay = NO;
        
        // 領域監視を開始
        [self.manager startMonitoringForRegion:self.region];
        // 距離測定を開始
        [self.manager startRangingBeaconsInRegion:self.region];
        
        }
}

// Beaconに入ったときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self sendNotification:@"didEnterRegion"];
}

// Beaconから出たときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self sendNotification:@"didExitRegion"];
}

// Beaconとの状態が確定したときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"CLRegionStateInside");
            [self playSound:@"enter"];
            break;
        case CLRegionStateOutside:
            NSLog(@"CLRegionStateOutside");
            [self playSound:@"exit"];
            break;
        case CLRegionStateUnknown:
            NSLog(@"CLRegionStateUnknown");
            break;
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    CLProximity proximity = CLProximityUnknown;
    NSString *proximityString = @"CLProximityUnknown";
    CLLocationAccuracy locationAccuracy = 0.0;
    NSInteger rssi = 0;
    NSNumber* major = @0;
    NSNumber* minor = @0;
    
    // 最初のオブジェクト = 最も近いBeacon
    CLBeacon *beacon = beacons.firstObject;
    
    proximity = beacon.proximity;
    locationAccuracy = beacon.accuracy;
    rssi = beacon.rssi;
    major = beacon.major;
    minor = beacon.minor;
    
    CGFloat alpha = 1.0;
    switch (proximity) {
        case CLProximityUnknown:
            proximityString = @"CLProximityUnknown";
            alpha = 0.3;
            break;
        case CLProximityImmediate:
            proximityString = @"CLProximityImmediate";
            alpha = 1.0;
            break;
        case CLProximityNear:
            proximityString = @"CLProximityNear";
            alpha = 0.8;
            break;
        case CLProximityFar:
            proximityString = @"CLProximityFar";
            alpha = 0.5;
            break;
        default:
            break;
    }
    
    self.uuidLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", minor];
    self.proximityLabel.text = proximityString;
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", locationAccuracy];
    self.rssiLabel.text = [NSString stringWithFormat:@"%d", rssi];
    
    if ([minor isEqualToNumber:@1]) {
        // Beacon A
        self.beaconLabel.text = @"A";
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0.749 blue:1.0 alpha:alpha];
    } else if ([minor isEqualToNumber:@2]) {
        // Beacon B
        self.beaconLabel.text = @"B";
        self.view.backgroundColor = [UIColor colorWithRed:0.604 green:0.804 blue:0.196 alpha:alpha];
    } else if ([minor isEqualToNumber:@3]) {
        // Beacon C
        self.beaconLabel.text = @"C";
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.412 blue:0.706 alpha:alpha];
    } else {
        self.beaconLabel.text = @"-";
        self.view.backgroundColor = [UIColor colorWithRed:0.663 green:0.663 blue:0.663 alpha:1.0];
    }
    
    if (minor != nil && self.currentMinor != nil && ![minor isEqualToNumber:self.currentMinor]) {
        [self playSound:@"change"];
    }
    self.currentMinor = minor;
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


//CLLocationManagerDelegate。位置情報サービスの「オン」「オフ」の検知。iOS4.2以降
/*
 位置情報サービスの設定が変更された場合に呼ばれる。
            定数                                        説明
 kCLAuthorizationStatusNotDetermined        位置情報のリセットをした場合など
 kCLAuthorizationStatusRestricted       機能制限で位置情報サービスの利用を「オフ」から変更できないようにした場合
 kCLAuthorizationStatusDenied               位置情報サービスを「オフ」にした場合
 kCLAuthorizationStatusAuthorized           位置情報サービスを「オン」にした場合
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            break;
        default:
            break;
    }
}

- (void)sendNotification:(NSString*)message
{
    // 通知を作成する
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [[NSDate date] init];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = message;
    notification.alertAction = @"Open";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知を登録する
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


- (void)playSound:(NSString*)name
{
    //////////////////////////////////////////////////
    //
    // 音声ファイルは以下のサイトからお借りしています。
    // http://www.skipmore.com/sound/
    //
    //////////////////////////////////////////////////
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:name ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    SystemSoundID sndId;
    OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &sndId);
    if (!err) {
        AudioServicesPlaySystemSound(sndId);
    }
}

@end