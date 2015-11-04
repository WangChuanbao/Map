//
//  ViewController.m
//  Map
//
//  Created by 王宝 on 15/10/22.
//  Copyright © 2015年 王宝. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *_strLocation; //需要查询地理信息编码的地理位置
}

@end

@implementation ViewController

/*
 ios提供四种途径进行定位。
 Wi-Fi：通过wi－fi路由器地理位置信息查询，省电，经济
 蜂窝式移动电话基站：通过移动运营商基站定位。精度低，耗流量
 GPS卫星：覆盖面广，精度高，不可被遮挡，费电
 iBeacon微定位：低功耗蓝牙技术，通过多个iBeacon基站创建一个信号区域（地理围栏），设备进入该区域时，响应的应用程序便会提示用户进入这个地理围栏
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _strLocation = @"北京大学";
    
    //CLLocationManager：定位服务管理类，可提供位置信息和高度信息，监控设备进入离开某个区域，获取设备运行方向等
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    /*
     设置定位精度。精度越高，请求获取位置信息的时间越短，越耗电
     kCLLocationAccuracyBest：设备使用电池供电时最高精度
     kCLLocationAccuracyNearestTenMeters：精确到10米
     kCLLocationAccuracyHundredMeters：精确到100米
     kCLLocationAccuracyKilometer：精确到1000米
     kCLLocationAccuracyThreeKilometers：精确到3000米
     kCLLocationAccuracyBestForNavigation：导航情况下最高精度，一般有外接电源时才能使用
     */
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定义移动后获得位置信息的最小距离，单位：米
    self.locationManager.distanceFilter = 1000.0f;
    
    //用户授权。为了弹出授权对话框，需要修改plist文件。新添NSLocationAlwaysUsageDescription和NSLocationWhenInUseUsageDescription两个键,对应的文字内容可自定义
    //“使用应用程序期间”授权
    [self.locationManager requestWhenInUseAuthorization];
    //“始终”授权
    [self.locationManager requestAlwaysAuthorization];
    
}

#pragma mark - CLLocationManagerDelegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //当前位置。CLLocation对象：封装了位置高度等信息
    CLLocation *currLocation = [locations lastObject];
    
    //经度
    NSString *latitude = [NSString stringWithFormat:@"%3.5f",currLocation.coordinate.latitude];
    //纬度
    NSString *longitude = [NSString stringWithFormat:@"%3.5f",currLocation.coordinate.longitude];
    //高度
    NSString *altitude = [NSString stringWithFormat:@"%3.5f",currLocation.altitude];
    
    NSLog(@"经度：%@,纬度：%@,高度：%@",latitude,longitude,altitude);
    
    //地理信息反编码
    [self locationAntiEncoding:currLocation];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

//授权状态发生变化时调用。也可以用CLLocationManager的静态方法authorizationStatus获取授权信息
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    //始终可以使用
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        
    }
    //使用应用程序时授权
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
    }
    //禁用
    else if (status == kCLAuthorizationStatusDenied) {
        
    }
    //用户尚未选择
    else if (status == kCLAuthorizationStatusNotDetermined) {
        
    }
    //受限制
    else if (status == kCLAuthorizationStatusRestricted) {
        
    }
    
}

/**
 *  地理信息反编码。使用CLGeocoder类
 */
- (void)locationAntiEncoding:(CLLocation *)location {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //进行地理信息反编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if (placemarks.count > 0) {
            
            //CLPlacemark类：封装地理位置文字描述信息
            CLPlacemark *placemark = placemarks[0];
            
            //地址信息的字典,其中的键在AddressBook.framework框架中定义
            NSDictionary *addressDictionary = placemark.addressDictionary;
            
            //街道信息
            NSString *address = [addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
            address = address == nil ? @"" : address;
            
            //州、省信息
            NSString *state = [addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
            state = state == nil ? @"" : state;
            
            //市等信息
            NSString *city = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
            city = city == nil ? @"" : city;
            
            NSLog(@"%@省%@市%@街道",state,city,address);
            
        }
        
    }];
    
}

//地理信息编码查询
- (IBAction)geocodeQuery:(UIButton *)sender {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //不知定查询范围查询
    [geocoder geocodeAddressString:_strLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        NSLog(@"%lu",placemarks.count);
        
        if (placemarks.count > 0) {
            
            for (CLPlacemark *placemark in placemarks) {
                NSDictionary *addressDictionary = placemark.addressDictionary;
                
                NSString *state = [addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
                state = state == nil ? @"" : state;
                
                NSString *city = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
                city = city == nil ? @"" : city;
                
                NSString *stree = [addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
                stree = stree == nil ? @"" : stree;
                
                CLLocation *location = placemark.location;
                NSString *string = [NSString stringWithFormat:@"经度：%3.5f,纬度：%3.5f",location.coordinate.latitude,location.coordinate.longitude];
                NSString *string1 = [NSString stringWithFormat:@"%@%@%@",state,city,stree];
                
                NSLog(@"%@\n%@",string,string1);
            }
            
        }
        
    }];
}

/**
 *  指定查询范围进行查询
 */
- (void)geocoderQuery {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //经纬度
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(45.75248, 126.63758);
    /*
     第一个参数：中心
     第二个参数：半径
     第三个参数：为区域指定一个标识，保证在应用中惟一
     */
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:1000.0f identifier:@"GeocodeRegion"];
    [geocoder geocodeAddressString:_strLocation inRegion:region completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //与不指定查询范围查询一样
        //............
        
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
