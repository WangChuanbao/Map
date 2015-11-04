//
//  MapViewController.m
//  Map
//
//  Created by 王宝 on 15/10/22.
//  Copyright © 2015年 王宝. All rights reserved.
//

#import "MapViewController.h"
#import "Myannotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     MKMapTypeStandard：标注地图
     MKMapTypeSatellite：卫星地图
     MKMapTypeHybrid：混合地图
     */
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    /*
     跟踪用户位置和方向变化
     MKUserTrackingModeNone：没有用户跟踪模式
     MKUserTrackingModeFollow：跟踪用户位置变化
     MKUserTrackingModeFollowWithHeading：跟踪用户位置和方向变化
     */
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    //授权
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
}

- (IBAction)query:(UIButton *)sender {
    
    [self.textFild resignFirstResponder];
    
    if (self.textFild.text == nil) {
        return;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.textFild.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if (placemarks.count > 0) {
            //移除地图上所有标注点
            [self.mapView removeAnnotations:self.mapView.annotations];
            
            for (CLPlacemark *placemark in placemarks) {
                
                /*
                 调整地图位置和缩放比例
                 第一个参数：中心点
                 第二个参数：目标区域南北跨度
                 第三个参数：目标区域东西跨度
                 */
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 10000, 10000);
                [self.mapView setRegion:viewRegion];
                
                /*
                //如果标示信息时固定的可以用MKPointAnnotation
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.title = @"您的位置";
                point.subtitle = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
                point.coordinate = placemark.location.coordinate;
                [self.mapView addAnnotation:point];
                 */

                //标示点
                Myannotation *annotation = [[Myannotation alloc] init];
                //街道
                annotation.street = placemark.thoroughfare;
                //城市
                annotation.city = placemark.locality;
                //州、省
                annotation.state = placemark.administrativeArea;
                //邮编
                annotation.zip = placemark.postalCode;
                //地理位置
                annotation.coordinate = placemark.location.coordinate;
                //把标注点添加到地图上
                [self.mapView addAnnotation:annotation];

            }
        }
        
    }];
    
}

#pragma mark - MKMapViewDelegate
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"加载地图失败：%@",error);
}

//在地图上添加标示点时回调
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    //标注视图。MKPinAnnotationView，可重用。MKAnnotationView,不重用
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    //大头针标注视图颜色。紫色
    annotationView.pinColor = MKPinAnnotationColorPurple;
    //是否动画
    annotationView.animatesDrop = YES;
    //点击大头针时是否出现气泡显示附加信息
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
