//
//  MyGaodeMap.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2017/11/30.
//  Copyright © 2017年 孙嘉斌. All rights reserved.
//

#import "MyGaodeMap.h"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface MyGaodeMap()<MAMapViewDelegate,AMapSearchDelegate, AMapLocationManagerDelegate>
@end

@implementation MyGaodeMap


//初始化高德地图
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
//    if([[AppInfoDefult sharedClict] isNaTali]){
//        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
//        self.locationManager.distanceFilter = 200.f;
//    }else{
//    }

    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        _locationManager.allowsBackgroundLocationUpdates = NO;
    }
}


//持续定位
- (void)configLocationManagerForContinuity
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    if([[AppInfoDefult sharedClict] isNaTali]){
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        self.locationManager.distanceFilter = 2.f;
    }else{
    }
    self.locationManager.distanceFilter = 2.f;
    //设置定位超时时间
    [self.locationManager setLocationTimeout:20];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:20];
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    return nil;
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager{
    [locationManager requestWhenInUseAuthorization];
}
@end
