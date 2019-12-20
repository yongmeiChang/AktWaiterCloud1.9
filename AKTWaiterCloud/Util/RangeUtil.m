//
//  RangeUtil.m
//  AKTWaiterCloud
//
//  Created by 孙嘉斌 on 2018/3/28.
//  Copyright © 2018年 孙嘉斌. All rights reserved.
//

#import "RangeUtil.h"
#import <math.h>
#define PI 3.1415926

@implementation RangeUtil

-(instancetype)init{
    if(self = [super init]){
        [self configLocationManager];
        [self initCompleteBlock];
    }
    return self;
}

-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lon1 :(double) lon2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

- (void)locAction
{
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

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
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:3];
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        _locationManager.allowsBackgroundLocationUpdates = NO;
    }
}

//高德定位返回block
- (void)initCompleteBlock
{
    __weak __typeof(self)weakSelf = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
         __strong __typeof(weakSelf)Rutil = weakSelf;
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            NSDictionary * dic = @{@"range":@""};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"localaction" object:nil userInfo:dic];
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }else{
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        NSString * str = @"";
        //有无逆地理信息，annotationView的标题显示的字段不一样

        Rutil.locaitony = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        Rutil.locaitonx = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
            
        double range =[Rutil distanceBetweenOrderBy:[Rutil.locaitonx doubleValue] :[Rutil.servicelocaitonx doubleValue] :[Rutil.locaitony doubleValue] :[Rutil.servicelocaitony doubleValue]];
        if(range>2000){
            str = @"1";
        }else{
            str = @"2";
        }
        NSDictionary * dic = @{@"range":str};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"localaction" object:nil userInfo:dic];
    };
}
@end
